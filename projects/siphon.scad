include <BOSL2/std.scad>
include <BOSL2/threading.scad>

include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

cap_diameter = 77.8;
cap_width = 3;
cap_height = 12;
cap_pitch = 3.9;
thread_depth = 2;

main_tube_width = 6;
main_tube_height = 50;

inner_ring_radius = 16.5;
inner_ring_width = 3;
inner_ring_chamfer = 1.5;
inner_ring_height = 20;

ring_support_width = 3;
n_ring_supports = 3;

n_feet = 8;
feet_height = 8;

untrigger_tube_inner_radius = 2;
untrigger_tube_outer_radius = 3.1;
untrigger_wall = 2;
untrigger_guide_height = 45;
untrigger_guide_chamfer = 1.5;

untrigger_outer_cavity_radius = 4;

untrigger_width = 20;
untrigger_height = 40;

// Computed
main_tube_radius = cap_diameter / 2 - main_tube_width;
ledge_width = cap_width + main_tube_width;

module cap() {
  inner = cap_diameter / 2 + thread_depth;
  outer = inner + cap_width;

  translate([0, 0, thread_depth]) {
    linear_extrude(height=cap_height)
      ring(inner, outer);

    translate([0, 0, cap_height - thread_depth])
      linear_extrude(thread_depth)
        difference() {
          circle(outer);
          square(2 * (inner - thread_depth + TOLERANCE), center=true);
        }
    ;
  }

  linear_extrude(thread_depth + TINY)
    ring(inner=inner - 7, outer=outer);
}

module ledge() {
  rotate_extrude()
    translate(v=[main_tube_radius, 0])
      polygon(
        points=[
          [0, 0],
          [ledge_width, ledge_width],
          [ledge_width, ledge_width + TINY],
          [0, ledge_width + TINY],
        ]
      );
}

module tube() {
  linear_extrude(height=main_tube_height)
    ring(
      inner=main_tube_radius,
      outer=main_tube_radius + main_tube_width
    );
}

module feet() {
  theta = 360 / n_feet / 2;

  for (k = [0:n_feet - 1]) {
    rotate([0, 0, k * theta * 2 - theta / 2])
      linear_extrude(height=feet_height + TINY)
        arc_ring(inner=main_tube_radius, outer=main_tube_radius + main_tube_width, theta=theta);
  }
}

module inner_ring() {
  rotate_extrude()
    translate(v=[inner_ring_radius, 0])
      polygon(
        points=[
          [inner_ring_width, 0],
          [inner_ring_width, inner_ring_height],
          [inner_ring_chamfer, inner_ring_height],
          [0, inner_ring_height - inner_ring_chamfer],
          [0, inner_ring_chamfer],
          [inner_ring_chamfer, 0],
        ]
      );
}

module ring_support_2d() {
  difference() {
    offset(1) offset(-2) offset(1) {
          circle(r=inner_ring_radius + inner_ring_width);
          ring(inner=main_tube_radius, outer=main_tube_radius + main_tube_width);

          support_length = main_tube_radius + main_tube_width / 2 - inner_ring_radius;

          for (k = [0:n_ring_supports - 1]) {
            rotate(a=[0, 0, 360 / n_ring_supports * k])
              translate(v=[inner_ring_radius + inner_ring_chamfer, -ring_support_width / 2])
                square(size=[support_length, ring_support_width]);
          }
        }

    circle(r=inner_ring_radius + inner_ring_chamfer);
  }
}

module ring_support() {
  linear_extrude(height=inner_ring_height)
    ring_support_2d();
}

module siphon() {
  translate(v=[0, 0, main_tube_height + feet_height - ledge_width + TINY])
    ledge();

  translate(v=[0, 0, main_tube_height + feet_height])
    cap();

  translate(v=[0, 0, main_tube_height + feet_height - inner_ring_height])
    inner_ring();

  rotate(a=[0, 0, 180 / n_feet])
    translate(v=[0, 0, main_tube_height + feet_height - inner_ring_height])
      ring_support();

  translate(v=[0, 0, feet_height])
    tube();

  feet();
}

module untrigger_tube() {
  inner = untrigger_tube_inner_radius;
  outer = untrigger_tube_outer_radius;

  guide_height = untrigger_guide_height;

  wall = untrigger_wall;

  gallery_height = feet_height - wall * 2;

  chamfer = untrigger_guide_chamfer;

  assert(gallery_height > 3);

  rotate_extrude()
    polygon(
      points=[
        [0, wall],
        [inner, wall],
        [inner, feet_height],
        [outer, feet_height],
        [outer, feet_height + guide_height],
        [outer + chamfer, feet_height + guide_height + chamfer],
        [outer + chamfer, feet_height + guide_height + chamfer + TINY],
        [0, feet_height + guide_height + chamfer + TINY],
      ]
    );
}

