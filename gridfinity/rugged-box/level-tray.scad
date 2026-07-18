/*
 * Gridfinity Rugged Box Level Tray
 *
 * A removable tray ("level") for the Gridfinity Rugged Box. The top face is
 * a Gridfinity baseplate matching the box floor; the underside has
 * Gridfinity bases, so the tray registers either on the box floor or on a
 * layer of equal-height bins below (adjacent equal-height bins compose into
 * a baseplate).
 *
 * Two fold-flat pull bails are recessed into deepened wells at two edge
 * cells. Folded, each bail rests below the plane of a seated bin's base, so
 * every cell stays usable. To lift the tray out, remove the two bins over
 * the wells, flip the bails up, and pull.
 *
 * Fully printed: each bail pivots on a printed 3mm axle pin inserted
 * through a channel from the nearest tray edge face. Inside the box, the
 * box wall blocks the axle from backing out.
 *
 * Licensed under Creative Commons (4.0 International License)
 * Attribution-ShareAlike
 */

include <gridfinity-rebuilt-openscad/standard.scad>;
use <gridfinity-rebuilt-openscad/gridfinity-rebuilt-baseplate.scad>;

/* [Rendering] */
Part = "assembled"; // [tray: Tray, pull_bail: Pull bail, axle_pin: Axle pin, assembled: Assembled preview]

/* [Dimensions] */
// Tray size in 42mm Gridfinity units, side-to-side (match the box Width)
Width = 5; // [1:1:10]

// Tray size in 42mm Gridfinity units, front-to-back (match the box Length)
Length = 5; // [1:1:10]

/* [Features] */
// Recessed pull bails for lifting the tray out
Pull_Bails = true;

/* [Advanced Size Adjustments] */
// Interior border of the rugged box beyond the grid, in millimeters
Case_Border = 5;

// Size subtracted from the tray outline for fit inside the box
Fit_Clearance = 0.6;

module __end_customizer_options__() { }

// Constants

$fa = $preview ? $fa : 2;
$fs = $preview ? $fs / 2 : 0.25;

// Total tray thickness: feet (h_base) + body above
feet_height = h_base;
body_height = 7;
socket_floor_z = feet_height + 2;

// Relief pockets under each socket so bin base tips can pass the socket
// floor and the bases seat on the tapered profile (open on real minimal
// baseplates, which have no floor)
tip_relief_size = 38;
tip_relief_depth = 0.9;
// Bin base tip plane when seated: h_base below the plate ridge top; the
// ridge top is the baseplate profile height above the socket floor
plate_profile_height = 4.4;
tray_top_z = socket_floor_z + plate_profile_height;
seat_z = tray_top_z - h_base;

// Pull bail sizing (all printed, no hardware)
bail_thickness = 4.4;
bail_arm_width = 6;
bail_arm_length = 25;
bail_grip_width = 8;
bail_total_width = 30;
bail_fit = 0.3;
// Highest point of the folded bail below the seated bin base tip plane
bail_stow_clearance = 0.25;

axle_diameter = 3;
axle_hole_diameter = 3.3;
axle_cap_diameter = 5.6;
axle_cap_thickness = 1.8;

well_size = 34;
well_corner_radius = 3;
// Upper portion of the socket taper preserved above the well
well_taper_keep = 2.5;

// Derived values

tray_width = Width * l_grid + Case_Border - Fit_Clearance;
tray_length = Length * l_grid + Case_Border - Fit_Clearance;
corner_radius = r_base;

bail_stow_top_z = seat_z - bail_stow_clearance;
bail_axis_z = bail_stow_top_z - bail_thickness / 2;
well_floor_z = bail_axis_z - bail_thickness / 2 - 0.25;
// Pivot axis runs along X (toward the near tray edge), offset in Y within
// the well; the bail folds toward +Y
bail_axis_y = -(well_size / 2 - bail_thickness / 2 - 1.5);

