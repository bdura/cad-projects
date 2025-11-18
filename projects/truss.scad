include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>

include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

side = 5;

total_length = 120;

mouth_opening = 0.3;
mouth_notch_offset = 5;

module notch_full() {
  scale = 1.0 - mouth_opening / side * 2.0;

  translate(v=[0, 0, mouth_opening])
    mirror(v=[0, 0, 1])
      linear_extrude(mouth_opening, scale=scale)
        square(size=side, center=true);

  translate(v=[0, 0, -mouth_opening])
    linear_extrude(mouth_opening + TINY, scale=scale)
      square(size=side, center=true);

  translate(v=[0, 0, mouth_opening - TINY])
    linear_extrude(mouth_notch_offset - mouth_opening + TINY)
      square(size=side, center=true);
}

module notch() {
  translate(v=[0, 0, mouth_opening])
    difference() {
      notch_full();

      linear_extrude(mouth_notch_offset + TINY) {
        square(size=[side + TINY, mouth_opening], center=true);
        square(size=[mouth_opening, side + TINY], center=true);
      }
    }
}

module beam() {
  length = total_length - 2 * mouth_notch_offset;
  rotate([90, 0, 0])
    translate(v=[side / 2.0, side / 2.0, mouth_notch_offset + mouth_opening]) {
      mirror([0, 0, 1])
        notch();

      translate([0, 0, length])
        notch();

      translate([0, 0, -TINY])
        linear_extrude(length + 2 * TINY)
          square(size=side, center=true);
    }
}

beam();
