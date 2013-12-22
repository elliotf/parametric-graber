include <config.scad>;

z_overhead = sheet_thickness * 1.5; // bed support, y motor, y linear bearings, zip ties, etc.
y_rod_spacing = build_x*.75;

z_smooth_threaded_spacing = 17;

build_x_with_overhead = build_x + 30;
build_y_with_overhead = build_y * 1.4;
build_z_with_overhead = build_z + z_overhead;

x_carriage_height = 60; // from prusa i3 parts

side_brace_vertical_depth = build_y_with_overhead/2;
side_brace_horizontal_height = sheet_thickness*2+motor_side;

main_plate_width = build_x_with_overhead + sheet_thickness*4 + (sheet_thickness*2 + motor_side)*2;
main_plate_height = build_z_with_overhead + x_carriage_height + side_brace_horizontal_height;

main_plate_y_pos = 0;
main_plate_z_pos = main_plate_height/2 - side_brace_horizontal_height;

side_brace_total_depth = build_y_with_overhead+sheet_thickness;
side_brace_total_height = main_plate_height;

side_brace_x_pos = build_x_with_overhead/2 + sheet_thickness + sheet_thickness/2;
side_brace_y_pos = 0;
side_brace_z_pos = main_plate_z_pos;

bottom_plate_width = side_brace_x_pos * 2 - sheet_thickness;
bottom_plate_depth = build_y_with_overhead + sheet_thickness;

front_face_width = side_brace_x_pos*2 - sheet_thickness;
front_face_height = side_brace_horizontal_height;

rear_face_width = front_face_width;
rear_face_height = front_face_height;

// TODO:
// * eventually compensate Y for nozzle distance from x carriage and smooth rod and main plate
//   * as in, things should be skewed to the front of the printer

bottom_plate_x_pos = 0;
bottom_plate_y_pos = 0;
bottom_plate_z_pos = -side_brace_horizontal_height-sheet_thickness/2;

bed_support_x_pos = 0;
bed_support_y_pos = 0;
bed_support_z_pos = -sheet_thickness/2+z_overhead;

z_motor_x_pos = main_plate_width/2-sheet_thickness*2-motor_side/2;
z_motor_y_pos = (motor_side/2+sheet_thickness/2)*front;
z_motor_z_pos = 0;

front_face_x_pos = 0;
front_face_y_pos = (bottom_plate_depth/2+sheet_thickness/2)*front;
front_face_z_pos = bottom_plate_z_pos + front_face_height/2 + sheet_thickness/2;

rear_face_x_pos = 0;
rear_face_y_pos = (bottom_plate_depth/2+sheet_thickness/2)*rear;
rear_face_z_pos = front_face_z_pos;
