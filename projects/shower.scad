include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

top_diameter = 22.8;
bottom_diameter = 20.4;
height = 31.0;

angle = 5;

cantilever_length = 15;

dovetail_ratio = 0.5;
dovetail_depth = 5;
dovetail_base_width = 12;
dovetail_height = 22;

support_side = 100;
support_chamfer = 2;

grip_height = 1;
grip_period = 3;

flexible_diameter = 16;

wall = 4;

module holder_sketch() {
  r = bottom_diameter / 2;
  cut = flexible_diameter;

  difference() {
    ring(inner=r, outer=r + wall);

    translate(v=[r, 0.0])
      square(size=cut, center=true);
  }
}

module sketch() {
  width = bottom_diameter + 2.0 * wall;
  depth = top_diameter / 2.0 + wall;

  offset(1)
    offset(-2)
      offset(1)
        union() {
          difference() {
            translate(v=[-depth / 2.0, 0.0])
              square(size=[depth, width], center=true);

            circle(r=bottom_diameter / 2.0);
          }

          holder_sketch();
        }

  translate([-cantilever_length / 2.0 - top_diameter / 2.0, 0.0])
    square([cantilever_length, width], center=true);
}

module dovetail(tol = 0.0) {
  r = dovetail_ratio;
  w = dovetail_base_width / 2.0 + tol;
  h = dovetail_height;
  d = dovetail_depth + tol;

  polygon(
    points=[
      [-TINY, -w],
      [d, -w - d * r],
      [d, +w + d * r],
      [-TINY, w],
    ]
  );
}

module holder() {
  slope = top_diameter / bottom_diameter;

  difference() {
    translate([0.0, 0.0, height / cos(angle)])
      rotate([0.0, angle, 0.0])
        translate([top_diameter / 2.0 + cantilever_length, 0.0, -height])
          linear_extrude(height=height, scale=slope)
            sketch();

    translate([-100, 0.0, 0.0])
      cube(size=200, center=true);

    translate([0.0, 0.0, -2])
      linear_extrude(dovetail_height + 2)
        dovetail(tol=TOLERANCE);
  }
}

module support_plate() {
  side = support_side;
  chamfer = support_chamfer;

  linear_extrude(wall)
    square(size=side, center=true);

  translate([0.0, 0.0, wall - TINY])
    linear_extrude(chamfer + TINY, scale=(side - chamfer) / side)
      square(size=side, center=true);
}

module grip_sketch() {
  s = grip_height + TINY;
  w = s / sqrt(2) + TINY;

  polygon(
    [
      [-w, 0.0],
      [0.0, s],
      [w, 0.0],
    ]
  );
}

module grip_pattern(radius) {
  rotate_extrude()
    translate([radius, 0])
      grip_sketch();
}

module grip() {
  n = ceil(support_side * sqrt(2) / grip_period) + 1;

  for (i = [0:n]) {
    echo(i);
    grip_pattern(i * grip_period);
  }
}

module support() {
  difference() {
    support_plate();
    grip();
  }

  translate([dovetail_height / 2.0, 0, wall + support_chamfer - TINY])
    rotate([0, -90, 0])
      linear_extrude(dovetail_height)
        dovetail(tol=0.0);
}

support();
#color("blue")
  translate([dovetail_height / 2.0, 0, wall + support_chamfer - TINY])
    rotate([0, -90, 0])
      holder();
