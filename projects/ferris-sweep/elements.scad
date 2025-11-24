OFFSET = [-108.5, -250];

module body(hand) {
  import(file=str("./resources/sweepv2-", hand, "-body.svg"), center=false);
}

module holes(hand) {
  import(file=str("./resources/sweepv2-", hand, "-perforations.svg"), center=false);
}

module trrs(hand) {
  import(file=str("./resources/sweepv2-", hand, "-trrs.svg"), center=false);
}

module magnets(hand) {
  import(file=str("./resources/sweepv2-", hand, "-magnets.svg"), center=false);
}

module bumps(hand) {
  import(file=str("./resources/sweepv2-", hand, "-bumps.svg"), center=false);
}
