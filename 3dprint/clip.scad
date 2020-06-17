use <utils.scad>

$fn = $preview ? 12 : 72;
e = 0.01;

// Space between details.
// SLA is more precise than FDM, 0.2mm shoudl be ok.
gap = 0.2;

module bottom() {
    h = 4;
    len = 60;
    w1 = 16;
    w2 = 20;
    l2 = 10;

    // long part
    difference () {
        translate_x(len/2) rcube([len, w1, h], r=4, rbottom=1);

        // spring holder
        translate([11, 0, h-1.3])
        difference() {
            cylinder(10, d=6.5);
            cylinder(30, d=2.5, center=true);
        }
    }

    // head
    translate_x(len)
    hull() {
        translate_x(-l2/2) rcube([l2, w2, h], r=1.5, rbottom=1);
        translate_x(-l2/2-14) rcube([2, 2, h], r=1.5, rbottom=1);
    }

    // bridge
    translate_x(35)
    difference() {
        translate([0, 6/2, 19/2]) rotate_x(90) rcube([12, 19, 6], r=1.5);
        translate_z(16) rotate_x(90) cylinder(10, d=2, center=true);
    }
}

module top() {
    h = 6;
    len = 48.5;
    w = 16;
    r1 = 5;
    r2 = 1.5;
    difference () {
        union() {
            translate_x(len/2) rcube([len, w, h], r=4, rbottom=1);
            translate_x(len-5/2) rcube([5, w, h], r=1);
        }

        // spring holder
        translate([10, 0, h-2]) cylinder(10, d=6.5);

        // PCB holes
        translate([len-2.5, 4, 0]) cylinder(100, d=2, center=true);
        translate([len-2.5, -4, 0]) cylinder(100, d=2, center=true);

        // bridge hole
        bhv = 14;
        translate([35, 0, 0]) {
            cube([bhv, 6+gap, 20], center=true);

            translate([bhv/2, (6+gap)/2, 0])
            rotate([90,0,0]) qfillet(6+gap, 1);

            translate([bhv/2, (6+gap)/2, 6])
            rotate([90,90,0]) qfillet(6+gap, 1);

            translate([-bhv/2, (6+gap)/2, 0])
            rotate([90,-90,0]) qfillet(6+gap, 1);

            translate([-bhv/2, (6+gap)/2, 6])
            rotate([90,180,0]) qfillet(6+gap, 3);
        }

        // bridge shaft
        translate([35, 0, h/2])
        rotate_x(90) cylinder(100, d=2, center=true);

        // bridge nuts
        translate([35, w/2+e, h/2])
        rotate_x(90) cylinder_outer(2, 4.15/2, 6);

        mirror([0, 1, 0])
        translate([35, w/2+e, h/2])
        rotate_x(90) cylinder_outer(2, 4.15/2, 6);

    }
}

module bottom_tc2030() {
    difference() {
        bottom();

        translate([60, 2+0.5, -e])
        rcube([14,1,20], center=true, r=0.3);
        translate([60, 3, 0]) rotate_z(90) qfillet(10, 0.3);
        translate([60, 2, 0]) rotate_z(180) qfillet(10, 0.3);

        mirror([0, 1, 0]) {
            translate([60, 2+0.5, -e])
            rcube([14,1,20], center=true, r=0.3);
            translate([60, 3, 0]) rotate_z(90) qfillet(10, 0.3);
            translate([60, 2, 0]) rotate_z(180) qfillet(10, 0.3);
        }
    }
}

if (!is_undef(mode) && mode == 1) top();
else if (!is_undef(mode) && mode == 2) bottom();
else if (!is_undef(mode) && mode == 3) bottom_tc2030();
else {
    bottom();
    translate([0, 25, 0]) top();
    translate([0, -25, 0]) top();
    translate([0, -50, 0]) bottom_tc2030();
}
