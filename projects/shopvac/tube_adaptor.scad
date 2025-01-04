use <resources/camlock.scad>
use <Round-Anything/polyround.scad>

$fn = 200;

dims = camlock_dims();

cam_ir = dims[0];
cam_or = dims[1];

tube_diameter = 40;
wall = 3;
chamfer = 1;

angle_min = 30;
angle_max = 40;

height = 30;

module adaptor(fn = 10) {
    r = tube_diameter / 2;

    delta_r = (r < cam_ir) ? r - wall - cam_ir : r + wall - cam_or;
    h = abs(delta_r) / tan(angle_max);
    h2 = abs(delta_r) / tan(angle_min);

    radiipoints = [
        [cam_ir, 0, 0],
        [cam_or, 0, 0],
        // [r + wall, h2, 200],
        [r + wall, h + height - chamfer, 0],
        [r + wall - chamfer, h + height, 0],
        [r + chamfer, h + height, 0],
        [r, h + height - chamfer, 0],
        [r, h, 0],
        [r - wall, h, 0],
    ];

    points = polyRound(radiipoints = radiipoints, fn=fn);

    polygon(points = points);
}

rotate_extrude()
adaptor();
camlock();
