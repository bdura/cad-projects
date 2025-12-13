include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

diameter = 10 + TOLERANCE;
wall = 6;

length = 100;

slit = 1;

module sketch() {
  difference() {
    translate([-diameter / 2 - wall, 0])
      square(size=[diameter + 2 * wall, diameter + 2 * wall], center=false);

    translate([0, diameter / 2 + wall])
      circle(r=diameter / 2);

    translate([-diameter / 2, diameter / 2 + wall])
      square([diameter, diameter / 2 + wall + TINY]);
  }
}

difference() {
  translate([0, length / 2, 0])
    rotate([90, 0, 0])
      linear_extrude(length)
        sketch();

  translate([-diameter / 2 - wall - TINY, -slit / 2, wall])
    cube([diameter + 2 * wall + 2 * TINY, slit, diameter + wall + TINY]);
}
