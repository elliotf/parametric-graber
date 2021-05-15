bc_tab_len=9;
bc_screw_diam=3;
bc_nut_diam=5.45;
bc_shoulder_width=6;
bc_thickness=6;
bc_tab_from_end_dist=bc_shoulder_width*3.5;

WITH_HOLES = 1;
NO_HOLES = 0;

hole_resolution = 16;

module bc_screw_nut_hole() {
  // DUPE

  tab_len           = bc_tab_len;
  screw_diam        = bc_screw_diam;
  nut_diam          = bc_nut_diam;
  shoulder_width    = bc_shoulder_width;
  thickness         = bc_thickness;
  tab_from_end_dist = bc_tab_from_end_dist;

  nyloc_nut_height = 4;
  std_nut_height = 2.5;
  //nut_height = nyloc_nut_height;
  nut_height = std_nut_height;

  tab_slot_pair_space = tab_len * 1.5;
  tab_slot_pair_len = tab_len*2 + tab_slot_pair_space;
  space_between_tab_slot_pairs = tab_slot_pair_len*2.01;
  pair_and_spacing_len = tab_slot_pair_len + space_between_tab_slot_pairs;

  // END DUPE

  translate([-tab_slot_pair_len/2,0,0]) bc_offset_screw_nut_hole();
}

module bc_offset_screw_nut_hole() {
  // DUPE

  tab_len           = bc_tab_len;
  screw_diam        = bc_screw_diam;
  nut_diam          = bc_nut_diam;
  shoulder_width    = bc_shoulder_width;
  thickness         = bc_thickness;
  tab_from_end_dist = bc_tab_from_end_dist;

  nyloc_nut_height = 4;
  std_nut_height = 2.5;
  //nut_height = nyloc_nut_height;
  nut_height = std_nut_height;

  tab_slot_pair_space = tab_len * 1.5;
  tab_slot_pair_len = tab_len*2 + tab_slot_pair_space;
  space_between_tab_slot_pairs = tab_slot_pair_len*2.01;
  pair_and_spacing_len = tab_slot_pair_len + space_between_tab_slot_pairs;

  // END DUPE

  thick = thickness+0.05;
  screw_len = shoulder_width * .9 + nut_height;

  translate([tab_slot_pair_len/2,-thickness/2,0]) {
    translate([0,-shoulder_width*0.65-nut_height/2,0])
      square([nut_diam,nut_height],center=true);

    translate([0,-screw_len/2+0.05,0])
      square([screw_diam,screw_len],center=true);
  }
}

module bc_position_along_line(to_fill=0) {
  // DUPE

  tab_len           = bc_tab_len;
  screw_diam        = bc_screw_diam;
  nut_diam          = bc_nut_diam;
  shoulder_width    = bc_shoulder_width;
  thickness         = bc_thickness;
  tab_from_end_dist = bc_tab_from_end_dist;

  nyloc_nut_height = 4;
  std_nut_height = 2.5;
  //nut_height = nyloc_nut_height;
  nut_height = std_nut_height;

  tab_slot_pair_space = tab_len * 1.5;
  tab_slot_pair_len = tab_len*2 + tab_slot_pair_space;
  space_between_tab_slot_pairs = tab_slot_pair_len*2.01;
  pair_and_spacing_len = tab_slot_pair_len + space_between_tab_slot_pairs;

  // END DUPE

  space_avail = to_fill + space_between_tab_slot_pairs;
  //echo("to_fill: ", to_fill);
  //echo("space_avail: ", space_avail);
  //echo("tab_slot_pair_len: ", tab_slot_pair_len);

  raw_num_fit = floor(space_avail/pair_and_spacing_len);

  //echo("raw_num_fit: ", raw_num_fit);

  function adjust_num_fit()
    = (raw_num_fit > 2)
    ? raw_num_fit
    : (tab_slot_pair_len*2+tab_len < to_fill)
      ? 2
      : 1;

  num_fit = adjust_num_fit();

  space_consumed = tab_slot_pair_len*num_fit;
  space_remaining = to_fill - space_consumed;
  space_between = space_remaining/(num_fit-1);
  //echo("new space between tab sets: ", space_between);

  //echo("WILL FIT ", num_fit, " TAB SETS WITH ", space_between, "mm BETWEEN THEM");

  if(num_fit ==1) {
    translate([-tab_slot_pair_len/2,0,0])
    children();
  } else {
    translate([-to_fill/2,0,0]) {
      for(i=[0:num_fit-1]) {
        translate([i*(tab_slot_pair_len+space_between),0,0]) {
          children();
        }
      }
    }
  }
}

module bc_tab_pair(with_hole=WITH_HOLES) {
  // DUPE

  tab_len           = bc_tab_len;
  screw_diam        = bc_screw_diam;
  nut_diam          = bc_nut_diam;
  shoulder_width    = bc_shoulder_width;
  thickness         = bc_thickness;
  tab_from_end_dist = bc_tab_from_end_dist;

  nyloc_nut_height = 4;
  std_nut_height = 2.5;
  //nut_height = nyloc_nut_height;
  nut_height = std_nut_height;

  tab_slot_pair_space = tab_len * 1.5;
  tab_slot_pair_len = tab_len*2 + tab_slot_pair_space;
  space_between_tab_slot_pairs = tab_slot_pair_len*2.01;
  pair_and_spacing_len = tab_slot_pair_len + space_between_tab_slot_pairs;

