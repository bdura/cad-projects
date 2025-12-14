include <../../lib/primitives.scad>
include <../../lib/constants.scad>

$fn = 360;

beam_length = 300;
beam_radius = 5;
beam_offset = 15;
beam_tolerance = 0.0;

wall = 1.5;
rope_diameter = 2.5;
chamfer = 0.4;

lock_top = 9;
lock_bottom = 22;
attachment_height = 2;
attachment_offset = 6.5;

module beam(tolerance = 0) {
  translate([0, 0, beam_offset])
    cylinder(h=beam_length, r=beam_radius + tolerance, center=false);
}

module side() {
  a = beam_length + 2 * beam_offset;
  h = a * sqrt(3) / 2;
  angle = 90 - acos(1 / sqrt(3));

  translate([h / 3, 0, 0])
    rotate([90, 0, 0])
      translate([0, 0, -a / 2])
        beam();

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

module lock_beams(remove_offset = false) {
  a = beam_length + 2 * beam_offset;
  h = a * sqrt(3) / 2;
  angle = 90 - acos(1 / sqrt(3));

  dz = remove_offset ? a - beam_offset : a;

  for (i = [0:2])
    rotate([0, 0, i * 120])
      rotate([0, angle, 0])
        translate([0, 0, -dz])
          beam(tolerance=beam_tolerance);
}

module lock_cut(dz) {
  offset(wall)
    hull()
      projection(cut=true)
        translate([0, 0, dz])
          lock_beams(remove_offset=true);
}

module lock_hull() {
  hull() {
    translate([0, 0, lock_bottom - lock_top - TINY])
      linear_extrude(TINY)
        lock_cut(dz=lock_top);

    linear_extrude(TINY)
      lock_cut(dz=lock_bottom);
  }
}

module lock() {
  difference() {
    lock_hull();

    translate([0, 0, lock_bottom])
      lock_beams();
  }
}

module attachment() {
  clearance = 2 * rope_diameter;
  d1 = 3.5 * rope_diameter + 2 * attachment_height;
  d2 = 2 * rope_diameter + attachment_height;

  difference() {
    translate([0, 0, -TINY])
      cylinder(h=attachment_height + clearance + TINY, d1=d1, d2=d2, center=false);

    rotate([90, 0, 0])
      translate([0, 0, -d1 / 2 - TINY])
        linear_extrude(d1 + 2 * TINY)
          polygon(
            [
              [-attachment_height + chamfer, -2 * TINY],
              [-attachment_height, chamfer],
              [0, attachment_height],
              [attachment_height, chamfer],
              [attachment_height - chamfer, -2 * TINY],
            ]
          );
  }
}

difference() {
  lock();

  attachment();

  // complementary angle between face and the z-axis
  tan_angle = 1 / 2 / sqrt(2);
  angle = atan(tan_angle);

  d = lock_bottom * tan_angle + (beam_radius + beam_tolerance + wall) / cos(angle);

  for (i = [0:2])
    rotate([0, 0, i * 120])
      translate([-attachment_offset * tan_angle, 0, attachment_offset])
        translate([d, 0, 0])
          rotate([0, -90 - angle, 0])
            attachment();
}
