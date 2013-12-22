
function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
}

module debug_axes() {
  color("red") {
    translate([50,0,0]) cube([100,.5,.5],center=true);
    translate([0,50,0]) cube([.5,100,.5],center=true);
    translate([0,0,50]) cube([.5,.5,100],center=true);
  }
}
