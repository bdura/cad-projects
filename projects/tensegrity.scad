include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>

include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

side = 60;

beam_side = 5;
beam_length = 120;

hole_radius = 0.7;
hole_offset = 7;

base_guide_height = 15;
base_guide_width = 7;

side_guide_width = 20;

mid_guide_side = 40;
mid_guide_depth = 10;

stand_offset = 15;
stand_joint_width = 10;

holder_wall = 1;
holder_height = 5;

assert(holder_height < hole_offset);

wall = 2;

BIG = 200;

module hole() {
  for (i = [0:1])
    rotate([(-1 + 2 * i) * 45, 0, 0])
      cylinder(h=beam_side * sqrt(2) + 2 * TINY, r=hole_radius, center=true);
}

module slit() {
  translate([hole_offset / 2, 0, 0])
    cube(size=[hole_offset + TINY, hole_radius, beam_side + 2 * TINY], center=true);
}

module beam() {
  h = beam_length;
  d = hole_offset;

  difference() {
    rotate([0, 90, 0])
      translate(v=[0, 0, -h / 2])
        linear_extrude(h)
          square(size=beam_side, center=true);

    for (i = [0:1]) {
      mirror([i * 1, 0, 0]) {
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

module guide_sketch() {
  r = side * sqrt(3) / 3;

  offset(0.2)
    offset(-1.2)
      offset(1)
        union() {
          circle(5);

          translate([0, -wall / 2])
            square(size=[r - beam_side / 2, wall], center=false);

          translate([r - wall / 2 - beam_side / 2, 0])
            square(size=[wall, beam_side + 2 * wall], center=true);
        }

  translate([r - wall / 2, 0])
    difference() {
      square(size=[beam_side + wall, beam_side + 2 * wall], center=true);

      translate([wall, 0])
        square(size=[beam_side + wall, beam_side], center=true);
    }
}

module guide() {
  linear_extrude(10)
    difference() {
      for (i = [0:2]) {
        rotate(i * 120)
          guide_sketch();
      }

      circle(5 - wall);
    }
}

module holder_support() {
  dx = beam_side / sqrt(2);
  h = (beam_length - side) / 2;

  extrusion_height = dx + holder_wall * sqrt(2);

  rotate([90, 0, 0])
    translate([0, 0, -extrusion_height])
      linear_extrude(extrusion_height * 2)
        polygon(
          [
            [-dx, -TINY],
            [dx, -TINY],
            [dx, h],
            [0, h - dx],
            [-dx, h],
          ]
        );
}

module holder() {
  dy = (beam_side + 2 * holder_wall) * sqrt(2);

  linear_extrude(holder_wall)
    difference() {
      union() {
        square(size=[side, dy], center=true);
        for (i = [-1:2:1]) {
          translate([i * side / 2, 0])
            rotate([0, 0, 45])
              square(beam_side + 2 * holder_wall, center=true);
        }
      }
    }

  translate([0, 0, holder_wall])
    linear_extrude(holder_height + holder_wall + TINY) {
      for (i = [-1:2:1]) {
        translate([i * side / 2, 0])
          rotate([0, 0, 45])
            difference() {
              square(beam_side + 2 * holder_wall, center=true);
              square(beam_side + TOLERANCE, center=true);
            }
      }
    }

  translate([0, 0, holder_wall - TOLERANCE])
    holder_support();
}

module stand_sketch() {
  offset(-4)
    offset(8)
      offset(-4)
        union() {
          offset(stand_offset) {
            for (i = [-1:2:1]) {
              translate([i * (side + beam_side) / 2, 0])
                rotate([0, 0, 45])
                  square(beam_side, center=true);
            }
          }
          square([side, stand_joint_width], center=true);
        }
}

module stand() {
  linear_extrude(wall)
    stand_sketch();

  translate([0, 0, wall - TINY])
    linear_extrude(hole_offset + TINY - 1)
      union() {
        for (i = [-1:2:1]) {
          translate([i * (side + beam_side) / 2, 0])
            rotate([0, 0, 45])
              difference() {
                square(beam_side + 2 * wall, center=true);
                square(beam_side + TOLERANCE, center=true);
              }
        }
      }
}

module beam_pair() {
  for (i = [-1:2:1]) {
    translate([0, i * side / 2, 0])
      rotate([45, 0, 0])
        beam();
  }
}

module holder_pair() {
  for (i = [0:1])
    mirror([0, 0, i])
      translate([0, 0, -holder_wall - beam_length / 2])
        #holder();
}

module pair() {
  beam_pair();

  rotate([0, -90, 0])
    rotate([0, 0, 90])
      holder_pair();
}

module structure() {
  pair();

  rotate([90, 0, 90])
    pair();

  rotate([0, 90, 90])
    pair();
}

structure();
