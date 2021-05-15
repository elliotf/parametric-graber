include <boxcutter.scad>;
include <config.scad>;
include <positions.scad>;
use <util.scad>;

// build volume for debugging
//% translate([0,y_carriage_y_pos,build_z/2+heatbed_z_pos+heatbed_thickness/2+0.05]) cube([build_x,build_y,build_z],center=true);

module main_plate() {
  module body() {
    translate([0,-sheet_thickness,0])
      square([main_plate_width,main_plate_height+sheet_thickness*2],center=true);
  }

  module holes() {
    rounded_diam = 32;

    translate([0,-main_plate_height/2,0]) {
      // main build area void
      hull() {
        square([build_x_with_overhead,sheet_thickness],center=true);

        for(side=[left,right]) {
          translate([(build_x_with_overhead/2-rounded_diam/2)*side,build_z_with_overhead+side_brace_horizontal_height-rounded_diam/3,0]) rotate([0,0,22.5])
            accurate_circle(rounded_diam,16);
        }
      }

      // part of side brace notch
      square([side_brace_x_pos*2+sheet_thickness,side_brace_horizontal_height*2-sheet_thickness*2],center=true);

      for(side=[left,right]) {
        // side brace notch
        translate([side_brace_x_pos*side,0,0])
          square([sheet_thickness,side_brace_horizontal_height*2],center=true);

        // top brace notch
        translate([z_motor_x_pos*side,main_plate_height,0]) {
          square([motor_shoulder_diam+sheet_thickness*2,sheet_thickness*2],center=true);

          translate([0,-sheet_thickness/2,0]) bc_screw_nut_hole();
        }

        // motor mount holes
        translate([0,side_brace_horizontal_height-sheet_thickness/2,0]) {
          translate([z_motor_x_pos*side,0,0])
            scale([1,1,1.1]) bc_tab_pair(1);

          // motor brace holes
          translate([z_motor_brace_x_pos*side,-sheet_thickness/2-z_motor_brace_height/2,0]) rotate([0,0,90])
            scale([1,1,1.1]) bc_tab_pair(1);
        }

        translate([(z_motor_x_pos+4)*side,0,0])
          hull() {
            for(side=[left,right]) {
              translate([4*side,0,0])
                  accurate_circle(8,8);
            }
          }
      }
    }

    side_indent_depth = sheet_thickness*2; //+(z_motor_mount_width/2-z_smooth_threaded_spacing)-bearing_diam/2;
    cutter_size = sqrt(pow(side_indent_depth*2,2)/2);

    translate([0,main_plate_height/2,0]) {
      for(side=[left,right]) {
        translate([side_brace_x_pos*side,-side_brace_vertical_height/2,0]) {
          rotate([0,0,90]) scale([1,1,1.1]) bc_position_along_line(side_brace_vertical_height-bc_tab_from_end_dist*2) bc_offset_tab_pair(1);
        }

        hull() {
          translate([main_plate_width/2*side,-side_indent_depth-sheet_thickness*1.5,0])
            rotate([0,0,45])
              square([cutter_size,cutter_size],center=true);

          translate([main_plate_width/2*side,-side_brace_vertical_height+side_indent_depth,0])
            rotate([0,0,45])
              square([cutter_size,cutter_size],center=true);
        }
      }
    }
  }

  difference() {
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

    filler_height = side_brace_vertical_height-top_rear_brace_height;
    translate([-side_brace_total_depth/2-sheet_thickness/2+0.05,0,0])
      square([sheet_thickness+0.05,filler_height],center=true);
  }

  top_brace_tab_area = side_brace_horizontal_height;
  module holes() {
    // make room for z motor mount tabs
    translate([-z_motor_mount_y_pos-sheet_thickness/2,bottom+side_brace_horizontal_height-motor_len/2-sheet_thickness/2+0.025,0])
      square([z_motor_mount_depth+sheet_thickness,sheet_thickness+motor_len],center=true);

    // top brace notch
    translate([-side_brace_total_depth/2+side_brace_vertical_depth-sheet_thickness*2.5,side_brace_total_height/2,0]) {
      square([sheet_thickness*5+0.05,sheet_thickness*2],center=true);

      translate([0,-sheet_thickness/2,0]) bc_screw_nut_hole();
    }

