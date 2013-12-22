include <config.scad>;
include <positions.scad>;
use <boxcutter.scad>;
use <util.scad>;

//% translate([0,0,build_z/2+z_overhead+0.05]) cube([build_x,build_y,build_z],center=true);

translate([0,200,build_z/2+z_overhead]) {
  //% cube([605,6,450],center=true);
}

// main plate
// side braces
// bottom
// front
// rear
// top rear brace
// z smooth rod brace
// z motor mount
// y motor mount?
// y idler?

module main_plate() {
  module body() {
    cube([main_plate_width,main_plate_height,sheet_thickness],center=true);
  }

  module holes() {
    translate([0,-main_plate_height/2,0]) {
      cube([build_x_with_overhead,(main_plate_height-x_carriage_height)*2,sheet_thickness + 1],center=true);

      cube([side_brace_x_pos*2+sheet_thickness,side_brace_horizontal_height*2-sheet_thickness*2,sheet_thickness + 1],center=true);

      for(side=[left,right]) {
        translate([side_brace_x_pos*side,0,0])
          cube([sheet_thickness,side_brace_horizontal_height*2,sheet_thickness + 1],center=true);
      }
    }
  }

  color("lightblue") difference() {
    body();
    holes();
  }
}

module side_brace() {
  bottom = -side_brace_total_height/2;

  module body() {
    translate([-side_brace_total_depth/2+side_brace_vertical_depth/2,side_brace_horizontal_height/2,0]) {
      box_side([side_brace_vertical_depth, side_brace_total_height-side_brace_horizontal_height, sheet_thickness],[0,0,0,1]);
    }

    translate([0,bottom+side_brace_horizontal_height/2,0])
      box_side([side_brace_total_depth,side_brace_horizontal_height],[0,1,2,1]);
  }

  module holes() {
    translate([-z_motor_y_pos-sheet_thickness/2,bottom+side_brace_horizontal_height-sheet_thickness/2,0])
      cube([motor_side+sheet_thickness+0.05,sheet_thickness+0.05,sheet_thickness+1],center=true);
  }

  color("red") difference() {
    body();
    holes();
  }
}

module y_carriage() {
  module body() {
    cube([build_x,build_y,sheet_thickness],center=true);
  }

  module holes() {
    bearing_width_at_depth = bearing_diam * .6; // TODO: calculate this better using a chord
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([y_rod_spacing/2*side,y_carriage_bearing_spacing_y/2*end,0]) {
          cube([bearing_width_at_depth,bearing_len,sheet_thickness+1],center=true);

          for(zip_tie_side=[left,right]) {
            translate([(bearing_width_at_depth/2+3+zip_tie_width/2)*zip_tie_side,0,0])
              cube([zip_tie_thickness,zip_tie_width,sheet_thickness+1],center=true);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module bottom_plate() {
  module body() {
    box_side([bottom_plate_width,bottom_plate_depth],[1,1,1,1]);
  }

  module holes() {
    material_width_remain = 55;
    hole_radius = 10;

    hull() {
      for(side=[left,right]) {
        for(end=[front,rear]) {
          translate([(bottom_plate_width/2-material_width_remain-hole_radius)*side,(bottom_plate_depth/2-material_width_remain-hole_radius)*end,0])
            hole(hole_radius,sheet_thickness+1,16);
        }
      }
    }
  }

  color("lightblue") difference() {
    body();
    holes();
  }
}

module z_motor_plate() {
  module body() {
    box_side([motor_side,motor_side],[1,2,0,2]);
  }

  module holes() {
    cylinder(r=23/2,h=sheet_thickness+1,center=true);

    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0])
          hole(3,sheet_thickness+1,16);
      }
    }

    translate([z_smooth_threaded_spacing,0,0])
      hole(8,sheet_thickness+1,64);
  }

  color("orange") difference() {
    body();
    holes();
  }
}

module front_and_rear_face() {
  module body() {
    box_side([front_face_width,front_face_height],[0,2,2,2]);
  }

  module holes() {
    for(side=[left,right]) {
      translate([y_rod_spacing/2*side,front_face_height/2,0]) {
        cube([rod_diam,rod_diam,sheet_thickness+1],center=true);
        translate([0,-rod_diam/2,0])
          hole(rod_diam,sheet_thickness+1,32);
      }
    }

    screw_clearance = 10;
    screw_clearance_x_pos = build_x/2-screw_clearance;
    for(x=[screw_clearance_x_pos*left,0,screw_clearance_x_pos*right]) {
      translate([x,front_face_height/2,0]) {
        scale([2,1,1]) {
          cube([screw_clearance,screw_clearance,sheet_thickness+1],center=true);
          translate([0,-screw_clearance/2,0]) rotate([0,0,18])
            hole(screw_clearance,sheet_thickness+1,10);
        }
      }
    }
  }

  color("green") difference() {
    body();
    holes();
  }
}

module front_face() {
  module body() {
    front_and_rear_face();
  }

  module holes() {
  }

  color("green") difference() {
    body();
    holes();
  }
}

