use <../resources/camlock.scad>
use <Round-Anything/polyround.scad>

$fn = 200;

TINY = 0.01;
TOL = 0.2;

dims = camlock_dims();

cam_ir = dims[0];
cam_or = dims[1];

MAX_X = 250;
MAX_Y = 210;
MAX_Z = 220;

MAX_H = min(MAX_X, MAX_Y);

// Walls
wall = 3;
screw_support_thickness = 3;

// Glass
glass_width = 4;
top_glass_support = 8;

// Junction
junction_width = 10;
junction_thickness = 3;

// Inner diameters
bottom_diameter = 40;
top_diameter = MAX_H - 2 * (wall + junction_width) - 4;

// Base
base_diameter = 120;
base_thickness_max = 12;
base_thickness_min = 4;

// Heights
h1 = MAX_Z - 5;
h2 = 80;

// Attachments
nut_d = 6 + TOL;
nut_h = 2.5;
bolt_d = 3 + TOL;
bolt_head_d = 4.9 + TOL;

n_junction_screws = 8;
junction_theta_offset = 360 / 8 / 2;
n_base_screws = 8;

// Inserts
insert_d = 4;
insert_min_wall = 1.6;
insert_h = 5.7;
insert_min_depth = 7;
n_inserts = 10;

// Inlet
intake_protrusion = 30;

// Tank
tank_protrusion = 40;
tank_thickness = 7;
tank_inner_chamfer = 3;
tank_outer_chamfer = 2;

assert((top_diameter + 2 * (wall + junction_width)) < MAX_H);

module main_sketch(fn = 10)
{

    br = bottom_diameter / 2;
    tr = top_diameter / 2;

    jb = junction_width;
    jw = junction_thickness;
    // jw = wall / 2;

    base_r = base_diameter / 2;
    base_ti = base_thickness_max;
    base_to = base_thickness_min;

    slope = (tr - br) / h1;

    // Junction offset, to avoid overhangs
    jo = 10;

    // Glass support
    gs = top_glass_support;

    points = polyRound(radiipoints =
                           [
                               [ br, 0, 0 ],
                               [ tr, h1, 100 ],
                               [ tr, h1 + h2 - 2 * gs / 3 - wall - glass_width, 10 ],
                               [ tr - gs, h1 + h2 - wall - glass_width, 0 ],
                               [ tr - gs, h1 + h2 - glass_width, 0 ],
                               [ tr, h1 + h2 - glass_width, 0 ],
                               [ tr, h1 + h2, 0 ],
                               [ tr + wall, h1 + h2, 0 ],
                               [ tr + wall, h1 + jw, 10 ],
                               [ tr + wall + jb, h1 + jw, 0 ],
                               [ tr + wall + jb, h1 - jw, 0 ],
                               [ tr + wall - slope * (jw + jo), h1 - jw - jo, 10 ],
                               [ br + wall + slope * base_ti, base_ti, 10 ],
                               [ base_r, base_to, 0 ],
                               [ base_r, 0, 0 ],
                               [ br + wall, 0, 0 ],
                           ],
                       fn = fn);

    // rotate_extrude()
    polygon(points = points);
}

module insert()
{
    cylinder(h = insert_h, r = insert_d / 2);
}

module screw(h_nut, h_bolt, h_middle, rotated = false)
{

    rotate([ rotated ? 180 : 0, 0, 0 ]) translate(v = [ 0, 0, rotated ? h_middle : 0 ])
    {
        cylinder(h = h_bolt, r = bolt_head_d / 2);

        translate(v = [ 0, 0, -h_middle - TINY ]) cylinder(h = h_middle + 2 * TINY, r = bolt_d / 2);

        translate(v = [ 0, 0, -h_nut - h_middle ]) cylinder(h = h_nut, r = nut_d / 2, $fn = 6);
    }
}

module main(fn = 10, with_screws = false)
{
    difference()
    {
        rotate_extrude() main_sketch(fn = fn);

        if (with_screws)
        {

            // for (i = [1:n_inserts]) {
            //     rotate(a = [0, 0, i * 360 / n_inserts])
            //     translate(v = [top_diameter / 2 - top_glass_support / 2, 0, h1 + h2 - glass_width - insert_h + TINY])
            //     insert();
            // }

            for (i = [1:n_junction_screws])
            {
                rotate(a = [ 0, 0, i * 360 / n_junction_screws + junction_theta_offset ])
                    translate(v = [ top_diameter / 2 - top_glass_support / 2, 0, h1 + h2 ])
                        screw(h_bolt = 10, h_nut = 10, h_middle = glass_width + wall);
            }

            for (i = [1:n_junction_screws])
            {
                rotate(a = [ 0, 0, i * 360 / n_junction_screws + junction_theta_offset ])
                    translate(v = [ top_diameter / 2 + wall + junction_width / 2, 0, h1 + junction_thickness ])
                        screw(h_bolt = 10, h_nut = 10, h_middle = junction_thickness * 2);
            }

            for (i = [1:n_base_screws])
            {
                rotate(a = [ 0, 0, i * 360 / n_junction_screws ])
                    translate(v = [ base_diameter / 2 - 10, 0, base_thickness_min ])
                        screw(h_bolt = 10, h_nut = 10, h_middle = 10);
            }
        }
    }
}

