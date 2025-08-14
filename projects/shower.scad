include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

top_diameter = 22.8;
bottom_diameter = 20.4;
height = 31.0;

cantilever = 10;

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
  depth = bottom_diameter / 2.0 + wall;

  difference() {
    translate(v=[-depth / 2.0, 0.0])
      square(size=[depth, width], center=true);

    circle(r=bottom_diameter / 2.0);
  }

  holder_sketch();
}

module holder() {
  scale = top_diameter / bottom_diameter;

  linear_extrude(height=height, scale=scale)
    offset(1)
      offset(-2)
        offset(1)
          sketch();
}

holder();
#sketch();
