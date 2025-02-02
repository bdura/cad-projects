include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>
use <Round-Anything/polyround.scad>

include <../../lib/primitives.scad>
include <../../lib/constants.scad>

$fn = 360;

// Box dimensions
spill_to_top = 74.3;
buldge_to_top = 18.2;
buldge_depth = 5;
handle_width = 123.7;

box_width = 280;
box_height = 210;
box_length = 365;

// Wall size
wall = 1;

// Outlet
outlet_diameter = 20;
outlet_wall = 3;
outlet_bend_radius = 15;
outlet_hlength = 20;
outlet_vlength = 5;
outlet_mouth_width = 10;

// Envelope
envelope_top_radius = 45;
envelope_bottom_radius = 10;
envelope_height = 70;
envelope_min_angle = 40;

assert(2 * envelope_bottom_radius >= outlet_diameter);

// Anchors
inner_anchor = 10;
outer_anchor = 10;

// Crest
crest_height = 50;

// Perforations
perforation_n = 16;
perforation_ratio = 0.4;

perforation_height = 2;
perforation_offset = 3;

module perforations() {
  n = perforation_n;
  r = perforation_ratio;

  h = perforation_height;
  o = perforation_offset;

  period = 360 / n;
  angle = r * period;
  delta = period - angle;

  n2 = floor(n / 2);

  start_h = envelope_height + o + wall;
  total_height = crest_height - o;
  lines = floor(total_height / (h + o));

  for (i = [0:lines - 1]) {
    n_eff = i % 2 == 0 ? n2 : n2 - 1;
    oa_eff = i % 2 == 0 ? 0 : period / 2;
    
    translate([0, 0, start_h + i * (h + o)])
    linear_extrude(h)
    for(j = [0:n_eff - 1]) {
      rotate(j * period)
      rotate(oa_eff)
      rotate([0, 0, delta / 2])
      arc_ring(envelope_top_radius - 2 * wall, envelope_top_radius + 2 * wall, angle);
    }

  }
}

module envelope_sketch() {
  h = envelope_height;
  tr = envelope_top_radius;
  br = envelope_bottom_radius;
  ch = crest_height;
  w = wall;

  midheight = h - (tr - br) * tan(envelope_min_angle);

  points = polyRound([
    [       br,                0, 0],
    [       br,        midheight, tr],
    [       tr,                h, 0],
    [       tr,           h + ch, 0],
    [tr + wall,           h + ch, 0],
    [tr + wall,         h - wall, 0],
    [br + wall, midheight - wall, tr],
    [br + wall,                0, 0],
  ], fn=$fn);

  polygon(points);
}

module envelope() {
  difference() {
    rotate_extrude()
      envelope_sketch();

    h = envelope_height + crest_height;
    w = 2 * (envelope_top_radius + wall);

    translate([0, - w / 2, h / 2 - 2 * TINY])
      cube([2 * w, w, 2 * h], center = true);
  }
}

module back_wall_half() {
  tr = envelope_top_radius;
  br = envelope_bottom_radius;
  h = envelope_height;
  ch = crest_height;

  midheight = h - (tr - br) * tan(envelope_min_angle);

  points = polyRound([
    [0, -outlet_diameter / 2 - outer_anchor, 0],
    [br + outer_anchor, -outlet_diameter / 2 - outer_anchor, outlet_diameter / 2 + outer_anchor],
    [br + outer_anchor, 0, 0],
    [br + outer_anchor, midheight - outer_anchor / 2, tr],
    [tr + outer_anchor, h - outer_anchor / 2, outer_anchor],
    [tr + outer_anchor, h + ch, 0],
    [tr - inner_anchor, h + ch, 0],
    [tr - inner_anchor, h + inner_anchor / 2, inner_anchor],
    [br - inner_anchor, midheight, tr],
    [br - inner_anchor, 0, 0],
  ], fn=$fn);

  polygon(points);
}

module back_wall() {
  rotate([90, 0, 0])
  translate([0, 0, TINY])
  linear_extrude(wall) {
    back_wall_half();

    mirror([1, 0])
    back_wall_half();

    translate([0, (outer_anchor + inner_anchor)])
    square([2 * (envelope_bottom_radius + outer_anchor), 2 * (outer_anchor + inner_anchor)], center = true);
  }
}

module box() {
  w = wall + buldge_depth;

  translate([0, 0, -box_height / 2])
  difference() {
    cube([box_width, box_length, box_height], center = true);

    translate([0, 0, w + TINY])
    cube([box_width - 2 * w, box_length - 2 * w, box_height - 2 * w], center = true);

    translate([0, 0, (box_height - buldge_to_top) / 2 + TINY])
    cube([box_width - buldge_depth, box_length - buldge_depth, buldge_to_top], center = true);
  }
}

module quarter_sphere() {
  // hollow_shere
  difference() {
    sphere(outlet_diameter / 2 + wall);
    sphere(outlet_diameter / 2);

    translate([0, 0, outlet_diameter / 2 + wall + TINY])
    cube(outlet_diameter + 2 * wall + TINY, center = true);

    translate([0, outlet_diameter / 2 + wall + TINY, 0])
    cube(outlet_diameter + 2 * wall + TINY, center = true);
  }
}

module main() {
  difference() {
    envelope();
    #perforations();
  }
  difference() {
    back_wall();

    rotate([90, 0, 0])
    cylinder(4 * wall, d = outlet_diameter, center = true);
  }

  translate([0, 0, TINY])
  mirror([0, 1, 0])
  quarter_sphere();
}

module pipe_mouth_sketch() {
  r = outlet_diameter / 2;
  mw = outlet_mouth_width;
  w = outlet_wall;

  polygon([
    [r, 0],
    [r + mw, 0],
    [r + mw, w],
    [r, mw],
  ]);
}

module pipe_sketch(w) {
  difference() {
    circle(d=outlet_diameter + w);
    circle(d=outlet_diameter);
  }
}

module pipe() {
  r = outlet_bend_radius;
  h = outlet_hlength;
  v = outlet_vlength;

  rotate([0, 90, 0])
  rotate_extrude()
  pipe_mouth_sketch();

  translate([h, 0, 0]) {
    translate([TINY, 0, 0])
    rotate([0, -90, 0])
    linear_extrude(h)
    pipe_sketch(outlet_wall);

    translate([r, 0, -v -r + TINY])
    linear_extrude(v)
    pipe_sketch(outlet_wall);

    rotate([90, 0, 0])
    translate([0, -r])
    rotate_extrude(90)
    translate([r, 0])
    pipe_sketch(outlet_wall);
  }
}

//main();

rotate([0, 0, -90])
pipe();
