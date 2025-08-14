include <BOSL2/std.scad>
include <BOSL2/threading.scad>

include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;
TOLERANCE = 0.1;
inner_diameter = 4;
wall = 3;
height = 3;

r = inner_diameter / 2;

linear_extrude(height=height)
  ring(inner=r + TOLERANCE, outer=r + wall);
