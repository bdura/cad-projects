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

exhaust_width = 50;
clearance = 20;

curvature = tube_or + 5;

mixer_height = 20;

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

module back_plate()
{
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
}

curvature_clearance = curvature - tube_or;

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

module outlet()
{
    back_plate();
    exhaust_height = curvature + exhaust_insert + wall;

    translate([ clearance - curvature_clearance, 0, exhaust_insert + wall ]) bend();

    translate([ -TINY, 0, exhaust_height ]) rotate([ 0, 90, 0 ])
        linear_extrude(clearance - curvature_clearance + 2 * TINY) ring(tube_ir, tube_or);
    rotate([ 90, 0, 0 ]) translate([ 0, 0, -wall ]) linear_extrude(2 * wall) support();
}

module mixer_mesh(width, step)
{
    n = ceil(tube_or * 2 / step);
    total_width = step * n;

    intersection()
    {
        for (theta = [0:1])
        {
            rotate(90 * theta) translate([ -total_width / 2 - width / 2, -tube_or ]) for (i = [0:n])
            {
                translate([ i * (step), 0 ]) square([ width, tube_or * 2 ]);
            }
        }

        circle(r = tube_or);
    }
}

module mixer()
{
    ir = tube_ir - wall;
    or = tube_ir + TOLERANCE;

    rotate_extrude() polygon([
        [ tube_or - wall, 0 ],
        [ tube_or, 0 ],
        [ tube_or, mixer_height ],
        [ or, mixer_height ],
        [ or, mixer_height + tube_insert ],
        [ ir, mixer_height + tube_insert ],
        [ ir, mixer_height - wall ],
        [ tube_or - wall, mixer_height - 2 * wall ],
    ]);

    linear_extrude(mixer_height - 3 * wall) mixer_mesh(0.5, 2);
}

mixer();
