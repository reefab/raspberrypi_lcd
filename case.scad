clearance               = 0.2;

pcb_length              = 122;
pcb_width               = 78;
pcb_thickness           = 1.5;
pcb_bottom_clearance    = 8.5;
components_clearance    = 20.5;

headphone_hole_offset_x = 32.5;
headphone_hole_offset_z = 16;
headphone_hole_dia      = 6;

screen_offset_x         = 6;
screen_offset_y         = 8;
screen_length           = 110;
screen_width            = 68;
screen_frame_length     = 120;
screen_frame_width      = 76.5;
screen_frame_thickness  = 8;

rj45_width              = 16;
rj45_height             = 13.5;
rj45_offset_y           = 60;
rj45_offset_z           = 17.5;

usb_width               = 13.5;
usb_height              = 14.5;
usb_offset_y            = 42;
usb_offset_z            = 17;

hdmi_width              = 15.5;
hdmi_height             = 15;
hdmi_offset_x           = 46;
hdmi_offset_z           = 17;

microusb_offset_x       = 67;
microusb_offset_z       = 5;
microusb_width          = 12;
microUsb_height         = 6;

second_usb_offset_y     = 24.5;

wall_thickness          = 2;
pcb_shelf_width         = 1;

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
        translate([headphone_hole_offset_x, pcb_width, -headphone_hole_offset_z])
            rotate([-90, 0, 0]) cylinder(d=headphone_hole_dia, h=5);
        translate([hdmi_offset_x, pcb_width, -hdmi_offset_z])
            cube([hdmi_width, 5, hdmi_height]);
        translate([microusb_offset_x, pcb_width, -microusb_offset_z])
            cube([microusb_width, 5, microUsb_height]);
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
        roundrect([pcb_length + wall_thickness * 2,
                   pcb_width + wall_thickness * 2,
                   pcb_thickness + components_clearance +
                   pcb_bottom_clearance + wall_thickness],
                   wall_thickness);
        translate([wall_thickness, wall_thickness, wall_thickness]) raspberry_plus_screen();
    }
    for(i=[wall_thickness, pcb_length + pcb_shelf_width])
        translate([i, wall_thickness, wall_thickness])
            cube([pcb_shelf_width, pcb_width, pcb_bottom_clearance]);
}

module lid() {
    difference() {
        roundrect([pcb_length + wall_thickness * 2,
                   pcb_width + wall_thickness * 2,
                   wall_thickness], wall_thickness);
        translate([wall_thickness, wall_thickness, 0])
            cube([pcb_length, pcb_width, wall_thickness + 1]);
    }
}

/* case(); */
raspberry_plus_screen();

/* translate([0, -50, 0]) lid(); */
