use <resources/camlock.scad>
use <Round-Anything/polyround.scad>

$fn = 200;

camlock();

mirror(v = [0, 0, 1])
camlock();
