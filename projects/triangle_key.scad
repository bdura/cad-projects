// Model that creates a key compatible with French recyclable bin.

include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>

include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

// Wall size
wall = 2;

// Key shape
shape_side = 9;
shape_offset = 0.6;

shape_radius = shape_side / sqrt(3) + TOLERANCE;
shape_depth = 12;

// Handle
handle_thickness = 3;
handle_width = 30;
handle_height = 20;
handle_chamfer = 3;
handle_hole_radius = 3;
handle_hole_offset = 2;

// Attachement ratio
attachement_ratio = 0.75;

module inner_shape_sketch() {
  offset(shape_offset)
    circle(r=shape_radius, $fn=3);
}

module shape_sketch() {
  difference() {
    offset(wall)
      inner_shape_sketch();
    inner_shape_sketch();
  }
  ;
}

module shape(scale = 1) {
  linear_extrude(shape_depth, scale=scale)
    shape_sketch();
}

module attachement() {
  hull() {
    translate([0, 0, shape_depth + handle_height * attachement_ratio])
      cylinder(r=handle_thickness / 2 - TINY, h=TINY);

    translate([0, 0, shape_depth])
      linear_extrude(TINY)
        shape_sketch();
  }
}

module handle_sketch() {
  difference() {
    polygon(
      [
        [shape_radius, 0],
        [handle_width / 2, handle_width / 2 / 2],
        [handle_width / 2, handle_height - handle_chamfer],
        [handle_width / 2 - handle_chamfer, handle_height],
        [-(handle_width / 2 - handle_chamfer), handle_height],
        [-(handle_width / 2), handle_height - handle_chamfer],
        [-(handle_width / 2), handle_width / 2 / 2],
        [-shape_radius, 0],
      ]
    );

    r = handle_hole_radius;
    translate([handle_width / 2 - r - handle_hole_offset, handle_height - r - handle_hole_offset, 0])
      circle(r=r);
  }
}

module handle() {
  translate([0, handle_thickness / 2, shape_depth])
    rotate([90, 0, 0])
      linear_extrude(handle_thickness)
        handle_sketch();
}

module key() {
  translate([-1, 0, 0]) {
    shape();
    attachement();
  }
  handle();
}

key();
