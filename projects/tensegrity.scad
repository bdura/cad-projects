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

guide_height = 15;
guide_base = 7;
guide_wall = 2;
guide_side = 50;

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

module guide_sketch() {
  square(size=[guide_wall, guide_height], center=false);
  square(size=[guide_base, guide_wall], center=false);
}

module guide_corner() {
  rotate_extrude(angle=120)
    intersection() {
      translate([side / 2 + guide_wall, 0])
        mirror(v=[1, 0, 0])
          guide_sketch();

      translate(v=[0, -100])
        square(size=200, center=false);
    }
}

module guide_rail() {
  translate([guide_wall + side / 2, TINY, 0])
    mirror([1, 0, 0])
      rotate([90, 0, 0])
        linear_extrude(guide_side + 2 * TINY)
          guide_sketch();
}

module guide_third() {
  translate([guide_side / 2 / sqrt(3), guide_side / 2, 0]) {
    guide_corner();
    guide_rail();
  }
}

module guide() {
  for (i = [0:2]) {
    rotate([0, 0, i * 120])
      guide_third();
  }
}

guide();
