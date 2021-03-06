include <config.scad>;

y_carriage_width = build_x+20;
y_carriage_depth = build_y+20;

z_overhead = 20; // bed support, y motor, y linear bearings, zip ties, etc.
y_rod_spacing = build_x-40;
y_carriage_bearing_spacing_y = build_y*.4;

z_smooth_threaded_spacing = 17;

y_rod_zip_tie_space = 8;

build_x_with_overhead = y_carriage_width + 30;
build_y_with_overhead = build_y + y_carriage_bearing_spacing_y + bearing_len + 30;
build_z_with_overhead = build_z + z_overhead;

space_behind_z_motor = 6; // make room for X smooth rods, motor/idler plastic
skew_main_plate_to_rear = nema17_side+sheet_thickness/2+space_behind_z_motor;

x_carriage_height = 60; // from prusa i3 parts

z_motor_mount_width = nema17_side + 2;
z_motor_mount_depth = nema17_side+space_behind_z_motor;

z_motor_brace_depth = z_motor_mount_depth;
z_motor_brace_height = z_motor_brace_depth;

side_brace_vertical_depth = build_y_with_overhead/2-skew_main_plate_to_rear;
side_brace_horizontal_height = sheet_thickness+motor_side;

main_plate_width = build_x_with_overhead + sheet_thickness*4 + (sheet_thickness*2 + z_motor_mount_width)*2;
main_plate_height = build_z_with_overhead + x_carriage_height + side_brace_horizontal_height;

main_plate_y_pos = skew_main_plate_to_rear;
main_plate_z_pos = main_plate_height/2 - side_brace_horizontal_height;

side_brace_total_depth = build_y_with_overhead+sheet_thickness;
side_brace_total_height = main_plate_height;
side_brace_vertical_height = side_brace_total_height - side_brace_horizontal_height;

side_brace_x_pos = build_x_with_overhead/2 + sheet_thickness + sheet_thickness/2;
side_brace_y_pos = 0;
side_brace_z_pos = side_brace_total_height/2-side_brace_horizontal_height;

bottom_plate_width = side_brace_x_pos * 2 - sheet_thickness;
bottom_plate_depth = build_y_with_overhead + sheet_thickness;

front_face_width = side_brace_x_pos*2 - sheet_thickness;
front_face_height = side_brace_horizontal_height;

rear_face_width = front_face_width;
rear_face_height = front_face_height;

top_rear_brace_width = rear_face_width;
top_rear_brace_height = rear_face_height;

// TODO:
// * eventually compensate Y for nozzle distance from x carriage and smooth rod and main plate
//   * as in, things should be skewed to the front of the printer

bottom_plate_x_pos = 0;
bottom_plate_y_pos = 0;
bottom_plate_z_pos = -side_brace_horizontal_height-sheet_thickness/2;

y_carriage_x_pos = 0;
y_carriage_y_pos = build_y*.5*0;
y_carriage_z_pos = sheet_thickness/2+bearing_diam/2-rod_diam/2-1;

heatbed_x_pos = y_carriage_x_pos;
heatbed_y_pos = y_carriage_y_pos;
heatbed_z_pos = y_carriage_z_pos + sheet_thickness/2 + heatbed_thickness/2 + 3;

z_motor_x_pos = side_brace_x_pos + sheet_thickness/2 + z_motor_mount_width/2;
z_motor_y_pos = skew_main_plate_to_rear+(z_motor_mount_depth/2+sheet_thickness/2+space_behind_z_motor/2)*front;
z_motor_z_pos = -sheet_thickness;

z_smooth_rod_x_pos = z_motor_x_pos + z_smooth_threaded_spacing;
z_smooth_rod_y_pos = z_motor_y_pos;
z_smooth_rod_z_pos = side_brace_vertical_height/2-sheet_thickness/2;

x_smooth_rod_len = z_smooth_rod_x_pos*2;
y_smooth_rod_len = side_brace_total_depth + sheet_thickness*2;
z_smooth_rod_len = side_brace_vertical_height + sheet_thickness;

echo("BOM: X smooth rod len: ", x_smooth_rod_len);
echo("BOM: Y smooth rod len: ", y_smooth_rod_len);
echo("BOM: Z smooth rod len: ", z_smooth_rod_len);

z_motor_mount_x_pos = z_motor_x_pos;
z_motor_mount_y_pos = z_motor_y_pos + space_behind_z_motor/2;
z_motor_mount_z_pos = z_motor_z_pos + sheet_thickness/2;

z_motor_brace_x_pos = z_motor_x_pos + z_motor_mount_width/2 + sheet_thickness/2;
z_motor_brace_y_pos = z_motor_y_pos + space_behind_z_motor/2;
z_motor_brace_z_pos = z_motor_z_pos - z_motor_brace_height/2;

z_rod_top_brace_x_pos = z_smooth_rod_x_pos;
z_rod_top_brace_y_pos = z_motor_y_pos;
z_rod_top_brace_z_pos = side_brace_vertical_height - sheet_thickness/2;
z_rod_retainer_rod_screw_dist = rod_diam*2;

y_motor_x_pos = -belt_width/2-1-sheet_thickness;
y_motor_y_pos = (side_brace_total_depth/2-motor_side/2)*rear;
y_motor_z_pos = bottom_plate_z_pos+sheet_thickness/2+motor_side/2;

front_face_x_pos = 0;
front_face_y_pos = (bottom_plate_depth/2+sheet_thickness/2)*front;
front_face_z_pos = bottom_plate_z_pos + front_face_height/2 + sheet_thickness/2;

rear_face_x_pos = 0;
rear_face_y_pos = (bottom_plate_depth/2+sheet_thickness/2)*rear;
rear_face_z_pos = front_face_z_pos;

top_rear_brace_x_pos = 0;
top_rear_brace_y_pos = (bottom_plate_depth/2+sheet_thickness/2)*rear;
top_rear_brace_z_pos = side_brace_vertical_height-top_rear_brace_height/2;

psu_cover_screw_height = 3;
psu_cover_thickness = 1.5;
psu_x_pos = side_brace_x_pos + sheet_thickness*1.5 + psu_height/2;
psu_y_pos = skew_main_plate_to_rear + sheet_thickness/2 + psu_cover_screw_height + psu_cover_thickness + psu_hole_from_side + psu_hole_spacing_x/2;
psu_z_pos = psu_length/2 + 20;

front_wire_passthrough_hole_y_pos = side_brace_total_depth/2-side_brace_vertical_depth;
front_wire_passthrough_hole_z_pos = -side_brace_total_height/2+sheet_thickness*2;
