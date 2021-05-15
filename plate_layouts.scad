include <config.scad>;
include <positions.scad>;
use <util.scad>;
use <main.scad>;

sheet_width = 600;
sheet_height = 450;
overhead = sheet_thickness*2;

main_plate_arm_width = sheet_thickness*5+z_motor_mount_width;

module plate_1of2_24x18() {
  % translate([0,0,-sheet_thickness])
    square([sheet_width,sheet_height],center=true);

  translate([-sheet_width/2,sheet_height/2,0]) {
    translate([main_plate_width/2,-main_plate_height/2,0])
      main_plate();
    translate([main_plate_arm_width+y_carriage_width/2,-x_carriage_height-y_carriage_depth/2,0]) {
      y_carriage();

      translate([-y_carriage_width/2,-y_carriage_depth/2 - overhead*2,0]) {
        for(i=[0:5]) {
          translate([(rod_diam+y_rod_zip_tie_space+sheet_thickness)*i,0,0]) rotate([0,0,90])
            y_rod_retainer();
        }

        translate([0,-rod_diam-y_rod_zip_tie_space-sheet_thickness-10,0]) {
          for(i=[0:5]) {
            translate([14*i,0,0])
              psu_spacer();
          }
        }
      }
    }
  }

  translate([sheet_width/2,-sheet_height/2,0])
    translate([-side_brace_total_depth/2-sheet_thickness,side_brace_total_height/2+overhead,0]) rotate([0,180,0])
      side_brace();

  //translate([-sheet_width/2,-sheet_height/2+overhead*1.5,0]) {
  translate([sheet_width/2-side_brace_total_depth,-sheet_height/2+overhead*1.5,0]) {
    translate([-z_motor_mount_width*3,0,0]) {
      z_rod_top_brace();

      translate([-z_rod_retainer_rod_screw_dist*2,-rod_diam/2,0]) rotate([0,0,-90])
        z_rod_retainer();

      translate([overhead*4,0,0]) {
        rotate([0,180,0])
          z_rod_top_brace();

        translate([z_rod_retainer_rod_screw_dist*2,-rod_diam/2,0]) rotate([0,0,90])
          z_rod_retainer();
      }
    }
  }
}

module plate_2of2_24x18() {
  % translate([0,0,-sheet_thickness])
    square([sheet_width,sheet_height],center=true);

  translate([-sheet_width/2+side_brace_total_depth/2+sheet_thickness,-sheet_height/2+side_brace_total_height/2+overhead,0])
    side_brace();

  translate([sheet_width/2-bottom_plate_width/2-sheet_thickness,sheet_height/2-bottom_plate_depth/2-sheet_thickness,0]) {
    bottom_plate();
  }

  translate([-sheet_width/2,sheet_height/2,0]) {
    translate([z_motor_brace_depth*1,-z_motor_brace_depth/2-sheet_thickness,0]) {
      // z brace
      for(side=[left,right]) {
        translate([z_motor_brace_depth*.2*side,0,0]) rotate([0,0,90+90*side])
          z_motor_brace();
      }
    }

    translate([z_motor_brace_depth*2.5,-motor_side/2,0]) {
      y_motor_mount();

      translate([motor_side*1.5+overhead,0,0]) {
        for(side=[left,right]) {
          translate([(motor_side/2+2)*side,0,0]) rotate([0,90+90*side,0])
            y_idler();
        }
      }
    }
  }

  translate([-sheet_width/2+side_brace_vertical_depth+sheet_thickness*3+front_face_height/2,-sheet_height/2+front_face_width/2+overhead*2+sheet_thickness+side_brace_horizontal_height,0]) {
    rotate([0,0,90])
      front_face();

    translate([front_face_height+overhead+sheet_thickness,0,0]) rotate([0,0,90])
      front_face();

    translate([front_face_height*1.5+top_rear_brace_height/2+overhead*3,0,0]) rotate([0,0,90])
      top_rear_brace();
  }

  translate([sheet_width/2,-sheet_height/2,0]) {
    translate([-z_motor_mount_width-overhead*2.1,z_motor_mount_depth/2,0]) {
      for(side=[left,right]) {
        translate([(z_motor_mount_width/2+overhead*1.1)*side,0,0])
        rotate([0,90+90*side,0])
          z_motor_mount();
      }
    }
  }
}

translate([0,sheet_height/2+sheet_thickness,0]) plate_1of2_24x18();
translate([0,-sheet_height/2-sheet_thickness,0]) plate_2of2_24x18();
