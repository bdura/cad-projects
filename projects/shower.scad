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

module volume(bottom, top) {
  slope = top_diameter / bottom_diameter;

  width = (top_diameter + 2.0 * wall) * slope;
  depth = (top_diameter) * slope;

  h = height - bottom - top;

  translate(v=[-(depth - width) / 2.0, 0.0, h / 2.0 + bottom])
    cube(size=[width, width, h], center=true);
}

module clipped() {
  angle = atan2(top_diameter - bottom_diameter, height);

  bottom = (bottom_diameter / 2.0 + wall) * sin(angle);
  top = (bottom_diameter / 2.0 + wall) * sin(angle);

  translate(v=[0.0, 0.0, -bottom])
    intersection() {
      echo(bottom);
      volume(bottom=bottom, top=top);

      rotate(a=[0.0, angle, 0.0])
        holder();
    }
}

clipped();
