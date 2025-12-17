include <../../lib/primitives.scad>
include <../../lib/constants.scad>

use <./elements.scad>;

$fn = 360;

minimum_wall = 1;

thickness = 3;
tenting_clearance = 2.0;
chamfer = 1.5;

assert(thickness > chamfer);

// Tenting screws
screw_hole_diameter = 2.9;
screw_hole_depth = 3.5;
screw_hole_wall = 1.0;

assert(screw_hole_depth < thickness + tenting_clearance);

// Contour
contour_width = 1.5;
contour_tolerance = 0.6;
contour_overheight = 2.2;

// Magnets
magnet_wall = 0.4;
magnet_height = 2;
magnet_tolerance = 0.05;

assert(magnet_wall + magnet_height < thickness);

// Bumpers
bumper_height = 2.6;
bumper_depth = (bumper_height) / 2 + TOLERANCE;

assert(bumper_depth < thickness - minimum_wall);

module body_with_contour(hand) {
  offset(contour_width + contour_tolerance)
    body(hand);
}

module chamfered_base(hand) {
  minkowski($fn=72) {
    linear_extrude(TINY)
      offset(contour_width + contour_tolerance - chamfer, $fn=72)
        body(hand);
    cylinder(d1=0, d2=chamfer * 2, h=chamfer, $fn=72);
  }
}

module contour(hand) {
  offset(0.3)
    offset(-0.3)
      difference() {
        offset(contour_width + contour_tolerance)
          body(hand);

        offset(contour_tolerance)
          body(hand);

        cables(hand);
      }
}

module base(hand) {
  top_radius = screw_hole_diameter / 2 + screw_hole_wall;
  bottom_radius = top_radius + screw_hole_wall;

  translate([0, 0, chamfer - TINY])
    linear_extrude(thickness - chamfer + 2 * TINY)
      body_with_contour(hand);

  chamfered_base(hand);

  for (quadrant = ["east", "north", "west", "south"])
    translate([0, 0, thickness - TINY])
      individual_tent(hand=hand, quadrant=quadrant)
        cylinder(h=tenting_clearance + TINY, r1=bottom_radius, r2=top_radius);
}

module magnet_perforations(hand) {
  translate(v=[0, 0, magnet_wall])
    linear_extrude(thickness)
      offset(magnet_tolerance)
        magnets(hand);

  translate(v=[0, 0, -TINY])
    linear_extrude(thickness)
      offset(-2)
        magnets(hand);
}

module screw_perforations(hand) {
  for (quadrant = ["east", "north", "west", "south"])
    translate([0, 0, thickness + tenting_clearance - screw_hole_depth])
      individual_tent(hand=hand, quadrant=quadrant)
        cylinder(h=screw_hole_depth + TINY, r=screw_hole_diameter / 2);
}

module bumps_perforations(hand) {
  translate(v=[0, 0, -TINY])
    linear_extrude(bumper_depth + TINY)
      bumps(hand);
}

module case(hand) {
  translate([0, 0, chamfer])
    linear_extrude(thickness + tenting_clearance + contour_overheight - chamfer)
      contour(hand);

  difference() {
    base(hand);
    screw_perforations(hand);
    magnet_perforations(hand);
    bumps_perforations(hand);
  }
}

translate([2, 0, 0])
  case("left");
translate([-2, 0, 0])
  case("right");
