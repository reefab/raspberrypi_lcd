DRAW_TOP                = false;
DRAW_BOTTOM             = false;

clearance               = 0.2;

pcb_length              = 122;
pcb_width               = 78;
pcb_thickness           = 1.5;
pcb_bottom_clearance    = 8.5;
components_clearance    = 20.5;

headphone_hole_offset_x = 32.5;
headphone_hole_offset_z = 15;
headphone_hole_dia      = 7;

screen_offset_x         = 6;
screen_offset_y         = 8;
screen_length           = 110;
screen_width            = 68;
screen_frame_length     = 120;
screen_frame_width      = 76.5;
screen_frame_thickness  = 6.5;

rj45_width              = 17;
rj45_height             = 14.5;
rj45_offset_y           = 60;
rj45_offset_z           = 18;

usb_width               = 14.5;
usb_height              = 15.5;
usb_offset_y            = 42;
usb_offset_z            = 18;

second_usb_offset_y     = 24.5;

hdmi_width              = 16.5;
hdmi_height             = 15;
hdmi_offset_x           = 45;
hdmi_offset_z           = 17;

microusb_offset_x       = 68.5;
microusb_offset_z       = 7;
microusb_width          = 13;
microusb_height         = 7;

blind_microusb_offset_x = 69;
blind_microusb_offset_z = 19.5;
blind_microusb_width    = 12;
blind_microusb_height   = 6;

switch_offset_y         = 10;
switch_offset_z         = 10;
switch_width            = 10;
switch_height           = 5;

wall_thickness          = 1;
side_wall_thickness     = 4;
pcb_shelf_width         = 1;
total_height            = pcb_thickness + pcb_bottom_clearance + components_clearance;
top_case_height         = 22;

foot_holes_dia          = 3;
foot_holes_spacing      = 40;

m3_sh_head_dia          = 5.4;
m3_sh_head_thickness    = 3;
m3_nut_witdh            = 5.4;
m3_nut_thickness        = 2.4;

module raspberry_plus_screen() {
    translate([0, 0, pcb_thickness + components_clearance]) {
        translate([0, 0, -pcb_thickness])
             cube([pcb_length, pcb_width, pcb_thickness]);
        translate([0, 0, -pcb_thickness - components_clearance])
             cube([pcb_length, pcb_width, components_clearance]);
        translate([1, 1, 0])
             cube([screen_frame_length, screen_frame_width, screen_frame_thickness]);
        translate([screen_offset_x, screen_offset_y, screen_frame_thickness])
            cube([screen_length, screen_width, wall_thickness +1]);
        translate([-5, rj45_offset_y, -rj45_offset_z])
            cube([5, rj45_width, rj45_height]);
        translate([-5, usb_offset_y, -usb_offset_z])
            cube([5, usb_width, usb_height]);
        translate([-5, second_usb_offset_y, -usb_offset_z])
            cube([5, usb_width, usb_height]);
        translate([-6, second_usb_offset_y, -usb_offset_z])
            cube([5, rj45_offset_y - second_usb_offset_y, usb_height]);
        translate([headphone_hole_offset_x, pcb_width, -headphone_hole_offset_z])
            rotate([-90, 0, 0]) cylinder(d=headphone_hole_dia, h=5, $fn=20);
        translate([headphone_hole_offset_x, pcb_width + 1, -headphone_hole_offset_z])
            rotate([-90, 0, 0]) cylinder(d=10, h=5, $fn=20);
        translate([hdmi_offset_x, pcb_width, -hdmi_offset_z])
            cube([hdmi_width, 5, hdmi_height]);
        translate([microusb_offset_x, pcb_width, -microusb_offset_z])
            cube([microusb_width, 5, microusb_height]);
        translate([blind_microusb_offset_x, pcb_width, -blind_microusb_offset_z])
            cube([blind_microusb_width, 1, blind_microusb_height]);
        translate([pcb_length, switch_offset_y, -switch_offset_z])
            cube([5, switch_width, switch_height]);
    }
}

module roundrect(size, radius = 1) {
    x = size[0];
    y = size[1];
    z = size[2];

    translate([x/2, y/2, 0]) linear_extrude(height=z)
        hull() {
            translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0])
                circle(r=radius, $fn=50);

            translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0])
                circle(r=radius, $fn=50);

            translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0])
                circle(r=radius, $fn=50);

            translate([(x/2)-(radius/2), (y/2)-(radius/2), 0])
                circle(r=radius, $fn=50);
        }
}

module case() {
    difference() {
        union() {
            translate([0, 0, -wall_thickness])
                roundrect([pcb_length + side_wall_thickness * 2,
                           pcb_width + side_wall_thickness * 2,
                           total_height], wall_thickness);
        }
        translate([side_wall_thickness, side_wall_thickness, 0]) raspberry_plus_screen();
        for(i=[side_wall_thickness/2, pcb_length + side_wall_thickness*1.5])
            for(j=[side_wall_thickness/2, pcb_width + side_wall_thickness*1.5])
                translate([i, j, -wall_thickness]) {
                     cylinder(d=3 + clearance, h=total_height, $fn=50);
                     cylinder(r = (m3_nut_witdh + clearance/2) / 2 / cos(180 / 6) + 0.05, h=m3_nut_thickness, $fn=6);
                     translate([0, 0, total_height - m3_sh_head_thickness])
                         cylinder(d=m3_sh_head_dia + clearance, h=m3_sh_head_thickness, $fn=50);
                }
        for(i=[-1, 1])
            translate([(pcb_length + side_wall_thickness)/2 + i * foot_holes_spacing/2, side_wall_thickness, total_height/2])
                 rotate([90, 0, 0]) cylinder(d=foot_holes_dia + clearance, h=15, $fn=20);
    }
}

module top_case() {
    difference() {
        case();
        translate([-10, -10, -wall_thickness])
            cube([300, 300, total_height - top_case_height]);
    }
}

module bottom_case() {
    difference() {
        case();
        translate([-10, -10, total_height - top_case_height])
            cube([300, 300, total_height]);
    }
}

if(DRAW_TOP == true)
    translate([0, -10, total_height - wall_thickness])
        rotate([180, 0, 0]) top_case();
if(DRAW_BOTTOM == true)
    translate([0, 10, wall_thickness]) bottom_case();
if(DRAW_TOP == false && DRAW_BOTTOM == false)
    /* raspberry_plus_screen(); */
    case();
