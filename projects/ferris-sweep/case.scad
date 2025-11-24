include <../../lib/primitives.scad>
include <../../lib/constants.scad>

use <./elements.scad>;

$fn = 360;

countour_width = 1;
contour_tolerance = 0.2;

height = 3;
wall_height = 2;

perforation = 1;

magnet_wall = 0.4;
magnet_height = 2;

bumps_height = 2.6;
bumps_depth = (bumps_height) / 2;

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

        trrs(hand);
      }
}

module perforated(hand) {
  difference() {
    linear_extrude(height)
      body_with_contour(hand);

    translate(v=[0, 0, height - perforation])
      linear_extrude(perforation + TINY)
        holes(hand);
  }
}

module magnet_perforations(hand) {
  translate(v=[0, 0, magnet_wall])
    linear_extrude(height)
      magnets(hand);

  translate(v=[0, 0, -TINY])
    linear_extrude(height)
      offset(-2)
        magnets(hand);
}

module bumps_perforations(hand) {
  translate(v=[0, 0, -TINY])
    linear_extrude(bumps_depth + TINY)
      bumps(hand);
}

module case(hand) {
  w = height + wall_height;

  linear_extrude(w)
    contour(hand);

  difference() {
    perforated(hand);
    magnet_perforations(hand);
    bumps_perforations(hand);
  }
}

case("right");