module untrigger_inner_2d() {
  theta = 180 / n_feet;

  hull() {
    rotate([0, 0, -theta / 2])
      arc_ring(inner=main_tube_radius - untrigger_wall, outer=main_tube_radius, theta=theta);

    translate([main_tube_radius - untrigger_wall - untrigger_tube_outer_radius, 0, 0])
      circle(r=untrigger_tube_outer_radius + untrigger_wall);
  }
}

module untrigger_inner() {
  width = 2 * (untrigger_tube_outer_radius + untrigger_wall);

  theta = 180 / n_feet;

  difference() {
    linear_extrude(height=feet_height + untrigger_guide_height + untrigger_guide_chamfer)
      untrigger_inner_2d();

    translate(v=[main_tube_radius - (untrigger_tube_outer_radius + untrigger_wall), 0, 0])
      untrigger_tube();
  }
}

module untrigger_middle_single_chamfer() {
  chamfer = 0.6;

  rotate([-180 / n_feet / 2, 90, 0])
    linear_extrude(main_tube_radius + main_tube_width + TINY)
      polygon(
        [
          [-TINY, TINY],
          [-TINY, -chamfer - TINY],
          [chamfer + TINY, TINY],
        ]
      );
}

module untrigger_middle_chamfer() {
  translate([0, 0, feet_height]) {
    untrigger_middle_single_chamfer();

    mirror([0, 1, 0])
      untrigger_middle_single_chamfer();
  }
}

module untrigger_middle() {
  theta = 180 / n_feet;

  inner = main_tube_radius - TINY;
  outer = main_tube_radius + main_tube_width + TINY;

  rotate([0, 0, -theta / 2])
    difference() {
      linear_extrude(height=feet_height)
        intersection() {
          ring(inner=inner, outer=outer);
          arc(r=outer, theta=theta);
        }
      ;

      rotate([0, 0, theta / 2])
        untrigger_middle_chamfer();
    }
}

module arc_ring(inner, outer, theta) {
  intersection() {
    ring(inner=inner, outer=outer);
    arc(r=outer, theta=theta);
  }
}

module untrigger_cavity_2d() {
  inner = main_tube_radius + main_tube_width;
  outer = inner + untrigger_wall;

  translate([outer + untrigger_outer_cavity_radius, 0, 0])
    circle(r=untrigger_outer_cavity_radius);
}

module untrigger_outer_2d() {
  theta = 180 / n_feet;

  inner = main_tube_radius + main_tube_width;
  outer = inner + untrigger_wall;

  difference() {
    hull() {
      rotate([0, 0, -theta / 2])
        arc_ring(inner=inner, outer=outer, theta=theta);

      translate([outer + untrigger_outer_cavity_radius, 0, 0])
        circle(r=untrigger_outer_cavity_radius + untrigger_wall);
    }

    rotate([0, 0, -theta / 2])
      arc_ring(inner=TINY, outer=inner, theta=theta);
  }
}

module untrigger_outer() {
  theta = 180 / n_feet;

  inner = main_tube_radius + main_tube_width;
  outer = inner + untrigger_width;

  difference() {

    linear_extrude(height=untrigger_height)
      untrigger_outer_2d();

    translate([0, 0, untrigger_wall])
      linear_extrude(height=untrigger_height)
        untrigger_cavity_2d();
  }
}

module untrigger_communication() {
  inner = untrigger_tube_inner_radius;
  outer = untrigger_tube_outer_radius;

  theta = 180 / n_feet;

  wall = untrigger_wall;

  gallery_height = feet_height - wall * 2;

  length = outer + wall + main_tube_width + wall;

  translate([0, 0, wall])
    linear_extrude(height=gallery_height)
      hull() {
        union() {
          translate([main_tube_radius - (untrigger_tube_outer_radius + untrigger_wall), 0])
            circle(r=inner);

          untrigger_cavity_2d();
        }
      }
  ;
}

module untrigger_outer_chamfer() {
  chamfer = 0.6;
  translate([0, 0, untrigger_height])
    rotate_extrude()
      translate([main_tube_radius + main_tube_width, 0])
        polygon(
          [
            [-TINY, TINY],
            [-TINY, -chamfer - TINY],
            [chamfer + TINY, TINY],
          ]
        );
}

module untrigger() {
  theta = 180 / n_feet / 2;
  width = untrigger_tube_outer_radius + untrigger_wall;

  difference() {
    union() {
      untrigger_inner();
      untrigger_middle();
      untrigger_outer();
    }

    untrigger_communication();

    untrigger_outer_chamfer();
  }
}

cap();

//rotate([0, 0, 180 * (1 + 1 / n_feet / 2)])
//color(c = "red")
//untrigger();