    // make room for top rear brace tabs
    to_remove = top_brace_tab_area;
    translate([-side_brace_total_depth/2+to_remove/2-0.05,side_brace_total_height/2-to_remove/2+0.05,0])
      square([side_brace_horizontal_height,side_brace_horizontal_height],center=true);

    module wire_hole() {
      hole_height = 8;
      hull() {
        for(side=[left,right]) {
          translate([hole_height/2*side,0,0]) rotate([0,0,22.5])
            accurate_circle(hole_height,8);
        }
      }
    }

    // wiring passthrough
    translate([-front_wire_passthrough_hole_y_pos,front_wire_passthrough_hole_z_pos,0]) {
      for(x=[-10,-50]) {
        translate([x,0,0]) {
          wire_hole();
        }
      }
    }

    // electronics mounting holes
    cabling_room = 10;
    translate([-side_brace_total_depth/2,-side_brace_total_height/2+side_brace_horizontal_height,0]) {
      translate([65,motor_len+5,0]) {
        translate([15,-15,0]) {
          rotate([0,0,90]) {
            translate([0,20,0]) arduino_mount_holes();
            color("magenta")
              translate([7,2,0])
                sanguinololu_holes();
          }
        }
      }

      translate([side_brace_vertical_depth,cabling_room,0]) {
        // arduino and sanguinololu vertical
        translate([5,-10,0]) {
          rotate([0,0,90]) {
            translate([0,20,0]) arduino_mount_holes();
            color("magenta")
              translate([7,2,0])
                sanguinololu_holes();
          }
        }

        translate([-6,0,0])
          rotate([0,0,90])
            rambo_holes();
      }
    }

