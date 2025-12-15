module part(hand, element) {
  translate([-108, -260])
    import(file=str("./resources/", hand, "/", element, ".svg"), center=false);
}

module body(hand) {
  part(hand=hand, element="body");
}

module perforations(hand) {
  part(hand=hand, element="perforations");
}

module cables(hand) {
  part(hand=hand, element="cables");
}

module tenting(hand) {
  part(hand=hand, element="tenting");
}

module bumps(hand) {
  part(hand=hand, element="bumps");
}

module magnets(hand) {
  part(hand=hand, element="magnets");
}

module special_perforations(hand) {
  part(hand=hand, element="special-perforations");
}

tenting_center = [
  ["left", [55.6, 18.94]],
  ["right", [-54.1, 18.94]],
];

quadrants = [
  ["east", [19.05, 0]],
  ["north", [0, 19.05]],
  ["west", [-19.05, 0]],
  ["south", [0, -19.05]],
];

function get_value(dict, key) = dict[search(key, dict)[0]][1];

module individual_tent(hand, quadrant) {
  center = get_value(tenting_center, hand);
  pos = get_value(quadrants, quadrant);
  translate([pos[0] + center[0], pos[1] + center[1]])
    children();
}