  WITH_HOLES = 1;
  NO_HOLES = 0;

  // END DUPE

  translate([-tab_slot_pair_len/2,0,0]) bc_offset_tab_pair(with_hole);
}

module bc_offset_tab_pair(with_hole=NO_HOLES) {
  // DUPE

  tab_len           = bc_tab_len;
  screw_diam        = bc_screw_diam;
  nut_diam          = bc_nut_diam;
  shoulder_width    = bc_shoulder_width;
  thickness         = bc_thickness;
  tab_from_end_dist = bc_tab_from_end_dist;

  nyloc_nut_height = 4;
  std_nut_height = 2.5;
  //nut_height = nyloc_nut_height;
  nut_height = std_nut_height;

  tab_slot_pair_space = tab_len * 1.5;
  tab_slot_pair_len = tab_len*2 + tab_slot_pair_space;
  space_between_tab_slot_pairs = tab_slot_pair_len*2.01;
  pair_and_spacing_len = tab_slot_pair_len + space_between_tab_slot_pairs;

  WITH_HOLES = 1;
  NO_HOLES = 0;

  // END DUPE

  module tab() {
    translate([tab_len/2,0,0])
      square([tab_len,thickness+0.05],center=true);
  }

  tab();
  translate([tab_len+tab_slot_pair_space,0,0]) tab();

  if(with_hole==WITH_HOLES) {
    translate([tab_slot_pair_len/2,0,0])
      accurate_circle(screw_diam,hole_resolution);
  }
}

module box_side(dimensions=[0,0],sides=[0,0,0,0]) {
  // DUPE

  tab_len           = bc_tab_len;
  screw_diam        = bc_screw_diam;
  nut_diam          = bc_nut_diam;
  shoulder_width    = bc_shoulder_width;
  thickness         = bc_thickness;
  tab_from_end_dist = bc_tab_from_end_dist;

  nyloc_nut_height = 4;
  std_nut_height = 2.5;
  //nut_height = nyloc_nut_height;
  nut_height = std_nut_height;

  echo("Screw length: ", thickness + shoulder_width + nut_height);

  tab_slot_pair_space = tab_len * 1.5;
  tab_slot_pair_len = tab_len*2 + tab_slot_pair_space;
  space_between_tab_slot_pairs = tab_slot_pair_len*2.01;
  pair_and_spacing_len = tab_slot_pair_len + space_between_tab_slot_pairs;

  // END DUPE

  // creates a side of a box with tabs or slots that surrounds the provided dimensions

  IS_TAB = 1;
  IS_SLOT = 2;
  WITH_HOLES = 1;
  NO_HOLES = 0;

  // TODO: have top of box overlap sides

  // dimensions is the internal width/height of the sheet
  // sides is a list of top,right,bottom,left sides
  //   0 == no tabs,no slots
  //   1 == tabs
  //   2 == slots
  // screw_diam is the diameter of the screw that will be used with the nut to clamp
  // nut_diam is the diameter of the nut that will be used with the screw to clamp
  // shoulder_width is:
  //   the amount of material that should be on the other side of a slot
  //   used as a basis for the distance of a tab/slot from an edge
  // thickness is the thickness of the material

  colors = ["red","green","blue","yellow"];

  function offset_for_side(side) = dimensions[1-side%2]/2 + thickness/2;
  function len_for_side(side) = dimensions[side%2];

  module add_material_for_slot_side(side) {
    slots_to_right = floor(sides[(side+3)%4]/IS_SLOT);
    slots_to_left  = floor(sides[(side+1)%4]/IS_SLOT);

    len_to_add = shoulder_width+thickness;

    len = len_to_add*(slots_to_right+slots_to_left) + len_for_side(side);

    trans_dist = 0 + len_to_add/2*slots_to_right + len_to_add/2*-slots_to_left;
    translate([trans_dist,(shoulder_width)/2,0])
      square([len,thickness+shoulder_width],center=true);
  }

  function tab_space_for_side(side) = dimensions[side%2]-tab_from_end_dist*2;

  difference() {
    union() {
      square([dimensions[0],dimensions[1]],center=true);

      for(side=[0,1,2,3]) {
        color(colors[side])
          rotate([0,0,90*side])
            translate([0,offset_for_side(side),0]) {
              // tabs?
              if(sides[side] == IS_TAB) {
                //echo("add tabs for side ", side);
                bc_position_along_line(tab_space_for_side(side)) bc_offset_tab_pair();
              }

              // slots?
              if(sides[side] == IS_SLOT) {
                //echo("add material for slots on side ", side);
                add_material_for_slot_side(side);
              }
            }
      }
    }

    for(side=[0,1,2,3]) {
      for(side=[0,1,2,3]) {
        color(colors[side])
          rotate([0,0,90*side])
            translate([0,offset_for_side(side),0]) {
              // tabs?
              if(sides[side] == IS_TAB) {
                //echo("add screw/nut slots between tabs!");
                bc_position_along_line(tab_space_for_side(side)) bc_offset_screw_nut_hole();
              }

              // slots?
              if(sides[side] == IS_SLOT) {
                //echo("add slots!");
                scale([1,1,1.05])
                  bc_position_along_line(tab_space_for_side(side)) bc_offset_tab_pair(WITH_HOLES);
              }
            }
      }
    }
  }
}
