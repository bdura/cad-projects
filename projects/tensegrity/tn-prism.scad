include <../../lib/primitives.scad>
include <../../lib/constants.scad>

$fn = 180;

beam_length = 150;
beam_side = 5;

beam_count = 3;

radius = 50;
circle_girth = 0.3;

assert(radius < beam_length / 2 / sin(180 / beam_count));

function chord_length() = 2 * radius * sin(180 / beam_count);
function height() = sqrt(beam_length ^ 2 - chord_length() ^ 2);

module latent_circle() {
  rotate_extrude()
    translate([radius, 0])
      circle(r=circle_girth);
}

module segment() {
  translate([radius, 0])
    rotate([0, 0, 180 / beam_count])
      translate([0, chord_length() / 2])
        rotate([90, 0, 0]) {
          cylinder(h=chord_length(), r=circle_girth, center=true);
          for (i = [-1:2:1])
            translate([0, 0, i * chord_length() / 2])
              sphere(r=circle_girth);
        }
}

module latent_triangle() {
  for (i = [0:beam_count - 1])
    rotate([0, 0, i * 360 / beam_count])
      segment();
}

module beam() {
  translate([radius, 0, 0])
    rotate([0, 0, 360 / 2 / beam_count])
      rotate([-asin(chord_length() / beam_length), 0, 0])
        linear_extrude(beam_length)
          square(size=5, center=true);
}

module pod() {
  for (i = [0:1])
    translate([0, 0, i * height()]) {
      //latent_circle();
      latent_triangle();
    }

  for (i = [0:beam_count - 1])
    rotate([0, 0, i * 360 / beam_count]) {
      beam();

      translate([radius, 0, 0])
        cylinder(h=height(), r=circle_girth, center=false);
    }
}

pod_count = 7;
outer_radius = 200;

for (i = [0:pod_count])
  rotate([0, -i * 180 / pod_count])
    translate([outer_radius, 0, -height() / 2])
      rotate([0, 0, i * 180])
        pod();
