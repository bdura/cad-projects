use <resources/camlock.scad>
use <Round-Anything/polyround.scad>

dims = camlock_dims();

cam_ir = dims[0];
cam_or = dims[1];

inner_diameter = 21.78;
outer_diameter = 25.56;
length = 22.78;
top_radius = 1;

teeth_width = 2.92;
teeth_depth = 1.20;
teeth_period = 4.82;
teeth_bias = 3.68;
teeth_chord = 21.70;

teeth_angle = 2 * asin(teeth_chord / 2 / outer_diameter);

// n_teeth = ceil((length - teeth_bias) / teeth_period);
n_teeth = 3;

cone_height = 30;
angle = 60;

chamfer = 1;

TINY = 0.001;
TOLERANCE = 0.1;

$fn = 200;

module tooth() {
    radii_points = [
        [outer_diameter / 2 - TINY, 0, 0],
        [outer_diameter / 2 + teeth_depth, teeth_width / 4, 1],
        [outer_diameter / 2 + teeth_depth, 3 * teeth_width / 4, 1],
        [outer_diameter / 2 - TINY, teeth_width, 0],
    ];

    rotate_extrude(angle = teeth_angle)
    polygon(polyRound(radii_points), 10);
}

module teeth() {
            for (j = [0:n_teeth - 1]) {
                translate(v = [0, 0, length - teeth_width - teeth_bias - j * teeth_period]) 
                tooth();
            }
}

module male() {
    radii_points = [
        [inner_diameter / 2, 0, 0],
        [outer_diameter / 2, 0, 0],
        [outer_diameter / 2, length, top_radius],
        [inner_diameter / 2, length, top_radius],
    ];

    union() {
        rotate_extrude() 
            polygon(polyRound(radii_points), 10);

        for (i = [0, 1]) {
            rotate(a = [0, 0, i * 180]) 
            teeth();
        }
    }
}

module cone() {
    wall = 2;

    inner = inner_diameter / 2;
    outer = outer_diameter / 2 + teeth_width + wall;
    mid = outer_diameter / 2;

    delta = cam_ir - inner + wall;

    height = delta / cos(angle);

    polygon(polyRound([
        [cam_ir, 0,  0 ],
        [cam_or, 0,  0 ],
        [cam_or, 1,  0 ],
        [outer, cone_height,  0 ],
        [outer, cone_height + length - chamfer, 0 ],
        [outer - chamfer, cone_height + length, 0 ],
        [mid + TOLERANCE, cone_height + length, 0 ],
        [mid + TOLERANCE + chamfer, cone_height + length, 0 ],
        [mid + TOLERANCE, cone_height + length - chamfer, 0 ],
        [mid + TOLERANCE, cone_height - TOLERANCE, top_radius ],
        [inner, cone_height,  0 ],
    ], 10));
}

module connector() {
  difference() {
    rotate_extrude()
    cone();

    for(i=[0:1]) {
    rotate([0, 0, i * 180])
    union(){
    hull()
    union() {
      translate([0, 0, cone_height + length])
      mirror([0, 0, 1])
      teeth();

      translate([0, 0, cone_height + length * 2])
      mirror([0, 0, 1])
      teeth();
    }
    
    rotate([0, 0, teeth_angle - TINY])
    translate([0, 0, cone_height + length])
    mirror([0, 0, 1])
    teeth();

    }

    }
  }

}


connector();
camlock();