module top_cylinder(inner = false)
{
    tr = top_diameter / 2;
    r = inner ? tr : tr + wall;
    if (!inner)
    {
        r = r + wall;
    }
    linear_extrude(height = h2) circle(r = r);
}

module intake_tube()
{
    tr = top_diameter / 2;
    translate(v = [ 0, tr - cam_ir, h2 / 2 ]) rotate(a = [ 0, 90, 0 ]) cylinder(h = tr, r = cam_ir);
}

module intake_adaptor()
{
    tr = top_diameter / 2;

    difference()
    {
        translate(v = [ 0, tr - cam_ir, h2 / 2 ]) rotate(a = [ 0, 90, 0 ]) difference()
        {
            cylinder(h = tr, r1 = cam_ir + wall, r2 = cam_or);

            translate(v = [ 0, 0, -TINY ]) cylinder(h = tr + 2 * TINY, r = cam_ir);

            translate(v = [ 0, 0, tr - intake_protrusion ]) cylinder(h = intake_protrusion + TINY, r = cam_ir + wall);
        }

        top_cylinder(true);
    }
}

module intake()
{
    tr = top_diameter / 2;

    intake_adaptor();
}

module cam_adaptor()
{
    tr = top_diameter / 2;
    h = intake_protrusion - TOL;

    difference()
    {
        translate(v = [ tr, tr - cam_ir, h2 / 2 ]) rotate(a = [ 0, -90, 0 ]) union()
        {
            camlock();

            difference()
            {
                cylinder(h = h, r = cam_ir + wall - TOL);

                translate(v = [ 0, 0, -TINY ]) cylinder(h = h + 2 * TINY, r = cam_ir - TOL);
            }
        }

        top_cylinder();
    }
}

module outlet_skirt_sketch()
{
    h = 5;

    width = 10;

    outlet_depth = 50;

    polygon(points = [
        [ cam_ir, 0 ],
        [ cam_ir, h ],
        [ cam_or, h ],
        [ cam_or + width, wall ],
        [ cam_or + width, 0 ],
        [ cam_ir + wall, 0 ],
        [ cam_ir + wall, -outlet_depth ],
        [ cam_ir, -outlet_depth ],
    ]);
}

module outlet_skirt()
{
    rotate_extrude() outlet_skirt_sketch();
}

module outlet()
{

    translate(v = [ 0, 0, h1 + h2 ])
    {
        translate(v = [ 0, 0, 5 - TINY ]) mirror(v = [ 0, 0, 1 ]) camlock();

        outlet_skirt();
    }
}

module top_part(fn = 10)
{

    difference()
    {
        main(fn, true);

        translate(v = [ 0, 0, -TINY ]) linear_extrude(height = h1 + TINY) square(size = MAX_H, center = true);

        translate(v = [ 0, 0, h1 ]) intake_tube();
    }

    translate(v = [ 0, 0, h1 ])
    {
        intake_adaptor();
    }
}

module bottom_part(fn = 10)
{
    difference()
    {
        main(fn, true);

        translate(v = [ 0, 0, h1 ]) linear_extrude(height = h1 + TINY) square(size = MAX_H, center = true);
    }
}

module top_walls()
{
    linear_extrude(height = h2) difference()
    {
        circle(r = top_diameter / 2 + wall);
        circle(r = top_diameter / 2);
    }
}

module cyclone()
{
    outlet();

    difference()
    {
        main(fn = 20, with_screws = true);
        translate(v = [ 0, 0, h1 ]) intake_tube();
    }

    translate(v = [ 0, 0, h1 ])
    {
        intake_adaptor();
        translate(v = [ 0.5, 0, 0 ]) color(c = "red") cam_adaptor();
    }

    intersection()
    {
        cylinder(h = 50, r = 27);

        translate(v = [ -35, -70, 90 ]) rotate(a = [ 0, 90, 0 ]) difference()
        {
            union()
            {
                top_walls();
                intake_adaptor();
            }
            intake_tube();
        }
    }
}

top_part(30);

module dust_tank_outlet_sketch()
{
    tt = tank_thickness;
    tp = tank_protrusion;
    ic = tank_inner_chamfer;
    oc = tank_outer_chamfer;
    r = base_diameter / 2;

    polygon(points = [[cam_ir, 0], [cam_ir, tp], [cam_ir + wall, tp], [cam_ir + wall, tt + ic],
                      [cam_ir + wall + ic, tt], [r - oc, tt], [r, tt - oc], [r, 0]]);
}

module dust_tank_outlet()
{
    difference()
    {
        rotate_extrude() dust_tank_outlet_sketch();

        for (i = [1:n_base_screws])
        {
            rotate(a = [ 0, 0, i * 360 / n_junction_screws ])
                translate(v = [ base_diameter / 2 - 10, 0, base_thickness_min ])
                    screw(h_bolt = 10, h_nut = 10, h_middle = 10, rotated = true);
        }
    }
}

// dust_tank_outlet();
