include <../../lib/primitives.scad>
include <../../lib/constants.scad>

$fn = 360;

beam_length = 300;
beam_radius = 5;
beam_offset = 10;

module beam() {
  translate([0, 0, beam_offset])
    cylinder(h=beam_length, r=beam_radius, center=false);
}

module side() {
  a = beam_length + 2 * beam_offset;
  h = a * sqrt(3) / 2;

  translate([h / 3, 0, 0])
    rotate([90, 0, 0])
      translate([0, 0, -a / 2])
        beam();

  angle = 90 - acos(1 / sqrt(3));
  translate([h / 3, a / 2, 0])
    rotate([0, 0, 60])
      rotate([0, -angle, 0])
        beam();
}

module tetrahedron() {
  for (i = [0:2])
    rotate([0, 0, i * 120])
      side();
}

tetrahedron();

translate([0, 0, beam_length])
  mirror([0, 0, 1])
    rotate([0, 0, 60])
      tetrahedron();
