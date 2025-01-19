module additions() {
  import(file = "additions.stl");
}

module deletions() {
  import(file = "deletions.stl");
}

module common() {
  import(file = "common.stl");
}

color("Lime", alpha = 0.6)additions();
color("red", alpha = 0.6)deletions();
color("white", alpha = 0.9)common();
