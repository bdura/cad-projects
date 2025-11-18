include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>
use <Round-Anything/polyround.scad>

include <../../lib/primitives.scad>
include <../../lib/constants.scad>

$fn = 360;

// Wall size
wall = 2;

// General dimensions
radius = 50;
height = 200;

// Anchors
base_anchor = 20;
side_anchor = 15;
inner_anchor = 10;

// Perforations
perforation_n = 12;
perforation_ratio = 0.3;

perforation_height = 3;
perforation_offset = 4;

// Outlet
outlet_diameter = 15;

module perforations() {
  n = perforation_n;
  r = perforation_ratio;

  h = perforation_height;
  o = perforation_offset;

  period = 360 / n;
  angle = r * period;
  delta = period - angle;

  n2 = floor(n / 2);

  total_height = height - wall - o;
  lines = floor(total_height / (h + o));

  for (i = [0:lines - 1]) {
    n_eff = i % 2 == 0 ? n2 : n2 - 1;
    oa_eff = i % 2 == 0 ? 0 : period / 2;
    
    translate([0, 0, wall + o + i * (h + o)])
    linear_extrude(h)
    for(j = [0:n_eff - 1]) {
      rotate(j * period)
      rotate(oa_eff)
      rotate([0, 0, delta / 2])
      arc_ring(radius - 2 * wall, radius + 2 * wall, angle);
    }

  }
}


module filleted_wall() {
  offset(1)offset(-2)offset(1)
  union() {
    arc_ring(radius, radius + wall, 5);

    translate([radius + wall / 2, 0])
    square([3 * wall, wall], center=true);
  }
}


module main_wall_sketch() {
    difference() {
      ring(radius, radius + wall);

      translate([0, -radius])
      square([3 * radius, 2 * radius], center = true);
    }

    filleted_wall();

    mirror([1, 0])
    filleted_wall();
  }


module main_wall() {
  difference() {
    linear_extrude(height)
    main_wall_sketch();

    #perforations();
  }
}

module back_wall() {
  rotate([-90, 0, 0])
  rotate([0, 0, -90])
  translate([0, 0, -wall / 2])
  linear_extrude(wall)
  translate([height / 2, 0])
    difference() {
      polygon([
        [-height / 2, radius + base_anchor],
        [+height / 2, radius + wall],
        [+height / 2, - (radius + wall)],
        [-height / 2, - (radius + base_anchor)],
      ]);
      square([height - 2 * (inner_anchor), 2 * (radius - inner_anchor)], center=true);
    }
}

module main() {
  main_wall();
  back_wall();

  linear_extrude(wall)
    arc_ring(radius - inner_anchor, radius + base_anchor, 180);
}

main();
