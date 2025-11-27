include <../../lib/primitives.scad>
include <../../lib/constants.scad>

use <./elements.scad>;

$fn = 360;

hand = "left";

thickness = 3;

// Contour
countour_width = 1.5;
contour_tolerance = 0.2;
contour_height = 3;

// Perforations
perforation_depth = 1;
columns_offset = 0.2;

// Magnets
magnet_wall = 0.4;
magnet_height = 2;
magnet_tolerance = 0.05;

// Bumpers
bumper_height = 2.6;
bumper_depth = (bumper_height) / 2 + TOLERANCE;

module body_with_contour(hand) {
  offset(countour_width + contour_tolerance)
    body(hand);
}

module contour(hand) {
  offset(0.3)
    offset(-0.3)
      difference() {
        offset(countour_width + contour_tolerance)
          body(hand);

        offset(contour_tolerance)
          body(hand);

        cables(hand);
      }
}

module columns(hand) {
  hull() left_column(hand);
  hull() right_column(hand);
}

module perforated(hand) {
  difference() {
    linear_extrude(thickness)
      body_with_contour(hand);

    translate(v=[0, 0, thickness - perforation_depth])
      linear_extrude(perforation_depth + TINY)
        union() {
          perforations(hand);

          offset(columns_offset)
            columns(hand);
        }
  }
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

module bumps_perforations(hand) {
  translate(v=[0, 0, -TINY])
    linear_extrude(bumper_depth + TINY)
      bumps(hand);
}

module case(hand) {
  w = thickness + contour_height;

  linear_extrude(w)
    contour(hand);

  difference() {
    perforated(hand);
    magnet_perforations(hand);
    bumps_perforations(hand);
  }
}

module magnet_test() {
  difference() {
    linear_extrude(thickness)
      offset(2)
        square(size=10, center=true);

    translate(v=[0, 0, magnet_wall])
      linear_extrude(thickness)
        offset(magnet_tolerance)
          circle(3);

    translate(v=[0, 0, -TINY])
      linear_extrude(thickness)
        offset(-2)
          circle(3);
  }
}

module bumper_test() {
  difference() {
    linear_extrude(thickness)
      offset(2)
        square([20, 10], center=true);

    for (i = [0:1]) {
      translate(v=[(-1 + i * 2) * 5.5, 0, -TINY])
        linear_extrude(bumper_depth + TINY)
          circle(4);
    }
  }
}

case("right");
