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

      // part of side brace notch
      cube([side_brace_x_pos*2+sheet_thickness,side_brace_horizontal_height*2-sheet_thickness*2,sheet_thickness + 1],center=true);

      for(side=[left,right]) {
        // side brace notch
        translate([side_brace_x_pos*side,0,0])
          cube([sheet_thickness,side_brace_horizontal_height*2,sheet_thickness + 1],center=true);

        // top brace notch
        translate([z_motor_x_pos*side,main_plate_height,0]) {
          cube([motor_shoulder_diam+sheet_thickness*2,sheet_thickness*2,sheet_thickness+1],center=true);

          translate([0,-sheet_thickness/2,0]) bc_screw_nut_hole();
        }
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
      box_side([side_brace_vertical_depth, side_brace_vertical_height, sheet_thickness],[0,0,0,1]);
    }

    translate([0,bottom+side_brace_horizontal_height/2,0])
      box_side([side_brace_total_depth,side_brace_horizontal_height],[0,1,2,1]);
  }

  module holes() {
    // motor mount notch
    translate([-z_motor_y_pos-sheet_thickness/2,bottom+side_brace_horizontal_height,0])
      cube([z_motor_mount_depth+sheet_thickness,sheet_thickness*2,sheet_thickness+1],center=true);

    // top brace notch
    translate([-side_brace_total_depth/2+side_brace_vertical_depth-sheet_thickness*2.5,side_brace_total_height/2,0]) {
      cube([sheet_thickness*5+0.05,sheet_thickness*2,sheet_thickness+1],center=true);

      translate([0,-sheet_thickness/2,0]) bc_screw_nut_hole();
    }
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

  color("violet") difference() {
    body();
    holes();
  }
}

module bottom_plate() {
  module body() {
    box_side([bottom_plate_width,bottom_plate_depth],[1,1,1,1]);
  }

  module holes() {
    material_width_remain = motor_side;
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

module z_motor_mount() {
  module body() {
    box_side([z_motor_mount_width,z_motor_mount_depth],[1,2,0,2]);
  }

  module holes() {
    hole(motor_shoulder_diam,sheet_thickness+1,16);

    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0])
          hole(3,sheet_thickness+1,10);
      }
    }

    translate([z_smooth_threaded_spacing,0,0])
      hole(rod_diam,sheet_thickness+1,16);
  }

  color("purple") difference() {
    body();
    holes();
  }
}

module z_motor_brace() {
  module body() {
    box_side([z_motor_brace_depth,z_motor_brace_height],[1,1,0,0]);
  }

  module holes() {
    diagonal = sqrt(pow(z_motor_brace_depth,2) + pow(z_motor_brace_height,2));
    offset = z_motor_brace_depth/2+sheet_thickness/2;
    translate([offset,-offset,0]) rotate([0,0,45])
      cube([diagonal,diagonal,sheet_thickness+1],center=true);
  }

  color("orange") difference() {
    body();
    holes();
  }
}

module z_rod_top_brace() {
  module body() {
    hull() {
      rotate([0,0,22.5])
        hole(rod_diam*4,sheet_thickness,16);

      translate([0,z_motor_mount_depth/2+sheet_thickness/2,0]) {
        translate([-z_smooth_threaded_spacing-z_motor_mount_width/2-sheet_thickness/2,sheet_thickness*2,0])
          cube([sheet_thickness*3,sheet_thickness*7,sheet_thickness],center=true);

        translate([0,sheet_thickness,0])
          cube([rod_diam*4,sheet_thickness,sheet_thickness],center=true);
      }
    }
  }

  module holes() {
    // rod hole
    hole(rod_diam,sheet_thickness+1,16);

