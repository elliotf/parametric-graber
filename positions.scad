include <config.scad>;

z_overhead = sheet_thickness * 1.5; // bed support, y motor, y linear bearings, zip ties, etc.
y_rod_spacing = build_x*.6;
y_carriage_bearing_spacing_y = build_y*.4;

z_smooth_threaded_spacing = 17;

build_x_with_overhead = build_x + 30;
build_y_with_overhead = build_y * 1.6;
build_z_with_overhead = build_z + z_overhead;

skew_main_plate_to_rear = nema17_side+sheet_thickness/2;

x_carriage_height = 60; // from prusa i3 parts

z_motor_mount_width = nema17_side;
z_motor_mount_depth = nema17_side;

z_motor_brace_depth = z_motor_mount_depth;
z_motor_brace_height = z_motor_brace_depth;

side_brace_vertical_depth = build_y_with_overhead/2-skew_main_plate_to_rear;
side_brace_horizontal_height = sheet_thickness*2+motor_side;

main_plate_width = build_x_with_overhead + sheet_thickness*4 + (sheet_thickness*2 + z_motor_mount_width)*2;
main_plate_height = build_z_with_overhead + x_carriage_height + side_brace_horizontal_height;

main_plate_y_pos = skew_main_plate_to_rear;
main_plate_z_pos = main_plate_height/2 - side_brace_horizontal_height;

side_brace_total_depth = build_y_with_overhead+sheet_thickness;
side_brace_total_height = main_plate_height;
side_brace_vertical_height = side_brace_total_height - side_brace_horizontal_height;
z_smooth_rod_len = side_brace_vertical_height + sheet_thickness - 0.05;

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

y_carriage_x_pos = 0;
y_carriage_y_pos = 0;
y_carriage_z_pos = -sheet_thickness/2+z_overhead;

z_motor_x_pos = side_brace_x_pos + sheet_thickness/2 + z_motor_mount_width/2;
z_motor_y_pos = skew_main_plate_to_rear+(z_motor_mount_depth/2+sheet_thickness/2)*front;
z_motor_z_pos = -sheet_thickness;

z_smooth_rod_x_pos = z_motor_x_pos + z_smooth_threaded_spacing;
z_smooth_rod_y_pos = z_motor_y_pos;
z_smooth_rod_z_pos = side_brace_vertical_height/2-sheet_thickness/2;

z_motor_brace_x_pos = z_motor_x_pos + z_motor_mount_width/2 + sheet_thickness/2;
z_motor_brace_y_pos = z_motor_y_pos;
z_motor_brace_z_pos = z_motor_z_pos - z_motor_brace_height/2;

z_rod_top_brace_x_pos = z_smooth_rod_x_pos;
z_rod_top_brace_y_pos = z_motor_y_pos;
z_rod_top_brace_z_pos = side_brace_vertical_height - sheet_thickness/2;

y_motor_x_pos = -y_bearing_thickness-sheet_thickness-1;
y_motor_y_pos = (side_brace_total_depth/2-motor_side/2)*front;
y_motor_z_pos = bottom_plate_z_pos+sheet_thickness/2+motor_side/2;

front_face_x_pos = 0;
front_face_y_pos = (bottom_plate_depth/2+sheet_thickness/2)*front;
front_face_z_pos = bottom_plate_z_pos + front_face_height/2 + sheet_thickness/2;

rear_face_x_pos = 0;
rear_face_y_pos = (bottom_plate_depth/2+sheet_thickness/2)*rear;
rear_face_z_pos = front_face_z_pos;

psu_x_pos = side_brace_x_pos + 5 + psu_height/2;
psu_y_pos = skew_main_plate_to_rear + sheet_thickness/2 + psu_width/2;
psu_z_pos = psu_length/2 + 30;
