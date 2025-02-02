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

// Envelope
envelope_top_radius = 90;
envelope_bottom_radius = 10;
envelope_height = 90;

assert(2 * envelope_bottom_radius >= outlet_diameter);

// Anchors
side_anchor = 10;

// Crest
crest_height = 30;

// Perforations
perforation_n = 20;
perforation_ratio = 0.3;

perforation_height = 3;
perforation_offset = 4;

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

  points = polyRound([
    [       br,        0, 0],
    [       br,        h, tr],
    [       tr,        h, 0],
    [       tr,   h + ch, 0],
    [tr + wall,   h + ch, 0],
    [tr + wall, h - wall, 0],
    [br + wall, h - wall, tr - wall],
    [br + wall,        0, 0],
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

module back_wall() {
  tr = envelope_top_radius;
  br = envelope_bottom_radius;
  h = envelope_height;
  ch = crest_height;

  points = polyRound([
    [+br + side_anchor, 0, 0],
    [+br + side_anchor, h - side_anchor, tr],
    [+tr + side_anchor, h - side_anchor, 0],
    [+tr + side_anchor, h + ch, 0],
    [-(tr + side_anchor), h + ch, 0],
    [-(tr + side_anchor), h - side_anchor, 0],
    [-(br + side_anchor), h - side_anchor, tr],
    [-(br + side_anchor), 0, 0],
  ], fn=$fn);

  rotate([90, 0, 0])
  translate([0, 0, TINY])
  linear_extrude(wall)
  polygon(points);
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

module main() {
  difference() {
    envelope();
    #perforations();
  }
  back_wall();
}

main();
