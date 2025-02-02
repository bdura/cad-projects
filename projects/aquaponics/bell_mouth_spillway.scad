include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/bottlecaps.scad>
use <Round-Anything/polyround.scad>

include <../../lib/primitives.scad>
include <../../lib/constants.scad>

$fn = 360;

// Wall size
wall = 1;

// Envelope
envelope_top_radius = 50;
envelope_bottom_radius = 10;
envelope_height = 90;

// Crest
crest_height = 15;

// Outlet
outlet_diameter = 15;

fs = 0.5;

function sinh(x) = (exp(x) - exp(-x)) / 2;

function dist(a, b) = len(a)==2?
sqrt(                 // two dimensions
    (a[0]-b[0])^2
    +(a[1]-b[1])^2
    ):
sqrt(                 // three dimensions
    (a[0]-b[0])^2
    +(a[1]-b[1])^2
    +(a[2]-b[2])^2
    );

// length of curve
  function length(pts) = [
    // three control points
    if (len(pts) == 3)
        0.43 * dist(pts[0], pts[1])
      + 0.53 * dist(pts[0], pts[2])
      + 0.43 * dist(pts[1], pts[2])
    // four control points
    else if (len(pts) == 4)
        0.35 * dist(pts[0], pts[1])
      + 0.40 * dist(pts[0], pts[2])
      + 0.23 * dist(pts[0], pts[3])
      - 0.09 * dist(pts[1], pts[2])
      + 0.40 * dist(pts[1], pts[2])
    // five control points
    else if (len(pts) == 5)
        0.32 * dist(pts[0], pts[1])
      + 0.35 * dist(pts[0], pts[2])
      + 0.23 * dist(pts[0], pts[3])
      + 0.10 * dist(pts[0], pts[4])
      - 0.13 * dist(pts[1], pts[2])
      + 0.20 * dist(pts[1], pts[3])
      + 0.23 * dist(pts[1], pts[4])
      - 0.13 * dist(pts[2], pts[3])
      + 0.35 * dist(pts[2], pts[4])
      + 0.32 * dist(pts[3], pts[4])
    else
        echo("Wrong number of points")]
  [0];       // makes list into number
// calculate singular points
function b_pts(pts, fn, idx) =
  // has pts more than two points?
  len(pts) > 2 ?
  // it calls itself in smaller portions
    b_pts([for(i=[0:len(pts)-2])
        pts[i]], fn, idx) * fn*idx
      + b_pts([for(i=[1:len(pts)-1])
        pts[i]], fn, idx) * (1-fn*idx)
  // at two points we do the familiar
  // 'p1 · [0...1] + p2 · [1...0]'
    : pts[0] * fn*idx
      + pts[1] * (1-fn*idx);

function b_curv(pts, n) =
// determine fn
  let (fn=
  // is n given? if so fn = n
  n ? n :
  // if no n is given,
  // are there two controlpoints?
  len(pts) == 2 ?
  // if yes: fn = 2
  2 :
  // and if no, calculate:
  length(pts)/fs)
  // now knowing fn,
  // call b_pts() and concatenate points
    [for (i= [0:fn])
      concat(b_pts(pts, 1/(fn-1), i))];

module envelope_sketch() {
  h = envelope_height;
  tr = envelope_top_radius;
  br = envelope_bottom_radius;

  points1 = b_curv([
    [br, 0],
    [br, h + wall],
    [tr, h + wall],
  ]);
  points2 = b_curv([
    [tr + wall, h],
    [br + wall, h],
    [br + wall, 0],
  ]);

  points = concat(
    points2,
    [
      [tr + wall, h + crest_height],
      [tr, h + crest_height],
    ],
    points1,
  );

//  points = polyRound(
//     radiipoints = [
//         [-h, br, 0],
//         [0, br, 100],
//         [0, tr, 0],
//         [-wall, tr, 0],
//         [0, br + wall, 100],
//         [-h, br + wall, 0],
//     ],
//     fn=$fn
// );

  polygon(points);
}

module envelope() {
  difference() {
    rotate_extrude()
      envelope_sketch();

    h = envelope_height + crest_height;
    w = 2 * (envelope_top_radius + wall);

    translate([0, w / 2, h / 2 - 2 * TINY])
      cube([2 * w, w, 2 * h], center = true);
  }
}

module main() {
  envelope();
}

module other_sketch() {
  points = [
    for (t = [0:envelope_top_radius * 2]) [t / 2, sinh(t / 2 / envelope_top_radius * 5)]
  ];

  polygon(points);
}

other_sketch();
