mode = "additions";
new = ".artefacts/new.stl";
old = ".artefacts/old.stl";

module additions() {
  difference() {
    import(file = new);
    import(file = old);
  }
}

module deletions() {
  difference() {
    import(file = old);
    import(file = new);
  }
}

module common() {
  intersection() {
    import(file = old);
    import(file = new);
  }
}

if (mode == "additions") {
 color("green", alpha = 0.8)additions();
} else if (mode == "deletions") {
 color("red", alpha = 0.8)deletions();
} else if (mode == "common") {
 color("white", alpha = 0.9)common();
}
