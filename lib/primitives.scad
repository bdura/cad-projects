/**
Create a 2D ring.
*/
module ring(inner, outer) {
    assert(0 < inner);
    assert(inner < outer);

    difference() {
        circle(outer);
        circle(inner);
    }
}

module arc_primitive(r, theta) {
    assert(0 < theta);
    assert(theta < 45);

    d = r / cos(theta);

    x = d * cos(theta);
    y = d * sin(theta);

    intersection() {
        circle(r = r);
        polygon(points = [
            [0, 0],
            [d, 0],
            [x, y],
        ]);
    }
}

/**
Create a pie slice.
*/
module arc(r, theta) {
    assert(0 < theta);
    assert(theta < 360);
    
    n = floor(theta / 30);
    remainder = theta % 30;

    union() {
        if (remainder > 0) {
            arc_primitive(r, remainder);
        }
        
        if (n > 0) {
            for (k = [0:n - 1]) {
                rotate(a = [0, 0, remainder + 30 * k])
                    arc_primitive(r, 30);
                
                if ((k > 0 || remainder > 0) && k < n - 1) {
                    rotate(a = [0, 0, remainder + 30 * k - 1])
                        arc_primitive(r, 2);
                }
            }
        }


    }
}

module arc_ring(inner, outer, theta) {
  intersection() {
    ring(inner = inner, outer = outer);
    arc(r = outer, theta = theta); 
  };
}
