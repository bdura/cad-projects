mode = "additions";

module main() {
  import(file = "main.stl");
}

module feat() {
  import(file = "feat.stl");
}

module additions() {
  difference() {
    feat();
    main();
  }
}

module deletions() {
  difference() {
    main();
    feat();
  }
}

module common() {
  intersection() {
    main();
    feat();
  }
}

if (mode == "additions") {
 color("green", alpha = 0.8)additions();
} else if (mode == "deletions") {
 color("red", alpha = 0.8)deletions();
} else if (mode == "common") {
 color("white", alpha = 0.9)common();
}
