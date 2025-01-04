use <resources/camlock.scad>
use <Round-Anything/polyround.scad>

dims = camlock_dims();

cam_ir = dims[0];
cam_or = dims[1];

inner_diameter = 21.78;
outer_diameter = 25.56;
length = 22.78;

teeth_width = 2.92;
teeth_depth = 1.20;
teeth_period = 4.82;
teeth_bias = 3.68;
teeth_chord = 21.70;

teeth_angle = 2 * asin(teeth_chord / 2 / outer_diameter);

n_teeth = ceil((length - teeth_bias) / teeth_period);

angle = 60;

TINY = 0.001;
TOL = 0.1;

$fn = 200;

module tooth() {
    radii_points = [
        [outer_diameter - TINY, 0, 0],
        [outer_diameter + teeth_depth, teeth_width / 4, 1],
        [outer_diameter + teeth_depth, 3 * teeth_width / 4, 1],
        [outer_diameter - TINY, teeth_width, 0],
    ];

    rotate_extrude(angle = teeth_angle)
    polygon(polyRound(radii_points), 10);
}

module connector() {
    radii_points = [
        [inner_diameter, 0, 0],
        [outer_diameter, 0, 0],
        [outer_diameter, length, 1],
        [inner_diameter, length, 1],
    ];

    union() {
        rotate_extrude() 
            polygon(polyRound(radii_points), 10);

        for (i = [0, 1]) {
            rotate(a = [0, 0, i * 180]) 
            for (j = [0:n_teeth - 1]) {
                translate(v = [0, 0, length - teeth_width - teeth_bias - j * teeth_period]) 
                tooth();
            }
        }
    }
}

connector();

// module cone() {
//     ir = 6;
//     wall = 2;

//     or = ir + wall;

//     delta = cam_ir - ir;

//     height = delta / cos(angle);

//     polygon(polyRound([
//         [cam_ir, 0,  0 ],
//         [cam_or, 0,  0 ],
//         [cam_or, 1,  0 ],
//         [or, height,  4 ],
//         [or, height + 20,  0 ],
//         [ir, height + 20,  0 ],
//         [ir, height,  3 ],
//     ], 10));
// }

// rotate_extrude() 
// cone();

// camlock();