// Well cell positions: centers of the two outermost columns (one well
// for single-column trays)
function well_cells() = (
    let (mid = floor(Length / 2))
    Width == 1 ? [[0, mid]] : [[0, mid], [Width - 1, mid]]
);

function cell_center(cell) = [
    (cell[0] - Width / 2 + 0.5) * l_grid,
    (cell[1] - Length / 2 + 0.5) * l_grid
];

function well_outward(cell) = (
    Width == 1 ? -1 : (cell[0] == 0 ? -1 : 1)
);

module tray_bom() {
    if (Pull_Bails) {
        echo(str(
            "Level tray parts: 1 tray, ", len(well_cells()), " pull bails, ",
            len(well_cells()), " axle pins (all printed, no hardware)"
        ));
        echo(str(
            "Level tray: raised bail grip stands ~",
            bail_arm_length + bail_grip_width / 2 - (tray_top_z - bail_axis_z),
            " mm above the tray surface"
        ));
    }
}

// Modules

module tray_outline_shape(expand=0) {
    offset(r=corner_radius + expand)
    square(
        [tray_width - corner_radius * 2, tray_length - corner_radius * 2],
        center=true
    );
}

module tray_body() {
    // Small bottom chamfer eases entry into the box
    hull() {
        translate([0, 0, feet_height + 1])
        linear_extrude(height=body_height - 1)
        tray_outline_shape();
        translate([0, 0, feet_height])
        linear_extrude(height=1)
        offset(delta=-1)
        tray_outline_shape();
    }
}

// One simplified tapered foot: a frustum that seats on the socket chamfers
// like a Gridfinity base. Built from plain primitives so the booleans stay
// clean. The tip stops short of the socket floor; seating happens on the
// chamfer, as with regular bins.
module tray_foot() {
    foot_tip_gap = 0.4;
    hull() {
        translate([0, 0, foot_tip_gap])
        linear_extrude(height=0.01)
        offset(r=3) square(35 - 6, center=true);
        translate([0, 0, feet_height - 0.01])
        linear_extrude(height=0.01)
        offset(r=5) square(41 - 10, center=true);
    }
}

module tray_feet() {
    for (ix = [0:1:Width - 1], iy = [0:1:Length - 1]) {
        translate(concat(cell_center([ix, iy]), [0]))
        tray_foot();
    }
}

// Axle channel backing tabs out to the tray edge under the rim
module tray_well_feet() {
    for (cell = well_cells()) {
        center = cell_center(cell);
        outward = well_outward(cell);
        intersection() {
            translate([
                center[0] + outward * l_grid / 2,
                center[1] + bail_axis_y,
                feet_height / 2 + 0.2
            ])
            cube([l_grid, 12, feet_height - 0.4], center=true);
            linear_extrude(height=feet_height + 0.01)
            tray_outline_shape();
        }
    }
}

// Material to remove so the tray top matches the box floor baseplate
module tray_plate_cut() {
    // The cut is limited to the grid area so the rim outside the plate
    // keeps its full height as a flush deck ring
    render(convexity=4)
    difference() {
        translate([0, 0, socket_floor_z])
        linear_extrude(height=h_base * 2)
        square(
            [Width * l_grid + 0.5, Length * l_grid + 0.5],
            center=true
        );
        translate([0, 0, socket_floor_z])
        gridfinityBaseplate(Width, Length, l_grid, 0, 0, 0, false, 0, 0, 0);
    }
    // Per-cell tip relief below the socket floor
    for (ix = [0:1:Width - 1], iy = [0:1:Length - 1]) {
        translate(concat(cell_center([ix, iy]), [0]))
        translate([0, 0, socket_floor_z - tip_relief_depth])
        linear_extrude(height=tip_relief_depth + 0.01)
        offset(r=well_corner_radius)
        offset(r=-well_corner_radius)
        square(tip_relief_size, center=true);
    }
}

