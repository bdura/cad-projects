include <../lib/primitives.scad>
include <../lib/constants.scad>

$fn = 360;

cable_slit_width = 4;
cable_slit_length = 5.5;

thread_depth = 0.5;

// Height in the holder until the top thread
inner_free_height = 22;
inner_diameter = 16;

bottom_thread_diameter = 10;
bottom_thread_height = 8;

top_thread_diameter = 10.6;
top_thread_height = 7.8;

module section_sketch(r) {
  offset(0.5)
    offset(-0.5)
      difference() {
        circle(r=inner_diameter / 2);
        circle(r=r);

        translate([0, inner_diameter / 2])
          square(size=[cable_slit_width, inner_diameter + TINY], center=true);
      }
}

module bottom_thread() {
  section_sketch(r=bottom_thread_diameter / 2 - thread_depth);
}

module top_thread() {
  section_sketch(r=top_thread_diameter / 2 - thread_depth);
}

module middle_section() {
  section_sketch(r=cable_slit_length / 1.5);
}

module support() {
  bottom = bottom_thread_height;
  middle = inner_free_height - bottom;
  top = top_thread_height;

  linear_extrude(bottom)
    bottom_thread();

  translate([0, 0, bottom - TINY])
    linear_extrude(middle + TINY)
      middle_section();

  translate([0, 0, bottom + middle - TINY])
    linear_extrude(top + TINY)
      top_thread();
}

support();
