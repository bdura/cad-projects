include <../../lib/constants.scad>
include <../../lib/primitives.scad>

use <Round-Anything/polyround.scad>

$fn = 360;

tube_ir = 10.4 / 2;
tube_or = 16 / 2;

wall = 1;

tube_insert = 20;
exhaust_insert = 10;
ring_height = 5;

exhaust_width = 50;
clearance = 20;

curvature = tube_or + 5;

mixer_height = 20;

box_ledge_width = 17;
box_ledge_depth = 30;

box_ledge_notch_height = 18;
box_ledge_notch_depth = 3;

module contact_sketch()
{
    ir = tube_ir - wall;
    or = tube_ir;

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

module mixer(insert = tube_insert, height = mixer_height, width = 0.5, step = 2, empty_height = 0)
{
    ir = tube_ir - wall;
    or = tube_ir;

    rotate_extrude() polygon([
        [ tube_or - wall, 0 ],
        [ tube_or, 0 ],
        [ tube_or, height ],
        [ or, height ],
        [ or, height + insert ],
        [ ir, height + insert ],
        [ ir, height - wall ],
        [ tube_or - wall, height - 2 * wall ],
    ]);

    empty_height = max(3 * wall, empty_height);

    linear_extrude(height - empty_height) mixer_mesh(width, step);
}

module stopper(with_square = true)
{
    ir = tube_ir - wall;
    or = tube_ir;

    translate([ 0, 0, -(exhaust_insert + wall) ])

        union()
    {
        rotate_extrude() polygon([
            [ or, 0 ],
            [ or, exhaust_insert ],
            [ ir, exhaust_insert ],
            [ tube_ir, exhaust_insert + wall + TINY ],
            [ tube_or, exhaust_insert + wall + TINY ],
            [ tube_or, 0 ],
        ]);

        if (with_square)
        {
            translate([ tube_or, 0, 0 ]) linear_extrude(exhaust_insert + wall) square_tube_sketch(tube_ir);
        }
    }
}

module square_tube_sketch(ir = tube_ir - wall)
{
    or = tube_or;

    translate([ -or, 0 ]) difference()
    {
        union()
        {
            translate([ 0, -or ]) square([ or, 2 * or ]);
            circle(r = or);
        }

        circle(r = ir);
    }
}

module ledge()
{
    rotate([ 0, 90, 0 ]) translate([ -TINY, 0, 0 ]) linear_extrude(box_ledge_width + 2 * TINY) square_tube_sketch();
    ledge_leg();

    translate([ box_ledge_width, 0, 0 ]) mirror([ 1, 0, 0 ]) ledge_leg();

    translate([ -TINY, -tube_or, -box_ledge_notch_height ])
        cube([ box_ledge_notch_depth + TINY, 2 * tube_or, box_ledge_notch_height + TINY ]);
}

module ledge_leg()
{
    depth = box_ledge_depth - (exhaust_insert + wall);
    rotate([ -90, 0, 0 ]) rotate_extrude(angle = 90) square_tube_sketch();
    translate([ 0, 0, -depth ]) linear_extrude(depth + TINY) square_tube_sketch();

    translate([ -tube_or, 0, -depth ]) stopper();
}

rotate_extrude() contact_sketch();

// mixer(insert = exhaust_insert, height = 15, width = 0.5, step = 3, empty_height = 5);

// ledge();
