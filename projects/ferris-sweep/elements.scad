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