module rear_face() {
  module body() {
    front_and_rear_face();
  }

  module holes() {
  }

  color("green") difference() {
    body();
    holes();
  }
}

module assembly() {
  translate([0,main_plate_y_pos,main_plate_z_pos]) rotate([90,0,0])
    main_plate();

  for(side=[left,right]) {
    translate([z_motor_x_pos*side,z_motor_y_pos,z_motor_z_pos]) {
      % motor();

      translate([0,0,sheet_thickness/2+0.05]) mirror([1-side,0,0])
        z_motor_plate();
    }

    translate([side_brace_x_pos*side,side_brace_y_pos,side_brace_z_pos]) rotate([0,0,-90]) rotate([90,0,0])
      side_brace();
  }

  translate([front_face_x_pos,front_face_y_pos,front_face_z_pos]) rotate([90,0,0]) front_face();
  translate([rear_face_x_pos,rear_face_y_pos,rear_face_z_pos]) rotate([90,0,0]) rear_face();

  //translate([-sheet_thickness*1.5,(build_y_with_overhead/2-motor_side/2)*front,bottom_plate_z_pos+sheet_thickness/2+motor_side/2]) {
  translate([y_motor_x_pos,y_motor_y_pos,y_motor_z_pos]) {
    % rotate([0,90,0]) motor();
  }

  translate([y_carriage_x_pos,y_carriage_y_pos+(build_y/2*0),y_carriage_z_pos]) y_carriage();

  translate([bottom_plate_x_pos,bottom_plate_y_pos,bottom_plate_z_pos]) bottom_plate();

  translate([psu_x_pos,psu_y_pos,psu_z_pos]) {
    % cube([psu_height,psu_width,psu_length],center=true);
  }
}

assembly();

module motor() {
  difference() {
    translate([0,0,-motor_side/2]) cube([motor_side,motor_side,motor_side],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0]) cylinder(r=motor_screw_diam/2,h=100,center=true);
      }
    }
  }

  translate([0,0,motor_shaft_len/2]) cylinder(r=motor_shaft_diam/2,h=motor_shaft_len,center=true);
}

module nema14() {
  difference() {
    translate([0,0,-nema14_side/2]) cube([nema14_side,nema14_side,nema14_side],center=true);
    for(end=[left,right]) {
      for(side=[front,rear]) {
        translate([nema14_hole_spacing/2*side,nema14_hole_spacing/2*end,0]) cylinder(r=nema14_screw_diam/2,h=100,center=true);
      }
    }
  }

  translate([0,0,nema14_shaft_len/2]) cylinder(r=nema14_shaft_diam/2,h=nema14_shaft_len,center=true);
}

module motor_with_pulley() {
  motor();
  pulley_z_above_motor_base = xy_pulley_above_motor_plate+pulley_height/2;
  translate([0,0,pulley_z_above_motor_base])
    cylinder(r=pulley_diam/2,h=pulley_height,center=true);
}

module bearing_zip_tie() {
  rotate([90,0,0])
    rotate_extrude()
      translate([bearing_diam/2+3,0,0])
        square([zip_tie_thickness,zip_tie_width],center=true);
}

module bearing() {
  rotate([90,0,0]) rotate([0,0,22.5])
    cylinder(r=da8*bearing_diam,h=bearing_len,center=true,$fn=8);
}

module bearing_cavity() {
  rotate([90,0,0])
    difference() {
      // main body
      cylinder(r=bearing_diam/2+0.05,h=bearing_len+0.05,center=true);

      // grooves
      for(side=[left,right]) {
        translate([0,0,bearing_groove_spacing/2*side])
          rotate_extrude()
            //translate([bearing_diam/2,0,0]) rotate([0,0])
            //  square([bearing_groove_depth*2,bearing_groove_width],center=true);
            translate([bearing_diam/2,0,0]) /* resize([1,1]) */ rotate([0,0,45])
              square([bearing_groove_width,bearing_groove_width],center=true);
      }
    }
}

module bearing_with_zip_tie() {
  bearing_cavity();
  bearing_zip_tie();
}

module idler_bearing() {
  difference() {
    cylinder(r=belt_bearing_diam/2+belt_bearing_groove_depth,h=belt_bearing_thickness,center=true,$fn=12);
    rotate([0,0,22.5])
      cylinder(r=belt_bearing_inner/2,h=belt_bearing_thickness+1,center=true,$fn=8);
  }
}

module heatbed() {
  difference() {
    cube([heatbed_width,heatbed_depth,heatbed_thickness],center=true);
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([heatbed_hole_spacing_x/2*side,heatbed_hole_spacing_y/2*end,0])
          cylinder(r=heatbed_hole_diam/2,h=heatbed_thickness+1,center=true);
      }
    }
  }
}

module endstop() {
  cube([endstop_len,endstop_width,endstop_height],center=true);

  translate([0,0,endstop_height/2+.5]) rotate([0,5,0])
    cube([endstop_len-4,endstop_width-1,.5],center=true);
}
