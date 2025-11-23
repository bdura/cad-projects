include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>

include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

side = 50;

beam_side = 5;
beam_length = 120;

slit_width = 0.4;
slit_depth = 5;

base_guide_height = 15;
base_guide_width = 7;

side_guide_width = 20;

mid_guide_side = 40;
mid_guide_depth = 10;

wall = 2;

BIG = 200;

module hole() {
  w = 2 * slit_width;
  rotate([90, 0, 0])
    rotate([0, 0, 45])
      cube([w, w, beam_side + 2 * TINY], center=true);
}

module slit() {
  translate([slit_depth / 2, 0, 0])
    cube(size=[slit_depth + TINY, slit_width, beam_side + 2 * TINY], center=true);
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

module base_guide_sketch() {
  square(size=[wall, base_guide_height], center=false);
  square(size=[base_guide_width, wall], center=false);
}

module base_guide_corner() {
  rotate_extrude(angle=120)
    intersection() {
      translate([beam_side / 2 + wall, 0])
        mirror(v=[1, 0, 0])
          base_guide_sketch();

      translate(v=[0, -BIG / 2])
        square(size=BIG, center=false);
    }
}

module base_guide_rail() {
  translate([wall + beam_side / 2, TINY, 0])
    mirror([1, 0, 0])
      rotate([90, 0, 0])
        linear_extrude(side + 2 * TINY)
          base_guide_sketch();
}

module base_guide_third() {
  translate([side / 2 / sqrt(3), side / 2, 0]) {
    base_guide_corner();
    base_guide_rail();
  }
}

module base_guide() {
  for (i = [0:2]) {
    rotate([0, 0, i * 120])
      base_guide_third();
  }
}

module side_guide() {
  bs = beam_side;
  s = (side - bs) / 2;

  rotate([90, 0, 0])
    linear_extrude(side_guide_width) {
      for (i = [0:1]) {
        mirror([i, 0])
          polygon(
            [
              [-TINY, 0],
              [s, 0],
              [s, bs],
              [s + bs, bs],
              [s + bs, 0],
              [s + bs + wall, 0],
              [s + bs + wall, bs + wall],
              [s - wall, bs + wall],
              [s - wall, wall],
              [-TINY, wall],
            ]
          );
      }
    }
}

module mid_guide_triangle() {
  s = mid_guide_side;
  h = s * sqrt(3) / 2;

  translate([0, -h / 3])
    polygon(
      [
        [-s / 2, 0],
        [s / 2, 0],
        [0, s * sqrt(3) / 2],
      ]
    );
}

module mid_guide_notch() {
  w = beam_side * sqrt(2);

  union() {
    rotate([0, 0, 45])
      square(size=beam_side, center=true);

    translate([-w / 2, 0])
      square([w, BIG]);
  }
}

module mid_guide() {

  s = mid_guide_side;
  width = beam_side * sqrt(2) * 0.9;
  h = s * sqrt(3) / 2;

  linear_extrude(wall)
    offset(0.4)
      offset(-2.4)
        offset(2)
          difference() {
            mid_guide_triangle();

            for (i = [0:2]) {
              rotate([0, 0, i * 120])
                translate([0, 2 * h / 3 - mid_guide_depth])
                  mid_guide_notch();
            }
          }
}

mid_guide();
