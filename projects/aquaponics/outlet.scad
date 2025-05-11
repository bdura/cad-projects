include <../../lib/constants.scad>
include <../../lib/primitives.scad>

use <Round-Anything/polyround.scad>

$fn = 360;

tube_ir = 10 / 2;
tube_or = 16 / 2;

wall = 2;

tube_insert = 20;
exhaust_insert = 10;
ring_height = 5;

curvature = tube_or + 5;

module contact_sketch()
{
    ir = tube_ir - wall;
    or = tube_ir - TOLERANCE;

    polygon([
        [ ir, 0 ],
        [ or, 0 ],
        [ or, exhaust_insert ],
        [ tube_or, exhaust_insert ],
        [ tube_or, exhaust_insert + ring_height ],
        [ or, exhaust_insert + ring_height ],
        [ or, exhaust_insert + ring_height + tube_insert ],
        [ ir, exhaust_insert + ring_height + tube_insert ],
    ]);
}

module bend()
{
    ir = tube_ir - wall;
    or = tube_ir - TOLERANCE;

    rotate([ 90, 0, 0 ]) rotate_extrude(90) translate([ curvature, 0 ]) ring(tube_ir, tube_or);
    translate([ curvature, 0, -exhaust_insert - wall ]) rotate_extrude() polygon([
        [ or, 0 ],
        [ or, exhaust_insert ],
        [ ir, exhaust_insert ],
        [ tube_ir, exhaust_insert + wall + TINY ],
        [ tube_or, exhaust_insert + wall + TINY ],
        [ tube_or, 0 ],
    ]);
}

// rotate_extrude() contact_sketch();

exhaust_width = 50;
exhaust_height = curvature + exhaust_insert + wall;

rotate([ 0, -90, 0 ]) difference()
{
    union()
    {

        translate([ exhaust_height, 0 ]) cylinder(h = wall, r = exhaust_width / 2);
        translate([ 0, -exhaust_width / 2 ]) cube([ exhaust_height, exhaust_width, wall ]);
    }

    translate([ exhaust_height, 0, -TINY ]) cylinder(h = wall + 2 * TINY, r = tube_ir);
}

curvature_clearance = curvature - tube_or;

clearance = 20;

translate([ clearance - curvature_clearance, 0, exhaust_insert + wall ]) bend();

translate([ -TINY, 0, exhaust_height ]) rotate([ 0, 90, 0 ]) linear_extrude(clearance - curvature_clearance + 2 * TINY)
    ring(tube_ir, tube_or);

module support()
{
    points = polyRound(
        [
            [ 0, 0, 0 ],
            [ clearance + wall, 0, 0 ],
            [ clearance + wall, exhaust_insert, 0 ],
            [ clearance + wall, exhaust_insert + curvature_clearance + wall, curvature / 2 ],
            [ clearance + wall - curvature_clearance, exhaust_insert + curvature_clearance + wall, 0 ],
            [ 0, exhaust_insert + curvature_clearance + wall, 0 ],
        ],
        fn = $fn);

    polygon(points);
}

rotate([ 90, 0, 0 ]) translate([ 0, 0, -wall ]) linear_extrude(2 * wall) support();
