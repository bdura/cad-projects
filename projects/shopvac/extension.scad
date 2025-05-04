use <Round-Anything/polyround.scad>
use <resources/camlock.scad>

$fn = 200;

camlock();

mirror(v = [ 0, 0, 1 ]) camlock();