module bail_well_cavity() {
    translate([0, 0, well_floor_z])
    linear_extrude(
        height=socket_floor_z + well_taper_keep - well_floor_z
    )
    offset(r=well_corner_radius)
    offset(r=-well_corner_radius)
    square(well_size, center=true);
}

// Axle channel from the near tray edge face through the well, in tray
// coordinates for the given well cell
module axle_channel(cell) {
    center = cell_center(cell);
    outward = well_outward(cell);
    edge_x = outward * (tray_width / 2);
    inner_x = center[0] - outward * (well_size / 2 + 2);
    translate([edge_x, center[1] + bail_axis_y, bail_axis_z])
    rotate([0, outward * -90, 0]) {
        cylinder(
            h=abs(edge_x - inner_x) + 0.01,
            d=axle_hole_diameter
        );
        // Counterbore for the axle cap, recessed into the edge face
        translate([0, 0, -0.01])
        cylinder(h=axle_cap_thickness + 0.3, d=axle_cap_diameter + 0.4);
    }
}

module tray_wells_cut() {
    for (cell = well_cells()) {
        translate(concat(cell_center(cell), [0]))
        bail_well_cavity();
        axle_channel(cell);
    }
}

// The pull bail: pivot axis along X at the origin, folding toward +Y.
// Printed flat; uniform thickness with a flat underside.
module bail_part() {
    color("mintcream", 0.8)
    render(convexity=4)
    difference() {
        translate([0, 0, -bail_thickness / 2])
        linear_extrude(height=bail_thickness)
        offset(r=1.5) offset(r=-1.5)
        union() {
            for (mx = [0:1:1])
            mirror([mx, 0, 0])
            translate([bail_total_width / 2 - bail_arm_width, 0]) {
                // Arm
                translate([0, -bail_thickness / 2])
                square([bail_arm_width, bail_arm_length + bail_thickness / 2]);
                // Rounded pivot end
                translate([bail_arm_width / 2, 0])
                circle(d=bail_thickness);
            }
            // Grip bar
            translate([
                -bail_total_width / 2,
                bail_arm_length - bail_grip_width / 2
            ])
            square([bail_total_width, bail_grip_width]);
        }
        // Axle hole
        rotate([0, 90, 0])
        cylinder(
            h=bail_total_width * 2,
            d=axle_hole_diameter + 0.2,
            center=true
        );
    }
}

module axle_part() {
    // Axle spans from the edge face counterbore to just short of the
    // channel's blind end (2mm past the well's inner wall)
    length = (
        tray_width / 2
        - ((Width - 1) * l_grid / 2 - well_size / 2 - 2)
        - 0.3
    );
    color("mintcream", 0.8)
    union() {
        cylinder(h=length, d=axle_diameter);
        cylinder(h=axle_cap_thickness, d=axle_cap_diameter);
    }
}

module tray() {
    color("SteelBlue", 0.8)
    render(convexity=4)
    difference() {
        union() {
            tray_body();
            tray_feet();
            if (Pull_Bails) tray_well_feet();
        }
        tray_plate_cut();
        if (Pull_Bails) tray_wells_cut();
    }
    tray_bom();
}

module bails_placed() {
    if (Pull_Bails)
    for (cell = well_cells()) {
        translate(concat(cell_center(cell), [0]))
        translate([0, bail_axis_y, bail_axis_z])
        rotate([$preview ? 75 : 0, 0, 0])
        bail_part();
        // Axle pins
        center = cell_center(cell);
        outward = well_outward(cell);
        translate([
            outward * (tray_width / 2 - 0.4),
            center[1] + bail_axis_y,
            bail_axis_z
        ])
        rotate([0, outward * -90, 0])
        axle_part();
    }
}

module main() {
    if (Part == "tray") {
        tray();
    } else if (Part == "pull_bail") {
        translate([0, 0, bail_thickness / 2])
        bail_part();
    } else if (Part == "axle_pin") {
        axle_part();
    } else if (Part == "assembled") {
        tray();
        bails_placed();
    }
}

main();
