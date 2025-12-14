include <../../lib/primitives.scad>
include <../../lib/constants.scad>

$fn = 360;

depth = 10;

notch_depth = 2.2;
notch_height = 3;

notch_chord = 17;

chamfer = 1;

to66_outer = 63.6;
to82_outer = 81.6;

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

    translate([outer + notch_radius - 1.0 * notch_depth, 0, 0])
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
  twist_off(outer=to82_outer / 2, notch_radius=10, n=6, wall=wall);
}

to82(1.5);
translate([0, 0, -1])
  linear_extrude(1 + TINY)
    difference() {
      circle(r=to82_outer / 2 + 1.5);
      circle(r=to82_outer / 2 - 8);
    }