    total_width = z_motor_mount_width + sheet_thickness*4;
    slot_width = (total_width - motor_shoulder_diam - sheet_thickness*2)/2;
    translate([-z_smooth_threaded_spacing,0,0]) {
      translate([0,z_motor_mount_depth/2+sheet_thickness/2,0]) {
        // main plate screw hole
        hole(3,sheet_thickness+1,10);

        // main plate slots
        for(side=[left,right]) {
          translate([(total_width/2-slot_width/2)*side,0,0])
            cube([slot_width,sheet_thickness,sheet_thickness+0.05],center=true);
        }
      }

      rotate([0,0,22.5]) hole(rod_diam*2,sheet_thickness+1,16);
      translate([-rod_diam*2,0,0]) cube([rod_diam*4,rod_diam*2,sheet_thickness+1],center=true);
      translate([0,-rod_diam*2,0]) cube([rod_diam*2,rod_diam*4,sheet_thickness+1],center=true);
    }

    // side brace screw hole
    translate([-z_smooth_threaded_spacing-z_motor_mount_width/2-sheet_thickness/2,z_motor_mount_depth/2+sheet_thickness*3.5,0])
      hole(3,sheet_thickness+1,10);
  }

  difference() {
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
    screw_clearance_scale = 2;
    screw_clearance_x_pos = build_x/2-screw_clearance*screw_clearance_scale/2;
    for(x=[screw_clearance_x_pos*left,0,screw_clearance_x_pos*right]) {
      translate([x,front_face_height/2,0]) {
        scale([screw_clearance_scale,1,1]) {
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

module y_motor_mount() {
  module body() {
    box_side([motor_side,motor_side],[0,1,1,0]);
  }

  module holes() {
    hole(motor_shoulder_diam,sheet_thickness+1,16);

    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0])
          hole(3,sheet_thickness+1,10);
      }
    }
  }

  color("purple") difference() {
    body();
    holes();
  }
}

module assembly() {
  translate([0,main_plate_y_pos,main_plate_z_pos]) rotate([90,0,0])
    main_plate();

  translate([front_face_x_pos,front_face_y_pos,front_face_z_pos]) rotate([90,0,0])
    front_face();
  translate([rear_face_x_pos,rear_face_y_pos,rear_face_z_pos]) rotate([90,0,0])
    rear_face();

  translate([y_motor_x_pos,y_motor_y_pos,y_motor_z_pos]) {
    % rotate([0,90,0]) motor();
    //translate([sheet_thickness/2,0,0]) rotate([0,90,0]) rotate([0,0,180])
    translate([sheet_thickness/2,0,0]) rotate([0,90,0]) rotate([0,0,90])
      y_motor_mount();
  }

  translate([y_carriage_x_pos,y_carriage_y_pos+(build_y/2*0),y_carriage_z_pos]) y_carriage();

  translate([bottom_plate_x_pos,bottom_plate_y_pos,bottom_plate_z_pos]) bottom_plate();

  translate([psu_x_pos,psu_y_pos,psu_z_pos]) {
    % cube([psu_height,psu_width,psu_length],center=true);
  }

  for(side=[left,right]) {
    translate([z_motor_x_pos*side,z_motor_y_pos,z_motor_z_pos]) {
      % motor();

      translate([0,0,sheet_thickness/2+0.05]) mirror([1-side,0,0])
        z_motor_mount();
    }

    translate([z_motor_brace_x_pos*side,z_motor_brace_y_pos,z_motor_brace_z_pos]) mirror([1-side,0,0]) rotate([0,90,0])
      z_motor_brace();

    translate([side_brace_x_pos*side,side_brace_y_pos,side_brace_z_pos]) rotate([0,0,-90]) rotate([90,0,0])
      side_brace();

    color("orange") translate([z_rod_top_brace_x_pos*side,z_rod_top_brace_y_pos,z_rod_top_brace_z_pos+0.05]) mirror([1-side,0,0])
      z_rod_top_brace();

    // y rods
    translate([y_rod_spacing/2*side,0,-rod_diam/2]) rotate([90,0,0]) {
      color("grey", 0.5)
        cylinder(r=rod_diam/2,h=side_brace_total_depth + sheet_thickness*2 + 0.05,center=true);
    }

    // z rods
    translate([z_smooth_rod_x_pos*side,z_smooth_rod_y_pos,z_smooth_rod_z_pos]) {
      color("grey", 0.5)
        cylinder(r=rod_diam/2,h=z_smooth_rod_len,center=true);
    }
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
