use <Round-Anything/polyround.scad>

$fn = 200;

module handle(fn = 30) {
    points = polyRound(
        radiipoints = [
            [0,             21.3,       0],
            [22.5 / 2,      21.3,       0],
            [26.2 / 2,      29.8,       5],
            [20.3 / 2 - 1,  55.4,       50],
            [28.7 / 2,      95.9,       10],
            [32.7 / 2,      145.0,      0],
            // Added to include the rounding
            [32.7 / 2,      154.5,      300],
            [0,             154.5,      0],
        ],
        fn=fn
    );

    color(c = "maroon")
    rotate_extrude()
    translate(v = [0, -21.3, 0])
    polygon(points = points);
}

module basket_holder() {
    d_top = 60.4;
    d_bottom = 59.5;

    rb = d_bottom / 2;
    rt = d_top / 2;

    bw = 2;

    h = 33.7;
    filter_h = 34.4;

    color(c = "gray")
    rotate_extrude()
    polygon(points = [
        [rb, 0],
        [rt, h],
        [rt - bw, h],
        [rb - bw, 0],
    ]);
}

module basket(fn = 30) {

    d_top = 60.4;
    d_filter = 62.3;
    d_bottom = 55;

    h = 34.4 - 9.7;

    fw = 0.5;
    bw = 2;

    rt = d_top / 2;
    rf = d_filter / 2;
    rb = d_bottom / 2;

    ri = rf - bw - 2 * fw;

    points = polyRound(
        radiipoints = [
            [0, 0, 0],
            [rb, 0, 3],
            [ri + fw, h - fw, 0],
            [rf - fw, h - fw, 0],
            [rf - fw, h - bw, 0],
            [rf, h - bw, 0],
            [rf, h, 2],
            [ri, h, 2],
            [rb - fw, fw, 3],
            [0, fw, 0],
        ],
        fn=fn
    );

    // color(c = "black")
    rotate_extrude()
    polygon(points = points, convexity=10);
}

translate(v = [0, 0, 51 - 34.4]) {
    basket_holder();
    translate(v = [0, 0, 10.7])
    basket();
}

rotate(a = [90, 0, 0])
handle();
