use <./resources/models.scad>;

difference() {
  magnetic();

  #translate([60, -35, 3])
    cube(10);
}
