inner_width = 11;
width = 18;
inner_length = 10;
height = 14.3;

TINY = 0.01;

module chain_link() {
  translate([-100, -100, 0])
  import(file = "./chain-link-30.stl");
}


module open_chain_link(top = true) {
  z = top ? 2 * height / 3 : 0;
  difference() {
    chain_link();

    translate([-inner_length / 2, - inner_width / 2 + TINY / 2, - TINY + z])
    cube([inner_length, inner_width - TINY, height / 2 + TINY]);
  }
}


translate([0, - width / 2, 0])
open_chain_link(true);

translate([0, width / 2, height])
rotate([180, 0, 0])
open_chain_link(false);
