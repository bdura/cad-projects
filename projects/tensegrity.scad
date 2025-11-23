include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>

include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

side = 5;

beam_length = 120;

slit_width = 0.4;
slit_depth = 5;

module hole() {
  rotate([90, 0, 0])
    cylinder(h=side + 2 * TINY, r=slit_width, center=true);
}

module slit() {
  translate([slit_depth / 2, 0, 0])
    cube(size=[slit_depth + TINY, slit_width, side + 2 * TINY], center=true);
}

module beam() {
  h = beam_length;
  d = slit_depth;

  difference() {
    rotate([0, 90, 0])
      translate(v=[0, 0, -h / 2])
        linear_extrude(h)
          square(size=side, center=true);

    for (i = [0:1]) {
      mirror([i * 1, 0, 0]) {
        translate([h / 2 - d, 0, 0])
          slit();

        translate([h / 2 - d, 0, 0])
          hole();
      }
    }
  }
}

beam();
