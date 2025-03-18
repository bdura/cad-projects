include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>
use <Round-Anything/polyround.scad>

include <../../lib/primitives.scad>
include <../../lib/constants.scad>

$fn = 360;

wall = 3;

outlet_diameter = 20;
cage_diameter = 90;
cage_height = 50;

module main_sketch() {
  outlet_ir = outlet_diameter / 2;
  outlet_or = outlet_ir + wall;

  cage_ir = cage_diameter / 2;

  y_offset = 20;

  rotate([0, 0, -90])
  arc_ring(outlet_ir, outlet_or, 90);

  translate([outlet_ir, -TINY, 0])
  square([wall, y_offset + 2 *TINY]);

  r = 50;

  translate([r + outlet_or, y_offset])
  mirror([-1, 0])
  arc_ring(r, r + 3, 70);

  translate([cage_ir - wall / 2, y_offset + r * sin(70), 0])
  square([wall, cage_height]);
}

rotate_extrude(180)
main_sketch();


translate([0, -TINY, 0])
rotate([90, 0, 0])
linear_extrude(7 + TINY)
union() {
  mirror([-1, 0, 0])
  main_sketch();

  main_sketch();
}
