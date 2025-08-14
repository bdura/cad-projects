include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

top_diameter = 23.2;
bottom_diameter = 20.5;
height = 27.25;

flexible_diameter = 16;

wall = 4;

module cone() {
  scale = top_diameter / bottom_diameter;
  r = bottom_diameter / 2 + TOLERANCE;

  linear_extrude(height=height, scale=scale)
    ring(inner=r, outer=r + wall);
}

cone();
