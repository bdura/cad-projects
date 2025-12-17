include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>

include <../lib/primitives.scad>
include <../lib/constants.scad>
include <./lids/twist_off.scad>

$fn = 360;

// Wall size
wall = 1;

// Width of the jar glass
jar_diameter = 60;
jar_threading_depth = 2;
jar_width = 2;

// Cap dimensions.
cap_inner_diameter = jar_diameter + 2 * jar_threading_depth;
cap_width = 2;
cap_height = 11;
cap_top_width = jar_threading_depth + jar_width + 1;
cap_top_wall = 1.5;

// Cone
cone_height = 40;
cone_opening_diameter = 3;

// Perforations
cone_hole_height = 0.7;
cone_hole_period = 3;
cone_hole_n_by_line = 10;
cone_hole_ratio = 0.8;

module cap() {

  inner = to66_outer / 2;
  outer = inner + cap_width;

  to66(cap_width);

  linear_extrude(cap_top_wall)
    ring(inner - cap_top_width, outer);
}

module cone() {
  inner = cap_inner_diameter / 2 - cap_top_width;
  hole = cone_opening_diameter / 2;
  height = cone_height;

  rotate_extrude()
    polygon(
      [
        [inner, 0],
        [inner + wall, 0],
        [hole + wall, height],
        [hole, height],
      ]
    );
}

module line_holes(inner, outer) {
  outer = cap_inner_diameter / 2 - cap_top_width;

  n = cone_hole_n_by_line;
  ratio = cone_hole_ratio;
  height = cone_hole_height;

  angle = 360 / n;

  linear_extrude(height)for (i = [0:n]) {
    rotate(i * angle)
      rotate((1 - ratio) * angle / 4)
        intersection() {
          ring(cone_opening_diameter / 2 - TINY, outer + TINY);
          arc(outer + wall, angle / 2 * ratio);
        }
  }
}

module perforated_cone() {
  angle = 360 / cone_hole_n_by_line;

  hoffset = wall + cone_hole_period;
  max_height = cone_height - cone_hole_period;

  n = floor((max_height - hoffset) / cone_hole_period);

  difference() {
    cone();

    for (i = [0:n]) {
      translate([0, 0, i * cone_hole_period])
        translate([0, 0, hoffset])
          rotate(i * angle / 2)
            line_holes();
    }
  }
}

module trap() {
  cap();
  perforated_cone();
}

trap();
