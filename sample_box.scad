include <boxcutter.scad>;
include <config.scad>;
//include <positions.scad>;
use <util.scad>;

box_length = 150;
box_height = 55;
box_width  = 55;

hole_diam = 8;

sides=[16,32,64,128];

projection(cut=true) {
  translate([-box_length/2-sheet_thickness-1,0,0]) {
    difference() {
      box_side([box_length, box_height, sheet_thickness],[0,1,2,1]);

      for(i=[-2,-1,0,1,2]) {
        for(fn=[0:3]) {
          translate([(hole_diam*3)*i,box_height/2-hole_diam*1.25-(4+hole_diam)*fn,0]) {
            hole(hole_diam,sheet_thickness+1,sides[fn]);
          }
        }
      }
    }

    translate([0,box_height+sheet_thickness+1,0]) {
      rotate([0,0,0]) {
        box_side([box_length, box_width, sheet_thickness],[1,1,1,1]);
      }
    }
  }

  translate([box_width/2+sheet_thickness*2,0,0]) {
    box_side([box_width, box_height, sheet_thickness],[0,2,2,2]);
  }
}


