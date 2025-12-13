include <../../lib/primitives.scad>
include <../../lib/constants.scad>

$fn = 360;

depth = 8.6;

notch_depth = 1.5;
notch_height = 2;

notch_chord = 15;

notch_circle_radius = 12.5;
notch_circle_offset = 10;

chamfer = 0.8;

to66_outer = 62.5;
to82_inner = 82.0;

module notch_sketch(r) {
  polygon(
    [
      [r + TINY, 0],
      [r - notch_depth, notch_height - chamfer],
      [r - notch_depth + chamfer, notch_height],
      [r + TINY, notch_height],
    ]
  );
}

module notch(outer, notch_radius) {
  sector = asin(notch_chord / 2 / outer);
  intersection() {
    rotate([0, 0, -sector / 2])
      rotate_extrude()
        notch_sketch(r=outer);

    translate([outer + notch_radius - notch_depth, 0, 0])
      cylinder(h=notch_height, r=notch_radius, center=false);
  }
}

module twist_off(outer, notch_radius, n, wall) {
  translate([0, 0, depth - notch_height]) {
    for (i = [0:n - 1])
      rotate([0, 0, i * 360 / n])
        notch(outer, notch_radius);
  }

  linear_extrude(depth)
    difference() {
      circle(r=outer + wall);
      circle(r=outer);
    }
}

module to66(wall = 1) {
  twist_off(outer=to66_outer / 2, notch_radius=10, n=4, wall=wall);
}

module to82(wall = 1) {
  outer = to82_inner / 2 + notch_depth + TOLERANCE;
  twist_off(outer=outer, notch_radius=10, n=6, wall=wall);
}

to66();
translate([0, 0, -1])
  cylinder(h=1 + TINY, r=to66_outer / 2 + 1, center=false);