    // psu mounting holes
    translate([-psu_y_pos,-side_brace_total_height/2+side_brace_horizontal_height+psu_length/2+20,0]) {
      for(x=[-1,1]) {
        for(y=[-1,1]) {
          hull() {
            for(addtl=[0,-5]) {
              translate([x*psu_hole_spacing_x/2+addtl,y*psu_hole_spacing_y/2,0]) rotate([0,0,22.5])
                accurate_circle(4,8);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }

  translate([-z_motor_mount_y_pos-sheet_thickness/2+sheet_thickness/2,bottom+side_brace_horizontal_height-motor_len/2-sheet_thickness,0])
    box_side([z_motor_mount_depth+sheet_thickness*2,motor_len,sheet_thickness],[1,0,0,0]);

  translate([-side_brace_total_depth/2+top_brace_tab_area/2,side_brace_total_height/2-top_brace_tab_area/2,0])
    box_side([top_brace_tab_area,top_brace_tab_area],[0,1,0,0]);
}

module psu_spacer() {
  module body() {
    rotate([0,0,22.5])
      accurate_circle(4+3*2,8);
  }

  module holes() {
    rotate([0,0,22.5])
      accurate_circle(4,8);
  }

  color("green")
    difference() {
      body();
      holes();
    }
}

module y_carriage() {
  module body() {
    square([y_carriage_width,y_carriage_depth],center=true);
  }

  module holes() {
    bearing_width_at_depth = bearing_diam * .6; // TODO: calculate this better using a chord
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([y_rod_spacing/2*side,y_carriage_bearing_spacing_y/2*end,0]) {
          square([bearing_width_at_depth,bearing_len],center=true);

          for(zip_tie_side=[left,right]) {
            translate([(bearing_width_at_depth/2+3+zip_tie_width/2)*zip_tie_side,0,0])
              square([zip_tie_thickness,zip_tie_width],center=true);
          }
        }

        // heatbed mounting holes
        translate([heatbed_hole_spacing_x/2*side,heatbed_hole_spacing_y/2*end,0]) rotate([0,0,22.5])
          accurate_circle(3,8);

        // trim corners
        translate([y_carriage_width/2*side,y_carriage_depth/2*end,0]) rotate([0,0,45])
          square([5,5],center=true);

        // FIXME: Does not allow non-square y carriage
        for(rota=[0,90]) {
          // y belt clamp
          translate([0,y_belt_clamp_hole_spacing/2*side,0]) accurate_circle(3,8);

          // zip tie holes along sides
          rotate([0,0,rota])
            for(y=[8,build_y/2-5])
              translate([(build_x/2+4)*side,y*end,0])
                square([zip_tie_thickness,zip_tie_width],center=true);
        }
      }

      // three-hole mounting holes
      translate([heatbed_hole_spacing_x/2*side,0,0]) rotate([0,0,22.5])
        accurate_circle(3,8);
      translate([0,heatbed_hole_spacing_y/2*side,0]) rotate([0,0,22.5])
        accurate_circle(3,8);
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
    hole_radius = 5;
    void_width = bottom_plate_width-motor_side*3-hole_radius;
    void_depth = bottom_plate_depth-motor_side*4-hole_radius;

    // main void
    hull() {
      for(side=[left,right]) {
        for(end=[front,rear]) {
          translate([(void_width/2-hole_radius)*side,(void_depth/2-hole_radius)*end,0]) rotate([0,0,22.5])
            accurate_circle(hole_radius*2,8);
        }
      }
    }

    // slots for y motor and y idler
    for(end=[front,rear]){
      for(side=[left,right]) {
        translate([(y_motor_x_pos+sheet_thickness/2)*side,(bottom_plate_depth/2-motor_side/2)*end,0]) rotate([0,0,90]) scale([1,1,1.1])
          bc_tab_pair(1);
      }
    }

    // holes for screw feet
    dist_from_edge = nema17_len*.9;
    for(end=[front,rear]) {
      for(side=[left,right]) {
        translate([(bottom_plate_width/2-dist_from_edge)*side,(bottom_plate_depth/2-dist_from_edge)*end,0])
          accurate_circle(8,8);
      }
    }

    // wire tie down holes
    for(side=[left,0,right]) {
      for(y=[10,50]) {
        translate([(void_width/2+zip_tie_thickness/2+5)*side,front_wire_passthrough_hole_y_pos+y,0])
          for(tie_hole=[-1,1])
            translate([0,4*tie_hole,0])
              square([zip_tie_width,zip_tie_thickness],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module z_motor_mount() {
  module body() {
    box_side([z_motor_mount_width,z_motor_mount_depth],[1,2,0,2]);
  }

  module holes() {
    translate([0,space_behind_z_motor/2*front,0]) {
      accurate_circle(motor_shoulder_diam,16);

      for(side=[left,right]) {
        for(end=[front,rear]) {
          translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0])
            accurate_circle(3,10);
        }
      }

      translate([z_smooth_threaded_spacing,0,0])
        accurate_circle(rod_diam,16);
    }
  }

  difference() {
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
      square([diagonal,diagonal],center=true);
  }

  difference() {
    body();
    holes();
  }
}

module z_rod_top_brace() {
  main_plate_y = z_motor_mount_depth/2+space_behind_z_motor/2+sheet_thickness/2;

  module body() {
    hull() {
      accurate_circle(sheet_thickness*5,12);

      translate([0,main_plate_y,0]) {
        translate([-z_smooth_threaded_spacing-z_motor_mount_width/2-sheet_thickness/2,sheet_thickness*2,0])
          square([sheet_thickness*3,sheet_thickness*7],center=true);

        translate([-z_smooth_threaded_spacing,sheet_thickness,0])
          square([z_motor_mount_width+sheet_thickness*4,sheet_thickness],center=true);
      }
    }
  }

  module holes() {
    // rod hole
    accurate_circle(rod_diam,16);

    total_width = z_motor_mount_width + sheet_thickness*4;
    slot_width = (total_width - motor_shoulder_diam - sheet_thickness*2)/2;
    translate([-z_smooth_threaded_spacing,0,0]) {
      translate([0,main_plate_y,0]) {
        // main plate screw hole
        accurate_circle(3,10);

        // main plate slots
        for(side=[left,right]) {
          translate([(total_width/2-slot_width/2)*side,0,0])
            square([slot_width,sheet_thickness],center=true);
        }
      }

      rotate([0,0,22.5]) accurate_circle(rod_diam*2,16);
      translate([-rod_diam*2,0,0]) square([rod_diam*4,rod_diam*2],center=true);
      translate([0,-rod_diam*2,0]) square([rod_diam*2,rod_diam*4],center=true);
    }

    // side brace screw hole
    translate([-z_smooth_threaded_spacing-z_motor_mount_width/2-sheet_thickness/2,main_plate_y+sheet_thickness*3,0])
      accurate_circle(3,10);

    // retainer screw hole
    translate([0,z_rod_retainer_rod_screw_dist,0]) accurate_circle(3,8);
  }

  difference() {
    body();
    holes();
  }
}

module z_rod_retainer() {
  module body() {
    hull() {
      accurate_circle(rod_diam*2,12);

      translate([0,z_rod_retainer_rod_screw_dist,0]) rotate([0,0,22.5])
        accurate_circle(3*3,8);
    }
  }

  module holes() {
    translate([0,z_rod_retainer_rod_screw_dist,0]) accurate_circle(3,8);
  }

  difference() {
    body();
    holes();
  }
}

module top_rear_brace() {
  module body() {
    box_side([top_rear_brace_width,top_rear_brace_height],[0,2,0,2]);
  }

  module holes() {
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
        square([rod_diam,rod_diam],center=true);
        translate([0,-rod_diam/2,0])
          accurate_circle(rod_diam,32);
      }
    }

    clearance_depth = rod_diam;

    // center bed mount clearance
    hull() {
      for(side=[left,right]) {
        translate([clearance_depth*side,front_face_height/2,0]) {
          rotate([0,0,22.5])
            accurate_circle(12,8);
        }
      }
    }

    for(side=[left,right]) {
      // bed mount screw clearance
      hull() {
        translate([side*(build_y/2),front_face_height/2,0]) rotate([0,0,22.5])
          accurate_circle(clearance_depth*2,8);

        translate([side*(y_rod_spacing/2+rod_diam/2+y_rod_zip_tie_space+clearance_depth),front_face_height/2,0]) rotate([0,0,22.5])
          accurate_circle(clearance_depth*2,8);
      }

      // this would probably be bad with plywood; it would probably delaminate
      // zip tie holes
      translate([y_rod_spacing/2*side,front_face_height/2-rod_diam/2,0])
        y_rod_retainer_zip_tie_holes();
    }

    for(side=[left,right]) {
      translate([(y_motor_x_pos+sheet_thickness/2)*side,-front_face_height/2+motor_side/2,0]) scale([1,1,1.1]) rotate([0,0,90])
        bc_tab_pair(1);
    }
  }

  color("green") difference() {
    body();
    holes();
  }
}

module y_rod_retainer_zip_tie_holes() {
  // this would probably be bad with plywood; it would probably delaminate
  // zip tie holes
  translate([0,-rod_diam/2+zip_tie_width/2,0]) {
    for(side=[left,right]) {
      translate([(rod_diam/2+y_rod_zip_tie_space/2)*side,0,0])
        square([zip_tie_thickness,zip_tie_width],center=true);
    }

    translate([0,-rod_diam/2-3,0])
      accurate_circle(3,8);
  }
}

module y_rod_retainer() {
  width = rod_diam + y_rod_zip_tie_space*2;
  height = rod_diam + y_rod_zip_tie_space + 2;

  module body() {
    translate([0,-y_rod_zip_tie_space/2 - 1,0])
      square([width,height],center=true);
  }

  module holes() {
    hull() {
      for(y=[-1,1]) {
        translate([0,y*1,0]) rotate([0,0,60])
          accurate_circle(2,6);
      }
    }

    y_rod_retainer_zip_tie_holes();
  }

  difference() {
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

  difference() {
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

  difference() {
    body();
    holes();
  }
}

module y_motor_mount() {
  module body() {
    box_side([motor_side,motor_side],[0,1,1,0]);
  }

  module holes() {
    accurate_circle(motor_shoulder_diam,16);

    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0])
          accurate_circle(3,10);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module y_idler() {
  module body() {
    intersection() {
      box_side([motor_side,motor_side],[0,1,1,0]);
    }
  }

  module holes() {
    diagonal = sqrt(pow(motor_side,2)*2);
    offset = motor_side*.5 + 9;
    translate([offset,offset,0]) rotate([0,0,65])
      square([diagonal,diagonal*2],center=true);

    accurate_circle(y_bearing_id,10);
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  translate([0,main_plate_y_pos,main_plate_z_pos]) rotate([90,0,0])
    color("lightblue")
      linear_extrude(height=sheet_thickness,center=true)
        main_plate();

  translate([front_face_x_pos,front_face_y_pos,front_face_z_pos]) rotate([90,0,0])
    color("green")
      linear_extrude(height=sheet_thickness,center=true)
        front_face();

  translate([rear_face_x_pos,rear_face_y_pos,rear_face_z_pos]) rotate([90,0,0])
    color("green")
      linear_extrude(height=sheet_thickness,center=true)
        rear_face();

  translate([top_rear_brace_x_pos,top_rear_brace_y_pos,top_rear_brace_z_pos]) rotate([90,0,0])
    color("green")
      linear_extrude(height=sheet_thickness,center=true)
        top_rear_brace();

  translate([y_motor_x_pos,y_motor_y_pos,y_motor_z_pos]) {
    % rotate([0,90,0]) motor();
    //translate([sheet_thickness/2,0,0]) rotate([0,90,0]) rotate([0,0,180])
    translate([sheet_thickness/2,0,0]) rotate([0,90,0]) rotate([0,0,180])
      color("purple")
        linear_extrude(height=sheet_thickness,center=true)
          y_motor_mount();
  }

  for(side=[left,right]) {
    translate([(y_motor_x_pos+sheet_thickness/2)*side,-y_motor_y_pos,y_motor_z_pos]) {
      rotate([0,90,0])
        rotate([0,0,90])
          color("purple")
            linear_extrude(height=sheet_thickness,center=true)
              y_idler();
    }
  }

  translate([y_carriage_x_pos,y_carriage_y_pos,y_carriage_z_pos])
    color("violet")
      linear_extrude(height=sheet_thickness,center=true)
        y_carriage();

  translate([bottom_plate_x_pos,bottom_plate_y_pos,bottom_plate_z_pos])
    color("turquoise")
      linear_extrude(height=sheet_thickness,center=true)
        bottom_plate();

  translate([psu_x_pos,psu_y_pos,psu_z_pos]) {
    % cube([psu_height,psu_width,psu_length],center=true);

    translate([-psu_height/2-sheet_thickness/2,0,0]) {
      for(x=[-.5,.5]) {
        for(y=[-.5,.5]) {
          translate([0.05,psu_hole_spacing_x*x,psu_hole_spacing_y*y])
            rotate([0,90,0])
              color("green")
                linear_extrude(height=sheet_thickness,center=true)
                  psu_spacer();
        }
      }
    }
  }

  for(side=[left,right]) {
    translate([z_motor_x_pos*side,z_motor_y_pos,z_motor_z_pos+0.05])
      % motor();

    translate([z_motor_mount_x_pos*side,z_motor_mount_y_pos,z_motor_mount_z_pos+0.05]) mirror([1-side,0,0])
      color("purple")
        linear_extrude(height=sheet_thickness,center=true)
          z_motor_mount();

    translate([z_motor_brace_x_pos*side,z_motor_brace_y_pos,z_motor_brace_z_pos]) mirror([1-side,0,0]) rotate([0,90,0])
      color("orange")
        linear_extrude(height=sheet_thickness,center=true)
          z_motor_brace();

    translate([side_brace_x_pos*side,side_brace_y_pos,side_brace_z_pos]) rotate([0,0,-90]) rotate([90,0,0])
      color("orangered")
        linear_extrude(height=sheet_thickness,center=true)
          side_brace();

    translate([z_rod_top_brace_x_pos*side,z_rod_top_brace_y_pos,z_rod_top_brace_z_pos+0.05]) {
      mirror([1-side,0,0])
        color("orange")
          linear_extrude(height=sheet_thickness,center=true)
            z_rod_top_brace();

      translate([0,0,sheet_thickness+0.05])
        color("green")
          linear_extrude(height=sheet_thickness,center=true)
            z_rod_retainer();
    }

    for(end=[front,rear]) {
      color("orange")
        translate([y_rod_spacing/2*side,(rear_face_y_pos+sheet_thickness)*end,-rod_diam/2])
          rotate([90,0,0])
            linear_extrude(height=sheet_thickness,center=true)
              y_rod_retainer();
    }

    // y rods
    translate([y_rod_spacing/2*side,0,-rod_diam/2]) color("grey", 0.5) {
      rotate([90,0,0])
        hole(rod_diam,side_brace_total_depth + sheet_thickness*2 + 0.05,16);

      for(y=[front,rear]) {
        % translate([0,y_carriage_y_pos+(y_carriage_bearing_spacing_y/2)*y,0]) bearing();
      }
    }


    // z rods
    translate([z_smooth_rod_x_pos*side,z_smooth_rod_y_pos,z_smooth_rod_z_pos]) {
      color("grey", 0.5)
        hole(rod_diam,z_smooth_rod_len,16);
    }
  }

  translate([y_carriage_x_pos,y_carriage_y_pos,y_carriage_z_pos+sheet_thickness/2+3])
    color("red",0.5) heatbed();
}

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
    cylinder(r=da8*bearing_diam,h=bearing_len,center=true,$fn=16);
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
      cylinder(r=belt_bearing_inner/2,h=belt_bearing_thickness+0.05,center=true,$fn=8);
  }
}

module heatbed() {
  difference() {
    cube([heatbed_width,heatbed_depth,heatbed_thickness],center=true);
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([heatbed_hole_spacing_x/2*side,heatbed_hole_spacing_y/2*end,0])
          cylinder(r=heatbed_hole_diam/2,h=heatbed_thickness+0.05,center=true);
      }
    }
  }
}

module endstop() {
  cube([endstop_len,endstop_width,endstop_height],center=true);

  translate([0,0,endstop_height/2+.5]) rotate([0,5,0])
    cube([endstop_len-4,endstop_width-1,.5],center=true);
}

module rambo_holes() {
  x = 95;
  y = 96;

  hull() {
    translate([0,y,0]) rotate([0,0,22.5]) accurate_circle(3,8);
    translate([0,x,0]) rotate([0,0,22.5]) accurate_circle(3,8);
  }

  hull() {
    translate([y,0,0]) rotate([0,0,22.5]) accurate_circle(3,8);
    translate([x,0,0]) rotate([0,0,22.5]) accurate_circle(3,8);
  }

  hull() {
    translate([y,x,0]) rotate([0,0,22.5]) accurate_circle(3,8);
    translate([x,y,0]) rotate([0,0,22.5]) accurate_circle(3,8);
  }

  translate([0,0,0]) rotate([0,0,22.5]) accurate_circle(3,8);
}

module sanguinololu_holes() {
  len = 93;
  width = 43;

  translate([len/2,len/2,0]) {
    for(x=[-len/2,len/2]) {
      for(y=[-width/2,width/2]) {
        translate([x,y,0]) rotate([0,0,22.5]) accurate_circle(3,8);
      }
    }
  }
}

module arduino_mount_holes() {
  /*
  // converting from ****ing milli-inches to mm
  // used
  //   * https://farm6.static.flickr.com/5091/5484250200_dc106d9efd.jpg but it's missing a hole
  //   * http://forum.arduino.cc/index.php?topic=17032.0 but it is wrong in places
  //   * http://www.wayneandlayne.com/files/common/arduino_mega_drawing_500x264.png but it is very blurry
  //
  // Finally, I found this one after the fact:
  //   http://files.hwkitchen.com/200000736-26528274c8/arduino-mega2560-holes-coordinates.jpg

  holes = [
    [550*.0254  - 13.97,100*.0254-2.54], // bottom left
    [600*.0254  - 13.97,2000*.0254-2.54], // top left
    [3550*.0254 - 13.97,2000*.0254-2.54], // top right
    [3800*.0254 - 13.97,100*.0254-2.54] // bottom right
  ];
  */

  holes = [
    [0     ,0], // bottom left
    [1.27  ,48.26], // top left
    [76.2  ,48.26], // top right
    [82.55 ,0] // bottom right
  ];

  height = 48.26;
  width = 82.55;

  board_width = 101.6;
  board_height = 53.3;

  translate([13.97,2.54,0]) {
    color("red")    translate(holes[0]) rotate([0,0,22.5]) accurate_circle(3,8);
    color("green")  translate(holes[1]) rotate([0,0,22.5]) accurate_circle(3,8);
    color("blue")   translate(holes[2]) rotate([0,0,22.5]) accurate_circle(3,8);
    color("yellow") translate(holes[3]) rotate([0,0,22.5]) accurate_circle(3,8);
  }
}

assembly();
