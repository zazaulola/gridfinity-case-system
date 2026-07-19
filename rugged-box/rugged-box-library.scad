/*
 * Customizable and Parametric Rugged Storage Box
 * By smkent (GitHub) / bulbasaur0 (Printables)
 *
 * Rugged storage box library
 *
 * Licensed under Creative Commons (4.0 International License) Attribution-ShareAlike
 */

module __end_customizer_options__() { }

// Constants

$fa = $preview ? $fa : 2;
$fs = $preview ? $fs / 2 : 0.2;

// Attachment screw diameter
screw_diameter = 3; // M3

// Decrease screw hole diameter just slightly for better thread-forming fit
screw_hole_diameter_size_tolerance = -0.1;

// Hex nut pocket fit added to the nut width across flats
nut_pocket_width_tolerance = 0.35;
// Extra pocket depth beyond the nut height
nut_pocket_depth_tolerance = 0.4;

// Axle sleeve outer diameter: a printed (or brass standoff) bearing sleeve
// spanning between the attachment ribs. Rotating parts ride the smooth
// sleeve surface, and the sleeve is retained by two short screws driven
// into its bore from the rib outer faces, replacing the long through screw
axle_sleeve_diameter = 8;
// Diametral running fit for parts rotating on the sleeve
axle_sleeve_fit = 0.4;
// Snug fit for latch catch slots hooking over the sleeve
axle_sleeve_catch_fit = 0.2;

// Widen angle of box plain ribs
plain_ribs_angle = 8;

// Extra space between box body and hinge for clearance
hinge_extra_setback = 0.2; // [0:0.1:2]
hinge_size_tolerance = 0.1;

// Box top hinge screw eyelet position fit tolerance adjustment
top_hinge_eyelet_position_tolerance = 0.1;

// Screw eyelet diameter as a proportion of screw diameter
screw_eyelet_size_proportion = 3.0; // [1.5:0.1:5]

// Depth and maximum width of lip grip
top_grip_depth = 6;
top_grip_width = 100;

// Latch size
latch_edge_radius = 0.8;
latch_body_size_proportion = 3.0; // [1.5:0.1:5]

// Stacking latch size
stacking_latch_catch_offset = -10;
stacking_latch_grip_length = 8;
stacking_latch_screw_separation = 20;

// Handle size
handle_thickness = 10;
handle_min_height = 16;
handle_max_height = 35;
handle_radius = 5;

// Lid handle size
// The lid handle pivots always use M3 screws, independent of the main
// attachment screw size, so the folded handle stays below the stacking plane
lid_handle_screw_diameter = 3;
lid_handle_screw_length = 20;
lid_handle_eyelet_size_proportion = 3.0;
// Local hole fit so overrides of the main screw_diameter (heavy-duty M4)
// cannot change the lid handle pivot fits
lid_handle_screw_hole_fit = lid_handle_screw_diameter * 0.2;
lid_handle_bar_thickness = 9;
lid_handle_bar_width = 16;
lid_handle_bar_max_length = 130;
lid_handle_bar_edge_radius = 3;
lid_handle_arm_width = 8;
lid_handle_boss_width = 6;
lid_handle_min_grip_span = 60;
// Finger space between the raised grip bar underside and the lid surface
lid_handle_grip_clearance = 32;
// Distance from the pocket to the box interior edge
lid_handle_pocket_rim = 8;
lid_handle_pocket_wall = 4;
lid_handle_pocket_corner_radius = 6;
lid_handle_floor_thickness = 3;
// Interior clearance kept below the pocket housing for bin lips
lid_handle_interior_margin = 3.5;
// Extra pocket length ahead of the folded grip bar for finger access
lid_handle_finger_room = 8;
// Slope inset of the finger scoop wall between pocket opening and floor
lid_handle_scoop_inset = 6;
lid_handle_swing_margin = 2;
lid_handle_fit = 0.4;

// Split lid handle: two point-symmetric half-bails on parallel central
// axes, folding inward past each other (arms interleaved along X) and
// rising to a self-clamping X-arch whose grip bars press together under
// load. Four pivots halve the per-pivot load; the pocket is symmetric
// and shorter than the single bail's, and the box hangs level on every
// box size.
split_handle_eyelet_radius = 4.0;
split_handle_bar_thickness = 8;
split_handle_bar_width = 8;
split_handle_arm_width = 8;
// Axis offset from the lid center
split_handle_axis_offset = 9;
// Axis-to-bar-center arm length
split_handle_arm_length = 34;
// Inboard shift of each half's inner arm, creating the interleave slots
split_handle_arm_slot = 11;
split_handle_boss_width = 5;
split_handle_screw_length = 20;

// Label size
label_thickness = 2;
label_fit_thickness = 0.1;
label_text_thickness = 2.0;
label_holder_inset = 5;
label_holder_lip = 2;
label_holder_thickness = 2 + label_thickness + label_fit_thickness;
label_max_height = 30;

// Public modules

/*
 * Setup module
 *
 * Use this module to configure box sizing and features before rendering a part
 *
 * Arguments:
 *  - width: Interior side-to-side size
 *  - length: Interior front-to-back size
 *  - top_height: Interior top height
 *  - bottom_height: Interior bottom height
 *  - corner_radius: Interior corner radius (Reduces interior storage space)
 *  - edge_chamfer_proportion: Proportion of corner_radius to chamfer outer
 *    top/bottom edges (Reduces interior storage space)
 *  - lip_seal_type: Type of shape of seal to use, if desired:
 *      - "none": No seal
 *      - "wedge": Wedge-shaped seal
 *      - "square": Square-shaped seal
 *      - "filament-1.75mm": Seal cutout on both top and bottom for
 *          1.75mm filament
 *      - "silicone": Dovetail groove in the bottom lip for silicone
 *          cord of seal_cord_diameter; the flat top lip compresses the
 *          cord by up to ~25% and the undercut retains it when open
 *  - seal_cord_diameter: Silicone cord diameter in millimeters for the
 *    "silicone" seal type
 *  - reinforced_corners: Make the corners as thick as the box lip
 *  - latch_type: Style of front latches: "clip" or "draw"
 *  - latch_count: Number of latches (1 or 2). The default of 0 determines the
 *    number of latches automatically.
 *  - top_grip: Add optional grip to front of box top
 *  - hinge_end_stops: Add optional hinge end stops to box bottom hinges
 *  - handle: Add optional handle for sufficiently wide boxes
 *  - nut_pockets: Cut hex nut pockets into the outward faces of the
 *    attachment ribs and enlarge all attachment screw holes to clearance
 *    fit. Screws then clamp with nuts instead of thread-forming into the
 *    plastic: no thread wear, no screw rotation in use, and cut threaded
 *    rod can substitute for screws.
 *  - axle_sleeves: Replace every long through screw with a printed
 *    bearing sleeve spanning between the attachment ribs, retained by two
 *    short screws (M4x12..20) driven into the sleeve bore from the rib
 *    outer faces. Rotating parts ride the smooth sleeve surface instead
 *    of screw threads. Latch, stacking latch, hinge, and handle bores
 *    grow to the sleeve diameter. Requires M4 attachment sizing.
 *  - lid_handle: Add optional fold-flat carry handle recessed into the
 *    center of the box top for sufficiently large boxes
 *  - lid_handle_style: "bail" for a single fold-flat bail, or "split" for
 *    two point-symmetric half-bails on parallel central axes that fold
 *    inward past each other and rise to a self-clamping X-arch. The split
 *    style has a shorter symmetric pocket, four pivots sharing the load,
 *    and hangs level on every box size.
 *  - lid_handle_stow_depth: Depth below the box top outer surface at which
 *    the highest point of the folded lid handle rests. Set this deeper than
 *    any exterior stacking features so stacked boxes clear the folded handle.
 *  - label: Add optional label for sufficiently wide boxes
 *  - label_text: Custom text for optional label
 *  - label_text_size: Approximate label text size in millimeters
 *
 * Example:
 *
 *      box(width=100, length=50, top_height=15, bottom_height=30) {
 *          // Render box top
 *          translate([120, 0, 0])
 *          rbox_top();
 *
 *          // Render box bottom
 *          rbox_bottom();
 *      }
 */
module rbox(
    width,
    length,
    bottom_height=0,
    top_height=0,
    corner_radius=5,
    edge_chamfer_proportion=0.4,
    lip_seal_type="wedge",
    seal_cord_diameter=3.0,
    reinforced_corners=false,
    latch_type="draw",
    latch_count=0,
    top_grip=false,
    hinge_end_stops=false,
    handle=false,
    nut_pockets=false,
    axle_sleeves=false,
    lid_handle=false,
    lid_handle_style="bail",
    lid_handle_stow_depth=1.0,
    label=false,
    label_text="",
    label_text_size=10
) {
    // Set base dimensions
    $b_inner_width = width;
    $b_inner_length = length;
    $b_top_inner_height = top_height;
    $b_bottom_inner_height = bottom_height;
    $b_corner_radius = corner_radius;
    $b_edge_chamfer_proportion = edge_chamfer_proportion;
    $b_lip_seal_type = lip_seal_type;
    $b_seal_cord_diameter = seal_cord_diameter;
    $b_reinforced_corners = reinforced_corners;
    $b_latch_type = latch_type;
    $b_latch_count = latch_count;
    $b_top_grip = top_grip;
    assert(
        !axle_sleeves || screw_diameter >= 4,
        str(
            "Axle sleeves require M4 attachment sizing (screw_diameter ",
            screw_diameter, " is too small for the latch bores)"
        )
    );
    $b_hinge_end_stops = hinge_end_stops;
    $b_handle = handle;
    $b_nut_pockets = nut_pockets;
    $b_axle_sleeves = axle_sleeves;
    $b_lid_handle = lid_handle;
    $b_lid_handle_style = lid_handle_style;
    $b_lid_handle_stow_depth = lid_handle_stow_depth;
    $b_label = label;
    $b_label_text = label_text;
    $b_label_text_size = label_text_size;
    // Set defaults
    $b_preview_assembled = false;
    $b_preview_box_open = false;
    rbox_size_adjustments()
    _box_rib_angle(0)
    // Render modules
    children();
}

/*
 * Advanced size adjustments setup module
 *
 * Use this module to configure advanced box sizing adjustments before rendering a part
 *
 * Arguments:
 *  - wall_thickness: Base wall thickness for most of the box
 *  - lip_thickness: Thickness to add to the wall thickness for the box lip
 *  - rib_width: Base thickness of the support ribs. The latch ribs are this
 *    thick, while the hinge and side ribs are twice this thick.
 *  - latch_width: Latch side-to-side width
 *  - latch_screw_separation: Distance between the latch hinge and catch screws
 *    which determines the latch vertical size
 *  - latch_amount_on_top: Vertical size of the latch measured from the latch
 *    hinge screw hole overlapping the top of the box, with the remainder
 *    overlapping the bottom. Set to 0 to determine automatically.
 *  - third_hinge_width: Add a third, center hinge if the box's interior is at
 *    least as wide as this value. Set to 0 to disable (default).
 *  - stacking_separation: The vertical distance between two stacked boxes.
 *    Used for stacking latch attachment placement.
 *  - size_tolerance: Size subtracted from latch and upper hinge widths for fit
 *
 * Example:
 *
 *      box(width=100, length=50, top_height=15, bottom_height=30) {
 *          rbox_size_adjustments(wall_thickness=3.0, lip_thickness=3.0) {
 *              // Render box top
 *              translate([120, 0, 0])
 *              rbox_top();
 *
 *              // Render box bottom
 *              rbox_bottom();
 *          }
 *      }
 */
module rbox_size_adjustments(
    wall_thickness=2.4,
    lip_thickness=2.0,
    rib_width=4.0,
    latch_width=22,
    latch_screw_separation=20,
    latch_amount_on_top=0,
    third_hinge_width=0,
    stacking_separation=0,
    size_tolerance=0.05
) {
    $b_wall_thickness = wall_thickness;
    $b_lip_thickness = lip_thickness;
    $b_rib_width = rib_width;
    $b_size_tolerance = size_tolerance;
    $b_latch_width = latch_width;
    $b_latch_screw_separation = latch_screw_separation;
    $b_latch_amount_on_top = _init_latch_amount_on_top(latch_amount_on_top);
    $b_third_hinge_width = third_hinge_width;
    $b_stacking_separation = stacking_separation;
    // Set computed values
    $b_total_lip_thickness = wall_thickness + lip_thickness;
    $b_lip_height = lip_thickness * 2;
    $b_edge_radius = wall_thickness / 5;
    // Set dependent values
    $b_top_outer_height = $b_top_inner_height + wall_thickness;
    $b_bottom_outer_height = $b_bottom_inner_height + wall_thickness;
    $b_outer_width = $b_inner_width + $b_total_lip_thickness * 2;
    $b_outer_length = $b_inner_length + $b_total_lip_thickness * 2;
    $b_curved_inner_width = $b_inner_width + $b_edge_radius * 2;
    $b_curved_inner_length = $b_inner_length + $b_edge_radius * 2;
    $b_outer_chamfer_horizontal = $b_edge_chamfer_proportion * $b_corner_radius;
    $b_outer_chamfer_vertical = $b_outer_chamfer_horizontal * 1.5;
    $b_hinge_screw_offset = _attachment_screw_offset();
    $b_latch_screw_offset = _attachment_screw_offset();
    children();
}

// Part modules

module rbox_top() { _box_part_setup("top") { rbox_body(); children(); } }
module rbox_bottom() { _box_part_setup("bottom") { rbox_body(); children(); } }

module rbox_for_top() { _box_part_setup("top") children(); }
module rbox_for_bottom() { _box_part_setup("bottom") children(); }

module rbox_for_interior() { translate([0, 0, $b_wall_thickness]) children(); }

module rbox_latch(placement="print") { _latch(placement); }

module rbox_stacking_latch(placement="print") { _stacking_latch(placement); }

module rbox_handle(placement="print") { _handle(placement); }

module rbox_lid_handle(placement="print") { _lid_handle(placement); }

// The full set of axle sleeves for the configured box, standing for print
module rbox_axle_sleeves() {
    rbox_for_bottom() {
        latch_count = _compute_latch_count();
        hinge_count = latch_count + (
            (
                $b_third_hinge_width > 0
                && $b_inner_width >= $b_third_hinge_width
            ) ? 1 : 0
        );
        stacking_count = len(rb_stacking_latch_positions()) * 2 * (
            2 + (_stacking_latches_enabled() ? 1 : 0)
        );
        latch_sleeves = latch_count * 2 + stacking_count;
        hinge_length = $b_latch_width - $b_rib_width * 2 - 0.4;
        latch_length = $b_latch_width - 0.4;
        color("mintcream", 0.8)
        for (i = [0:1:hinge_count + latch_sleeves - 1]) {
            translate([
                (i % 5) * (axle_sleeve_diameter + 4),
                floor(i / 5) * (axle_sleeve_diameter + 4),
                0
            ])
            _axle_sleeve(i < hinge_count ? hinge_length : latch_length);
        }
        echo(str(
            "Axle sleeve set: ", hinge_count, " hinge sleeves x ",
            hinge_length, " mm and ", latch_sleeves,
            " latch/stacking sleeves x ", latch_length, " mm"
        ));
    }
}

// Cavity to subtract for the lid handle pocket. Renders nothing if the lid
// handle is disabled or unavailable. Subtract this from any custom top body
// additions (such as exterior stacking plates) placed over the pocket area.
module rbox_lid_handle_pocket_cavity() {
    if (_lid_handle_enabled() && $b_part == "top") {
        render(convexity=4)
        union() {
            difference() {
                _lid_handle_pocket_cavity_raw();
                _lid_handle_bosses(expand=0.01);
            }
            // Included here so the pivot screw holes stay open through any
            // material added over the pocket area (such as the interior
            // grid) that survives inside the boss volumes
            _lid_handle_screw_holes();
        }
    }
}

// Keep-out volume protecting the lid handle pivot bosses. Subtract this from
// any cut volumes (such as exterior stacking plate cuts) applied to the box
// top so the pivot bosses are not carved away.
module rbox_lid_handle_plate_keepout() {
    if (_lid_handle_enabled() && $b_part == "top") {
        _lid_handle_bosses(expand=0.5);
    }
}

module rbox_label(placement="print") {
    rbox_for_bottom() {
        _box_label(placement);
    }
}

module rbox_body() {
    _box_color()
    _box_body();
}

module rbox_top_modifier_volume() { _box_part_setup("top") { rbox_body_modifier_volume(); } }
module rbox_bottom_modifier_volume() { _box_part_setup("bottom") { rbox_body_modifier_volume(); } }

module rbox_body_modifier_volume() {
    _box_color()
    _box_body_modifier_volume();
}

module rbox_interior(cut_height=0) {
    _box_color()
    render(convexity=4) {
        _box_extrude()
        _box_interior_shape(cut_height);
        rbox_for_interior()
        _box_center_base($b_inner_height);
    }
}

module rbox_part(part) {
    module _place_apart(x_amount) {
        for (ch = [0:1:1]) {
            mirror([ch, 0, 0])
            translate([x_amount, 0, 0])
            children(ch);
        }
    }

    if (part == "side-by-side") {
        _place_apart($b_inner_width / 2 + $b_wall_thickness * 8) {
            if ($children > 0) { rbox_for_bottom() children(0); } else { rbox_bottom(); };
            if ($children > 1) { rbox_for_top() children(1); } else { rbox_top(); };
        }
        rbox_bom();
    } else if (part == "assembled_open") {
        $b_preview_assembled = true;
        $b_preview_box_open = true;
        if ($children > 0) { rbox_for_bottom() children(0); } else { rbox_bottom(); };
        rbox_for_bottom() {
            rbox_handle(placement="box-preview-open");
            if (_stacking_latches_enabled())
            _box_stacking_latch_ribs_placement()
            translate([0, 0, stacking_latch_screw_separation * 0.5])
            translate([0, -$b_latch_screw_offset, 0])
            rotate([180, 0, 0])
            rbox_stacking_latch(placement="box-preview");
            if ($b_latch_type == "draw") {
                translate([
                    0,
                    -$b_latch_screw_offset,
                    $b_outer_height - ($b_latch_screw_separation - $b_latch_amount_on_top)
                ])
                mirror([0, 1, 0])
                _box_attachment_placement()
                rbox_latch(placement="box-preview");
            }
            if (_label_enabled())
            _box_label();
        }
        translate([
            0,
            (
                $b_inner_length / 2
                + $b_hinge_screw_offset
                + top_hinge_eyelet_position_tolerance
            ),
            $b_bottom_outer_height
        ])
        rotate([240, 0, 0])
        translate([
            0,
            -($b_inner_length / 2 + $b_hinge_screw_offset),
            $b_top_outer_height
        ])
        mirror([0, 0, 1]) {
            if ($children > 1) { rbox_for_top() children(1); } else { rbox_top(); };
            rbox_lid_handle(placement="box-preview");
            rbox_for_top() {
                if ($b_latch_type == "clip") {
                    translate([
                        0,
                        -$b_latch_screw_offset,
                        $b_outer_height - $b_latch_amount_on_top
                    ])
                    mirror([0, 1, 0])
                    _box_attachment_placement()
                    rotate([-135, 0, 0])
                    rbox_latch(placement="box-preview");
                }
            }
        }
        rbox_bom();
    } else if (part == "assembled_closed") {
        $b_preview_assembled = true;
        if ($children > 0) { rbox_for_bottom() children(0); } else { rbox_bottom(); };
        rbox_for_bottom() {
            rbox_handle(placement="box-preview");
            if (_stacking_latches_enabled())
            _box_stacking_latch_ribs_placement()
            translate([0, 0, stacking_latch_screw_separation * 0.5])
            translate([0, -$b_latch_screw_offset, 0])
            rbox_stacking_latch(placement="box-preview");
            if ($b_latch_type == "draw") {
                translate([
                    0,
                    -$b_latch_screw_offset,
                    $b_outer_height - ($b_latch_screw_separation - $b_latch_amount_on_top)
                ])
                mirror([0, 1, 0])
                _box_attachment_placement()
                rbox_latch(placement="box-preview");
            }
            if (_label_enabled())
            _box_label();
        }
        translate([0, 0, (
            $b_top_outer_height
            + $b_bottom_outer_height
            + top_hinge_eyelet_position_tolerance
        )])
        mirror([0, 0, 1]) {
            if ($children > 1) { rbox_for_top() children(1); } else { rbox_top(); };
            rbox_lid_handle(placement="box-preview");
            rbox_for_top() {
                if ($b_latch_type == "clip") {
                    translate([
                        0,
                        -$b_latch_screw_offset,
                        $b_outer_height - $b_latch_amount_on_top
                    ])
                    mirror([0, 1, 0])
                    _box_attachment_placement()
                    rbox_latch(placement="box-preview");
                }
            }
        }
        rbox_bom();
    } else if (part == "bottom") {
        if ($children > 0) { rbox_for_bottom() children(0); } else { rbox_bottom(); };
        rbox_bom();
    } else if (part == "bottom_modifier") {
        rbox_for_bottom()
        rbox_body_modifier_volume();
    } else if (part == "top") {
        if ($children > 1) { rbox_for_top() children(1); } else { rbox_top(); };
        rbox_bom();
    } else if (part == "top_modifier") {
        rbox_for_top()
        rbox_body_modifier_volume();
    } else if (part == "latch") {
        rbox_latch(placement="print");
    } else if (part == "stacking_latch") {
        rbox_stacking_latch(placement="print");
    } else if (part == "handle") {
        rbox_handle(placement="print");
    } else if (part == "lid_handle") {
        rbox_lid_handle(placement="print");
    } else if (part == "axle_sleeve") {
        rbox_axle_sleeves();
    } else if (part == "label") {
        rbox_label();
    }
}

// Echo non-printable bill of materials needed for the configured box
module rbox_bom() {
    function _sstr(count, length) = (
        str(count, " M", screw_diameter, "x", length)
    );

    module rbox_bom_impl() {
        screw_length_base = $b_latch_width + $b_rib_width * 2;
        screw_count_base = (
            // 2 for each latch, 1 for each hinge
            _compute_latch_count() * (2 + 1)
            + (
                (
                    $b_third_hinge_width > 0
                    && $b_inner_width >= $b_third_hinge_width
                ) ? 1 : 0
            )
            // stacking latches, 2 sides
            + len(rb_stacking_latch_positions()) * 2 * (
                // 2 attachment points
                2
                // Stow point if box is tall enough for a stacking latch
                + (_stacking_latches_enabled() ? 1 : 0)
            )
        );
        if ($b_axle_sleeves) {
            echo(str(
                "Axle sleeves enabled: print the axle_sleeve part set (",
                screw_count_base, " sleeves); each sleeve is retained by ",
                "two short M", screw_diameter, "x12..20 screws (",
                screw_count_base * 2, " total)",
                _handle_enabled()
                    ? str(
                        "; the handle still uses 2 long ",
                        _sstr(2, screw_length_base + $b_rib_width
                            + handle_thickness)
                    )
                    : ""
            ));
        }
        if ($b_nut_pockets) {
            echo(str(
                "Nut pockets enabled: one M", screw_diameter,
                " hex nut (DIN 934) per screw; cut M", screw_diameter,
                " threaded rod may substitute for screws"
            ));
        }
        if (!$b_axle_sleeves)
        echo(str(
            "Box total screws needed: ",
            _sstr(screw_count_base, screw_length_base),
            _handle_enabled() ? (
                str(
                    " without handle, or ",
                    _sstr(screw_count_base - 2, screw_length_base),
                    " + ",
                    _sstr(
                        2,
                        screw_length_base + $b_rib_width + handle_thickness
                    ),
                    " with handle"
                )
            ) : ""
        ));
        if ($b_lip_seal_type == "silicone") {
            seal_r = $b_corner_radius + $b_total_lip_thickness / 2;
            seal_length = (
                2 * ($b_inner_width + $b_inner_length)
                + 2 * PI * seal_r
            );
            echo(str(
                "Silicone seal cord needed: ~", ceil(seal_length + 20),
                " mm of ", $b_seal_cord_diameter,
                " mm cord (soft, 40..60 ShA)"
            ));
        }
        if (_lid_handle_enabled()) {
            echo(_lid_handle_split()
                ? str(
                    "Lid handle screws needed: 4 M",
                    lid_handle_screw_diameter, "x18..",
                    split_handle_screw_length,
                    " (split handle: two identical halves)"
                )
                : str(
                    "Lid handle screws needed: 2 M",
                    lid_handle_screw_diameter, "x", lid_handle_screw_length
                ));
        }
    }

    rbox_for_bottom()
    rbox_bom_impl();
};

// Overridable functions and modules

/*
 * Part colors
 *
 * Box colors used in the preview render
 *
 * Arguments:
 *  - part: Part being rendered. Possible values: "top", "bottom"
 *
 * Example:
 *
 *      function rb_color(part) = (part == "top" ? "yellow" : "orange");
 */
function rb_color(part) = (part == "top" ? "YellowGreen" : "OliveDrab");

// Side rib positions, by offset from center in millimeters
function rb_side_rib_positions() = [for (i = [-1/4, 1/4]) i * $b_inner_length];

// Rear rib positions, by offset from center in millimeters
function rb_rear_rib_positions() = [];

// Latch and hinge positions, by offset from center in millimeters
function rb_latch_hinge_position() = (
    ($b_inner_width - $b_corner_radius + $b_wall_thickness) / 2 - $b_latch_width
);

// Side stacking latch positions, by offset from center in millimeters
function rb_stacking_latch_positions() = [];

// Internal constants

screw_hole_diameter = screw_diameter;
screw_eyelet_radius = screw_hole_diameter * screw_eyelet_size_proportion / 2;
screw_hole_diameter_fit = screw_hole_diameter * 0.2;

latch_base_size = screw_diameter * (latch_body_size_proportion / 2);
draw_latch_body_angle = 25;
draw_latch_body_curve_radius = 10;
draw_latch_grip_angle = 45;
draw_latch_grip_curve_radius = 16;
draw_latch_thickness = latch_base_size / 2;
draw_latch_handle_length = latch_base_size * 3.25;
draw_latch_pin_handle_radius = screw_hole_diameter * 1.6;
draw_latch_pin_radius = draw_latch_pin_handle_radius - 2.2;
draw_latch_sep = 0.4;
draw_latch_vsep = 0.6;
draw_latch_body_width = latch_base_size - screw_hole_diameter / 2;
draw_latch_poly_div = 10;

// The draw latch eyelet around the box hinge axle; grows to wrap the axle
// sleeve when sleeves are enabled
function _draw_latch_screw_eyelet_radius() = (
    $b_axle_sleeves
        ? max(screw_hole_diameter * 1.1, _pin_hole_loose() / 2 + 2.2)
        : screw_hole_diameter * 1.1
);

function _draw_latch_pin_offset() = [
    (
        _draw_latch_screw_eyelet_radius()
        - draw_latch_pin_handle_radius
        - screw_hole_diameter * 0.1
    ),
    -draw_latch_handle_length,
    0
];

// For _box_extrude and _box_corners_extrude
corners_data = [
    // Rotate angle, X direction, Y direction
    [0, -1, -1],
    [90, 1, -1],
    [180, 1, 1],
    [270, -1, 1],
];

// Functions

function _vec_add(vec, add) = [for (v = vec) v + add];
function _vec_append_each(vec, append) = [for(i=vec) concat(i, append)];
function _vec_reverse(vec) = [for (i = [len(vec) - 1:-1:0]) vec[i]];

function _cumulative_sum(v) = [
    for (
        now_sum = v[0], i = 1;
        i <= len(v) - 1;
        next_sum = now_sum + v[i], ni = i + 1, now_sum = next_sum, i = ni
    )
    now_sum
];

function _attachment_screw_offset() = (
    $b_total_lip_thickness + screw_eyelet_radius + hinge_extra_setback
);

function _compute_latch_count(latch_count) = (
    let (outer_radius = $b_corner_radius + $b_wall_thickness)
    ($b_latch_count == 1 || $b_latch_count == 2)
        ? $b_latch_count
        : (($b_inner_width >= (outer_radius * 2 + $b_latch_width * 4))
            ? 2
            : 1
        )
);

function _init_latch_amount_on_top(latch_amount_on_top) = (
    latch_amount_on_top > 0
        ? latch_amount_on_top
        : min(
            ($b_top_inner_height + $b_wall_thickness) / 2,
            ($b_latch_type == "draw"
                ? $b_latch_screw_separation - screw_eyelet_radius * 1.25
                : min(
                    screw_eyelet_radius * 2.0,
                    $b_latch_screw_separation / 2
                )
            )
        )
);

function _latch_offset_from_base() = (
    $b_outer_height - (
        $b_part == "top"
            ? $b_latch_amount_on_top
            : $b_latch_screw_separation - $b_latch_amount_on_top
    )
);

function _latch_width() = ($b_latch_width - $b_size_tolerance * 2);

// Diameter of the hole in rotating parts that ride the box attachment
// axles: snug (latch catch slots) and loose (rotating bores)
function _pin_hole_snug() = (
    $b_axle_sleeves
        ? axle_sleeve_diameter + axle_sleeve_catch_fit
        : screw_hole_diameter + screw_hole_diameter_size_tolerance
);

function _pin_hole_loose() = (
    $b_axle_sleeves
        ? axle_sleeve_diameter + axle_sleeve_fit
        : (
            screw_hole_diameter
            + screw_hole_diameter_size_tolerance
            + screw_hole_diameter_fit
        )
);

// Thread-forming bore of the printed axle sleeve for the attachment screws
function _axle_sleeve_bore() = (screw_diameter <= 3 ? 2.6 : 3.5);

// Hex nut width across flats (DIN 934) for the attachment screw size
function _nut_width_across_flats() = (
    screw_diameter == 4 ? 7
        : screw_diameter == 3 ? 5.5
            : screw_diameter * 1.8
);

// Hex nut height (DIN 934) for the attachment screw size
function _nut_height() = (
    screw_diameter == 4 ? 3.2
        : screw_diameter == 3 ? 2.4
            : screw_diameter * 0.8
);

function _nut_pocket_depth() = _nut_height() + nut_pocket_depth_tolerance;

function _stacking_latches_enabled() = (
    $b_outer_height > stacking_latch_screw_separation * 2.0
);

function _handle_dimensions() = [
    // Width
    (
        rb_latch_hinge_position() * 2
        - $b_rib_width * 2
        - $b_latch_width
        - $b_size_tolerance * 2
    ),
    // Height
    min(
        handle_max_height,
        _latch_offset_from_base() - handle_thickness - 2
    )
];

function _handle_enabled() = (
    let (dimensions = _handle_dimensions())
    (
        $b_handle
        && _compute_latch_count() == 2
        && dimensions[0] > ((handle_thickness + handle_radius) * 2 * 1.75)
        && dimensions[1] >= handle_min_height
    )
);

function _label_enabled() = (
    let (label_holder_size = _label_size())
    (
        $b_label
        && _compute_latch_count() == 2
        && label_holder_size[0] >= 20
        && label_holder_size[1] >= 10
    )
);

// Lid handle computed dimensions
//
// The lid handle is a fold-flat bail recessed into a pocket in the center of
// the box top. The pivot axis runs side-to-side (X). The bail folds toward
// the box hinge side (+Y). All pivot hardware and the folded bail stay below
// the configured stow depth so items stacked on the box top clear the handle.

function _lid_handle_split() = ($b_lid_handle_style == "split");

function _lid_handle_eyelet_radius() = (
    _lid_handle_split()
        ? split_handle_eyelet_radius
        : lid_handle_screw_diameter * lid_handle_eyelet_size_proportion / 2
);

function _lid_handle_bar_thickness() = (
    _lid_handle_split() ? split_handle_bar_thickness : lid_handle_bar_thickness
);

function _lid_handle_arm_width_style() = (
    _lid_handle_split() ? split_handle_arm_width : lid_handle_arm_width
);

function _lid_handle_boss_width_style() = (
    _lid_handle_split() ? split_handle_boss_width : lid_handle_boss_width
);

// Depth of the pivot axis below the box top outer surface
function _lid_handle_axis_depth() = (
    $b_lid_handle_stow_depth + _lid_handle_eyelet_radius()
);

// Depth of the pocket floor below the box top outer surface
function _lid_handle_pocket_depth() = (
    _lid_handle_axis_depth()
    + max(_lid_handle_eyelet_radius(), _lid_handle_bar_thickness() / 2)
    + 0.3
);

function _lid_handle_arm_length() = (
    _lid_handle_split()
        ? split_handle_arm_length
        // When raised, the grip bar width is vertical; its underside sits
        // lid_handle_grip_clearance above the box top surface
        : (
            lid_handle_grip_clearance
            + _lid_handle_axis_depth()
            + lid_handle_bar_width / 2
        )
);

// Interior area available for the pocket, as [width, length]
function _lid_handle_usable_area() = [
    $b_inner_width - lid_handle_pocket_rim * 2,
    $b_inner_length - lid_handle_pocket_rim * 2
];

function _lid_handle_bar_length() = (
    min(
        lid_handle_bar_max_length,
        _lid_handle_usable_area()[0]
        - 2 * (lid_handle_fit + _lid_handle_boss_width_style())
    )
);

function _lid_handle_pivot_spacing() = (
    _lid_handle_bar_length() - _lid_handle_arm_width_style()
);

// Clear space between the inner pivot bosses
function _lid_handle_grip_span() = (
    _lid_handle_pivot_spacing()
    - _lid_handle_arm_width_style()
    - (lid_handle_fit + _lid_handle_boss_width_style()) * 2
);

// Pocket extent ahead of the pivot axis, in the fold direction
function _lid_handle_pocket_reach() = (
    _lid_handle_split()
        // Symmetric: folded half-bail tip from the lid center
        ? (
            split_handle_arm_length - split_handle_axis_offset
            + split_handle_bar_width / 2
            + lid_handle_fit + lid_handle_swing_margin
        )
        : (
            _lid_handle_arm_length()
            + lid_handle_bar_width / 2
            + lid_handle_fit
            + lid_handle_finger_room
        )
);

// Pocket extent behind the pivot axis
function _lid_handle_pocket_back() = (
    _lid_handle_split()
        ? _lid_handle_pocket_reach()
        : _lid_handle_eyelet_radius() + lid_handle_fit + lid_handle_swing_margin
);

function _lid_handle_pocket_length() = (
    _lid_handle_pocket_back() + _lid_handle_pocket_reach()
);

// Y position of the pivot axis: centered when space allows so the box hangs
// level, otherwise shifted just enough for the folded bail to fit. The
// split style is always centered (its two axes sit at +-split_handle_axis_offset).
function _lid_handle_axis_offset() = (
    _lid_handle_split()
        ? 0
        : min(0, _lid_handle_usable_area()[1] / 2 - _lid_handle_pocket_reach())
);

function _lid_handle_enabled() = (
    $b_lid_handle
    && _lid_handle_grip_span() >= lid_handle_min_grip_span
    && _lid_handle_pocket_length() <= _lid_handle_usable_area()[1]
    && (
        $b_top_outer_height >= (
            _lid_handle_pocket_depth()
            + lid_handle_floor_thickness
            + lid_handle_interior_margin
        )
    )
);

function _label_rib_separation() = (
    $b_inner_width
    - $b_corner_radius * 2
    - $b_latch_width * 2
    - $b_rib_width * 4
    - (_handle_enabled() ? (
        $b_rib_width * 2 + handle_thickness * 2 + $b_size_tolerance * 2
    ): 0)
);

function _label_space() = [
    _label_rib_separation() - $b_size_tolerance * 4 - $b_rib_width,
    min(
        label_max_height + label_holder_inset * 2,
        $b_inner_height - $b_outer_chamfer_vertical
    )
];

function _label_holder_size() = (_vec_add(_label_space(), -label_holder_inset));

function _label_size() = (
    let (label_holder_size = _label_holder_size())
    [
        label_holder_size[0] - label_holder_inset * 2,
        label_holder_size[1] - label_holder_inset
    ]
);

function _edge_chamfer_enabled() = (!($preview && $b_preview_assembled));

// Basic shape modules

module _round_shape(radius) {
    offset(-radius)
    offset(radius * 2)
    offset(-radius)
    children();
}

module _rounded_square(dimensions, radius, center=false) {
    offset(radius)
    offset(-radius)
    square(dimensions, center=center);
}

module _rounded_cylinder(h, r1, r2=0, angle=360, center=false) {
    r = $b_edge_radius;
    translate([0, 0, center ? -h / 2 : 0])
    rotate_extrude(angle=angle)
    difference() {
        _round_shape(r)
        polygon(points=[
            [-r * 2, 0],
            [r1, 0],
            [r2 > 0 ? r2 : r1, h],
            [-r * 2, h],
        ]);
        translate([-r * 4, -h / 2])
        square([r * 4, h * 2]);
    }
}

module _chamfer_edges(r, rotation=[0, 0, 0]) {
    if (_edge_chamfer_enabled()) {
        minkowski() {
            children();
            union() {
                $fs = $preview ? $fs : $fs / 5;
                if (r > 0)
                rotate(rotation)
                for (mz = [0:1:1])
                mirror([0, 0, mz])
                cylinder(d1=r, d2=0, h=r);
            }
        }
    } else {
        children();
    }
}

module _linear_extrude_with_chamfer(height, r, center=false) {
    if (_edge_chamfer_enabled()) {
        _chamfer_edges(r)
        translate([0, 0, center ? 0 : r])
        linear_extrude(height=height - r * 2, center=center)
        offset(r=-r / 2)
        children();
    } else {
        linear_extrude(height=height, center=center)
        children();
    }
}

module _hull_in_order() {
    for (ch = [0:1:$children - 2])
    hull() {
        children(ch);
        children(ch + 1);
    }
}

module _hull_pair(height) {
    slop = 0.001;
    hull() {
        for (child_obj = [
            // Child index, height offset
            [0, 0],
            [1, height - slop]
        ]) {
            translate([0, 0, child_obj[1]])
            linear_extrude(height=slop)
            children(child_obj[0]);
        }
    }
}

module _hull_stack(heights=[]) {
    cheights = _cumulative_sum(heights);
    for (ch = [1:1:len(heights)]) {
        hi = ch - 1;
        if (ch < $children) {
            translate([0, 0, hi > 0 ? cheights[hi - 1] : 0])
            _hull_pair(heights[hi]) {
                children(ch - 1);
                children(ch);
            }
        } else {
            echo("Warning: ignoring extra height value at index", ch);
        }
    }
}

// Box body modules

module _box_color() {
    color(rb_color($b_part), 0.8)
    children();
}

module _box_part_setup(part) {
    $b_part = part;
    $b_inner_height = (
        ($b_part == "top") ? $b_top_inner_height : $b_bottom_inner_height
    );
    $b_outer_height = (
        ($b_part == "top") ? $b_top_outer_height : $b_bottom_outer_height
    );
    children();
}

module _box_body() {
    difference() {
        union() {
            _box_add_seal() {
                _box_sides();
                _box_center_base(min($b_outer_height, $b_wall_thickness));
                _box_ribs();
                _box_latch_ribs();
                _box_hinge_ribs();
                _box_stacking_latch_ribs();
                _box_top_grip();
                _box_label_holder();
            }
            if (_lid_handle_enabled() && $b_part == "top") {
                _box_lid_handle_housing();
            }
        }
        rbox_lid_handle_pocket_cavity();
    }
}

module _box_body_modifier_volume() {
    render(convexity=4)
    difference() {
        union() {
            // _box_ribs();
            _box_latch_ribs();
            _box_hinge_ribs();
            _box_stacking_latch_ribs();
            _box_label_holder();
            if (_lid_handle_enabled() && $b_part == "top") {
                _box_lid_handle_housing();
            }
        }
        _box_extrude()
        intersection() {
            offset(delta=0.1)
            _box_wall_shape(reinforced=true);
            square([$b_corner_radius + $b_total_lip_thickness, $b_outer_height] * 2);
        }
        _box_center_base(min($b_outer_height, $b_wall_thickness));
    }
}

module _box_corners_extrude_linear_extension(length) {
    rotate([90, 0, 90])
    linear_extrude(height=length)
    _box_wall_shape(reinforced=true);
}

module _box_corners_extrude(
    width=$b_inner_width,
    length=$b_inner_length,
    radius=$b_corner_radius,
    extend=false
) {
    for (i = [0:1:len(corners_data) - 1]) {
        translate([
            corners_data[i][1] * (width - radius * 2) / 2,
            corners_data[i][2] * (length - radius * 2) / 2,
            0
        ])
        rotate([0, 0, 180 + corners_data[i][0]])
        union() {
            rotate_extrude(angle=90)
            children();
            if (extend) {
                for (rz = [0:1:1]) {
                    mirror([rz, 0, 0])
                    rotate([0, 0, rz ? 0 : -90])
                    if (_compute_latch_count() == 2 && ((i % 2) != rz)) {
                        // Front/rear extensions to attachments
                        is_rear = (i == 2 || i == 3);
                        _box_corners_extrude_linear_extension(
                            (
                                ($b_inner_width - $b_corner_radius * 2)
                                - ($b_latch_width + $b_rib_width)
                            ) / 2
                            - rb_latch_hinge_position()
                            // On the box top hinge, extension needs to rear
                            // the inner hinge position
                            + (
                                $b_part == "top" && is_rear
                                    ? $b_rib_width * 2
                                    : 0
                            )
                        );
                    } else if (_compute_latch_count() == 2 && len(rb_side_rib_positions()) >= 2 && ((i % 2) == rz)) {
                        // Side extensions to ribs
                        idx = ((i == 0 || i == 1) ? 0 : len(rb_side_rib_positions()) - 1);
                        // idx is 0 for front-side, or last rib index for rear-side
                        _box_corners_extrude_linear_extension(
                            (
                                ($b_inner_length - $b_corner_radius * 2)
                                - ($b_rib_width * (2 - 1))
                            ) / 2
                            + rb_side_rib_positions()[idx] * (idx == 0 ? 1 : -1)
                        );
                    } else {
                        difference() {
                            scale([
                                (tan(15) * $b_corner_radius) / $b_corner_radius,
                                1
                            ])
                            rotate_extrude(angle=90)
                            children();
                            translate([0, 0, $b_wall_thickness])
                            linear_extrude(height=$b_outer_height)
                            square($b_corner_radius + $b_wall_thickness / 2);
                        }
                    }
                }
            }
        }
    }
}

module _box_extrude(size_offset=0) {
    width = $b_inner_width + size_offset;
    length = $b_inner_length + size_offset;
    radius = $b_corner_radius + size_offset / 2;
    // Corners
    _box_corners_extrude(width, length, radius)
    children();
    // Sides
    for (i = [0:1:len(corners_data) - 1]) {
        extrude_length = (
            (corners_data[i][0] % 180 == 0 ? width : length) - radius * 2
        );
        translate([
            corners_data[i][1] * (width - radius * 2) / 2,
            corners_data[i][2] * (length - radius * 2) / 2,
            0
        ])
        rotate([0, 0, corners_data[i][0]])
        translate([extrude_length, 0, 0])
        rotate([90, 0, -90])
        linear_extrude(height=extrude_length)
        children();
    }
}

module _box_wall_inner_chamfer_shape() {
    translate([-$b_wall_thickness, 0])
    difference() {
        translate([0, $b_wall_thickness])
        square([$b_corner_radius + $b_wall_thickness, $b_outer_height]);
        translate([0, $b_wall_thickness * 0.1])
        _box_wall_outer_chamfer_shape();
    }
}

module _box_wall_outer_chamfer_shape() {
    vertical_chamfer = $b_outer_chamfer_vertical;
    horizontal_chamfer = $b_outer_chamfer_horizontal;
    translate([
        $b_corner_radius + $b_wall_thickness - horizontal_chamfer,
        -(vertical_chamfer - min(
            vertical_chamfer,
            $b_outer_height - $b_lip_height - $b_lip_thickness * 1.5
        ))
    ])
    polygon(points=[
        [0, 0],
        [horizontal_chamfer, 0],
        [horizontal_chamfer, vertical_chamfer]
    ]);
}

module _box_wall_interior_shape() {
    translate([-$b_wall_thickness, 0])
    difference() {
        translate([0, $b_wall_thickness])
        square([$b_corner_radius + $b_wall_thickness, $b_outer_height]);
        translate([0, $b_wall_thickness * 0.1])
        _box_wall_outer_chamfer_shape();
    }
}

module _box_wall_shape(reinforced=false) {
    _round_shape($b_edge_radius)
    difference() {
        square([$b_corner_radius + $b_total_lip_thickness, $b_outer_height]);
        translate([reinforced ? $b_lip_thickness : 0, 0, 0]) {
            translate([$b_corner_radius, 0])
            polygon(points=[
                [$b_wall_thickness, $b_outer_height - $b_lip_thickness * 3.5],
                [$b_wall_thickness, 0],
                [$b_total_lip_thickness, 0],
                [$b_total_lip_thickness, $b_outer_height - $b_lip_height],
            ]);
            _box_wall_outer_chamfer_shape();
        }
        _box_wall_interior_shape();
    }
    // Square inner floor edge
    square([$b_wall_thickness * 2/3, min($b_outer_height, $b_wall_thickness)]);
}

module _box_interior_shape(cut_height=0) {
    intersection() {
        difference() {
            translate([$b_wall_thickness / 2, -$b_wall_thickness / 2])
            _box_wall_inner_chamfer_shape();
            _box_wall_shape(reinforced=true);
        }
        translate([0, $b_wall_thickness])
        square([
            $b_corner_radius + $b_edge_radius,
            (cut_height > 0) ? cut_height : $b_outer_height - $b_wall_thickness
        ]);
    }
}

module _box_center_base(height) {
    radius_inset = $b_corner_radius * 2;
    linear_extrude(height=height)
    square(
        [
            $b_inner_width - radius_inset,
            $b_inner_length - radius_inset
        ],
        center=true
    );
}

module _box_seal_shape() {
    seal_thickness = (
        $b_lip_seal_type == "filament-1.75mm"
            ? 1.75
            : $b_lip_seal_type == "silicone"
                ? $b_seal_cord_diameter
                : $b_total_lip_thickness / 3
    );
    translate([$b_corner_radius + $b_total_lip_thickness / 2, 0]) {
        if ($b_lip_seal_type == "filament-1.75mm") {
            circle(seal_thickness / 2);
        } else if ($b_lip_seal_type == "silicone") {
            // Dovetail cord groove in the bottom lip. Depth 0.75d gives up
            // to ~25% face compression, limited by lip contact; the
            // undercut mouth (0.95d) snaps the cord in place; the groove
            // area exceeds the cord area so the incompressible silicone
            // has room to spread.
            d = seal_thickness;
            polygon(points=[
                [-d * 0.475, d * 0.02],
                [d * 0.475, d * 0.02],
                [d * 0.625, -d * 0.55],
                [d * 0.5, -d * 0.75],
                [-d * 0.5, -d * 0.75],
                [-d * 0.625, -d * 0.55],
            ]);
        } else if ($b_lip_seal_type == "square") {
            translate([0, -seal_thickness / 2])
            square(seal_thickness, center=true);
        } else if ($b_lip_seal_type == "wedge") {
            translate([0, -seal_thickness])
            polygon(points=[
                [-seal_thickness / 4, 0],
                [seal_thickness / 4, 0],
                [seal_thickness / 2, seal_thickness],
                [-seal_thickness / 2, seal_thickness],
            ]);
        }
    }
}

module _box_seal(delta=0) {
    translate([0, 0, $b_outer_height])
    mirror([0, 0, $b_part == "top" ? 1 : 0])
    // Improve seal / lip overlap preview rendering
    translate([0, 0, $preview ? 0.01 : 0])
    scale([1, 1, $preview ? 1.01 : 1])
    _box_extrude(size_offset=$b_total_lip_thickness)
    offset(delta=delta)
    _box_seal_shape();
}

module _box_add_seal() {
    // Seal types cut into the parts rather than printed onto the top;
    // the silicone groove shape lies below the lip plane, so the cut on
    // the top part is a no-op and only the bottom lip gets the groove
    is_seal_top_inset = (
        $b_lip_seal_type == "filament-1.75mm"
        || $b_lip_seal_type == "silicone"
    );
    delta = is_seal_top_inset ? 0 : 0.2;
    difference() {
        union() {
            children();
            if (
                $b_lip_seal_type != "none"
                && ($b_part == "top" && !is_seal_top_inset)
            ) {
                translate([0, 0, -delta])
                _box_seal(delta=-delta);
            }
        }
        if (
            $b_lip_seal_type != "none"
            && ($b_part == "bottom" || is_seal_top_inset)
        ) {
            translate([0, 0, delta])
            _box_seal();
        }
    }
}

module _box_sides() {
    _box_extrude()
    _box_wall_shape();
    if ($b_reinforced_corners) {
        _box_corners_extrude(extend=true)
        _box_wall_shape(reinforced=true);
    }
}

// Box ribs

module _box_rib_angle(ang=0) {
    $br_angle = ang;
    children();
}

module _box_rib_shape(x=$b_total_lip_thickness, y=$b_rib_width) {
    x0 = $b_edge_radius;
    angle_add = tan($br_angle) * y;
    _round_shape(x0)
    for (my = [0:1:1]) {
        mirror([0, my])
        polygon(points=[
            [x0, 0],
            [x, 0],
            [x, y / 2],
            [x0, y / 2 + angle_add],
        ]);
    }
}

module _box_rib(width=$b_rib_width) {
    lip_position = $b_outer_height - $b_lip_height;
    vertical_chamfer = min(
        $b_outer_chamfer_vertical,
        max(0, lip_position - $b_lip_thickness - $b_wall_thickness)
    );
    horizontal_chamfer = vertical_chamfer * 2/3;
    // Bottom angled part
    if (vertical_chamfer > 0) {
        _hull_stack([vertical_chamfer]) {
            translate([-horizontal_chamfer, 0])
            _box_rib_shape(y=width);
            _box_rib_shape(y=width);
        }
    }
    if (lip_position > 0) {
        // Vertical rib body
        translate([0, 0, vertical_chamfer])
        linear_extrude(height=(
            $b_outer_height - vertical_chamfer - $b_edge_radius * 1.5
        ))
        _box_rib_shape(y=width);
    }
}

module _box_plain_rib() {
    _box_rib_angle(plain_ribs_angle)
    _box_rib($b_rib_width * 2);
}

module _box_ribs() {
    // Side ribs
    for (mx = [0:1:1], py = rb_side_rib_positions()) {
        mirror([mx, 0, 0])
        translate([$b_inner_width / 2, py, 0])
        _box_plain_rib();
    }
    // Rear ribs
    for (px = rb_rear_rib_positions()) {
        translate([px, $b_inner_length / 2, 0])
        rotate([0, 0, 90])
        _box_plain_rib();
    }
}

// Box attachments (latch and hinge ribs)

module _box_attachment_rib_cut(width=0) {
    translate([-$b_corner_radius, 0, 0])
    rotate([90, 0, 0])
    translate([0, 0, -width])
    linear_extrude(height=width * 2)
    difference() {
        for (mx = [0:1:1]) {
            x = ($b_corner_radius + $b_wall_thickness) * 2;
            translate([-x / 2, $b_wall_thickness])
            square([x, $b_outer_height]);
        }
        translate([0, $b_wall_thickness * 0.1])
        _box_wall_outer_chamfer_shape();
    }
    mirror([0, 0, 1])
    linear_extrude(height=$b_outer_height + 50)
    square($b_latch_width * 6, center=true);
}

module _box_attachment_rib_pair(inner=false) {
    for (mx = [0:1:1]) {
        mirror([mx, 0, 0])
        translate([inner ? -$b_size_tolerance : 0, 0])
        translate([($b_latch_width + $b_rib_width) / 2, 0, 0])
        children();
    }
}

module _box_attachment_placement(hinge=false) {
    latch_count = _compute_latch_count();
    translate([0, $b_inner_length / 2, 0])
    if (latch_count == 2) {
        for (latch_offset = concat(
            [rb_latch_hinge_position()],
            (
                hinge
                && $b_third_hinge_width > 0
                && $b_inner_width >= $b_third_hinge_width
            ) ? [0] : []
        ))
        for (mx = [0:1:1]) {
            mirror([mx, 0, 0])
            translate([latch_offset, 0, 0])
            children();
        }
    } else {
        children();
    }
}

module _box_screw_eyelet_body(width=0, angle=360) {
    rotate([90, 0, 0])
    translate([0, 0, -width / 2])
    _rounded_cylinder(width, screw_eyelet_radius, angle=angle);
}

module _box_screw_hole(width, increase_screw_diameter=false, pin=false) {
    // With nut pockets or axle sleeves enabled, attachment screw holes are
    // clearance fit (screws clamp with nuts or thread into the sleeve
    // instead of the ribs). Holes marked pin=true carry a rotating part
    // and grow to the sleeve running fit when sleeves are enabled.
    screw_radius = 1/2 * (
        (pin && $b_axle_sleeves)
            ? _pin_hole_loose()
            : screw_hole_diameter + (
                (
                    increase_screw_diameter
                    || $b_nut_pockets
                    || $b_axle_sleeves
                )
                    ? screw_hole_diameter_fit
                    : screw_hole_diameter_size_tolerance
            )
        );
    rotate([90, 0, 0])
    translate([0, 0, -width])
    cylinder(width * 2, screw_radius, screw_radius);
}

/*
 * Hex nut pocket(s) coaxial with an attachment screw hole. The screw hole
 * axis runs along local Y; the pocket is cut inward from the face at local
 * y = -width/2 (the outward face of paired attachment ribs), or from both
 * faces with both=true.
 */
module _box_screw_nut_pocket(width=$b_rib_width, both=false) {
    pocket_radius = (
        (_nut_width_across_flats() + nut_pocket_width_tolerance)
        / cos(30) / 2
    );
    for (my = (both ? [0:1:1] : [0:1:0]))
    mirror([0, my, 0])
    rotate([90, 0, 0])
    translate([0, 0, width / 2 - _nut_pocket_depth()])
    rotate([0, 0, 30])
    cylinder(_nut_pocket_depth() + 0.01, pocket_radius, pocket_radius, $fn=6);
}

// Box latch attachments

module _box_latch_rib_base(
    width=$b_rib_width,
    latch_position=_latch_offset_from_base()
) {
    _box_rib();
    difference() {
        intersection() {
            translate([-$b_corner_radius, -width / 2, 0])
            cube([
                $b_corner_radius + $b_latch_screw_offset * 4,
                width,
                $b_outer_height
            ]);
            hull() {
                difference() {
                    latch_attachment_height = (
                        screw_eyelet_radius * 6 + $b_corner_radius * 2
                    );
                    translate([
                        -$b_corner_radius,
                        0,
                        latch_position - latch_attachment_height / 2
                    ])
                    _hull_stack([latch_attachment_height]) {
                        _box_rib_shape();
                        _box_rib_shape();
                    }
                }
                translate([0, 0, latch_position])
                translate([$b_latch_screw_offset, 0, 0])
                for (mz = [0:1:1]) {
                    mirror([0, 0, mz])
                    translate([0, 0, screw_eyelet_radius / 2])
                    _box_screw_eyelet_body(width);
                }
            }
        }
        _box_attachment_rib_cut(width);
    }
}

module _box_latch_rib() {
    rotate([0, 0, 90])
    difference() {
        _box_latch_rib_base();
        // Screw hole
        translate([$b_latch_screw_offset, 0, 0])
        translate([0, 0, _latch_offset_from_base()]) {
            _box_screw_hole(width=$b_rib_width);
            if ($b_nut_pockets) {
                _box_screw_nut_pocket();
            }
        }
    }
}

module _box_latch_ribs() {
    mirror([0, 1, 0])
    _box_attachment_placement() {
        // Latch ribs
        _box_attachment_rib_pair()
        _box_latch_rib();
        // Handle rib
        if ($b_part == "bottom" && _handle_enabled()) {
            position = (
                ($b_latch_width + $b_rib_width) / 2
                + handle_thickness
                + $b_rib_width
                + $b_size_tolerance * 2
            );
            translate(-[position, 0, 0])
            _box_latch_rib();
        }
    }
}

// Box stacking latch attachments

module _box_stacking_latch_rib() {
    base_sep = stacking_latch_screw_separation * 0.5 - ($b_part == "top" ? $b_stacking_separation : 0);
    sep_positions = [
        for(seps=[
            [base_sep],
            _stacking_latches_enabled()
                ? [
                    base_sep
                    + stacking_latch_screw_separation
                    + stacking_latch_catch_offset
                ]
                : []

        ], pos=seps) pos
    ];
    rotate([0, 0, 90])
    difference() {
        union() {
            for (sep = sep_positions)
            _box_latch_rib_base(latch_position=sep);
            intersection() {
                linear_extrude(height=$b_outer_height)
                square(($b_outer_height + $b_wall_thickness) * 10, center=true);
                hull()
                for (ox = [0, -$b_wall_thickness])
                for (sep = sep_positions)
                translate([ox, 0, sep])
                translate([$b_latch_screw_offset, 0, 0])
                _box_screw_eyelet_body($b_rib_width);
            }
        }
        // Screw hole
        for (sep = sep_positions)
        translate([$b_latch_screw_offset, 0, 0])
        translate([0, 0, sep]) {
            _box_screw_hole(width=$b_rib_width);
            if ($b_nut_pockets) {
                _box_screw_nut_pocket();
            }
        }
    }
}

module _box_stacking_latch_ribs_placement() {
    for (mx = [0:1:1])
    mirror([mx, 0, 0])
    for (py = rb_stacking_latch_positions()) {
        translate([$b_inner_width / 2, py, 0])
        rotate([0, 0, 90])
        children();
    }
}

module _box_stacking_latch_ribs() {
    _box_stacking_latch_ribs_placement()
    mirror([0, 1, 0])
    _box_attachment_rib_pair()
    _box_stacking_latch_rib();
}

// Box hinge attachments

module _box_hinge_rib_body(width=0, inner=false) {
    rib_hull_height = (
        screw_eyelet_radius * (inner ? 2 : 3)
        + 2 * ($b_wall_thickness + $b_rib_width)
        + $b_corner_radius * 1.5
    );
    difference() {
        translate([0, 0, $b_outer_height]) {
            hull() {
                mirror([0, 0, 1])
                linear_extrude(height=rib_hull_height)
                translate([-$b_corner_radius - $b_wall_thickness, 0])
                _box_rib_shape(x=$b_wall_thickness, y=width);
                if (!inner) {
                    translate([0, 0, -screw_eyelet_radius])
                    _box_hinge_screw_eyelet_body(width, angle=-180);
                }
                _box_hinge_screw_eyelet_body(width, angle=-180);
            }
            hull()
            for (position = (
                ($b_part == "top")
                    ? [0, top_hinge_eyelet_position_tolerance]
                    : [0]
            ))
            translate([0, 0, position])
            _box_hinge_screw_eyelet_body(width, angle=360);
        }
        _box_attachment_rib_cut(width);
    }
}

module _box_hinge_screw_eyelet_body(width=0, angle=360) {
    translate([$b_hinge_screw_offset, 0, 0])
    _box_screw_eyelet_body(width, angle);
}

module _box_hinge_ribs_top() {
    hinge_rib_width = $b_rib_width * 2;
    top_hinge_width = (
        _latch_width() - hinge_rib_width - hinge_size_tolerance * 2
    );
    if (top_hinge_width - $b_rib_width * 2 > 0) {
        _box_attachment_rib_pair(inner=true)
        rotate([0, 0, 90])
        translate([0, hinge_rib_width + hinge_size_tolerance, 0]) {
            _box_hinge_rib_body($b_rib_width);
            _box_rib();
        }
        // Solid hinge middle
        rotate([0, 0, 90])
        _box_hinge_rib_body(top_hinge_width, inner=true);
    } else {
        // Single module hinge
        assert(top_hinge_width > 0, "No width available for top hinge");
        rotate([0, 0, 90]) {
            _box_rib(top_hinge_width);
            _box_hinge_rib_body(top_hinge_width);
        }
    }
}

module _box_hinge_rib_bottom(width=0) {
    translate([-$b_rib_width / 2, 0, 0])
    rotate([0, 0, 90]) {
        _box_rib(width);
        _box_hinge_rib_body(width);
    }
}

module _box_hinge_rib_bottom_end_stop(width=0) {
    ww = $b_hinge_screw_offset * 2 + screw_eyelet_radius * 2;
    translate([-$b_rib_width / 2, 0, 0])
    rotate([0, 0, 90]) {
        _box_rib(width);
        intersection() {
            _box_hinge_rib_body(width);
            translate([-1.25, 0, $b_outer_height - 2.0])
            rotate([90, 0, 0])
            linear_extrude(height=width * 2, center=true)
            translate([0, -ww - screw_eyelet_radius, 0])
            _round_shape($b_edge_radius)
            square([ww, ww * 2], center=true);
        }
    }
}

module _box_hinge_ribs() {
    _box_attachment_placement(hinge=true)
    difference() {
        union() {
            if ($b_part == "bottom") {
                hinge_rib_width = $b_rib_width * 2;
                _box_attachment_rib_pair()
                _box_hinge_rib_bottom(width=$b_rib_width * 2);
                if ($b_hinge_end_stops) {
                    _box_hinge_rib_bottom_end_stop(width=_latch_width());
                }
            } else if ($b_part == "top") {
                _box_hinge_ribs_top();
            }
        }
        // Screw hole
        rotate([0, 0, 90])
        translate([
            0,
            0,
            ($b_part == "top") ? top_hinge_eyelet_position_tolerance : 0
        ])
        translate([$b_hinge_screw_offset, 0, $b_outer_height]) {
            _box_screw_hole(
                $b_latch_width,
                increase_screw_diameter = ($b_part == "top" ? true : false),
                pin = ($b_part == "top")
            );
            // Nut pockets in the outer faces of the bottom hinge ribs;
            // the screw becomes a nut-clamped hinge pin that cannot
            // rotate with the lid
            if ($b_nut_pockets && $b_part == "bottom") {
                _box_screw_nut_pocket(
                    width=$b_latch_width + $b_rib_width * 2,
                    both=true
                );
            }
        }
    }
}

module _box_top_grip_shape() {
    outset = (
        $b_lip_thickness - $b_wall_thickness - $b_edge_radius + top_grip_depth
    );
    polygon(points=[
        [
            -$b_edge_radius,
            max($b_outer_height - outset * 3.5, $b_outer_chamfer_vertical)
        ],
        [$b_wall_thickness + outset, $b_outer_height],
        [-$b_edge_radius, $b_outer_height],
    ]);
}

module _box_top_grip() {
    if ($b_top_grip && $b_part == "top" && _compute_latch_count() == 2) {
        lip_position = $b_corner_radius + $b_total_lip_thickness - $b_lip_thickness - $b_edge_radius;
        latch_offset = rb_latch_hinge_position();
        grip_half_length = min(
            top_grip_width / 2, latch_offset - ($b_latch_width / 2) - $b_rib_width
        );
        end_caps_visible = (
            latch_offset - ($b_latch_width + $b_rib_width) / 2
            > top_grip_width / 2 + 2 * $b_lip_thickness
        );
        render(convexity=2)
        mirror([0, 1, 0])
        translate([0, $b_inner_length / 2 - $b_corner_radius, 0])
        rotate([90, 0, 90])
        // hull() creates grip
        hull()
        for (mz = [0:1:1])
        mirror([0, 0, mz])
        translate([lip_position, 0]) {
            // End caps
            translate([0, 0, grip_half_length])
            translate([-$b_edge_radius, 0, 0])
            scale([1, 1, end_caps_visible ? 1 : ($b_rib_width / top_grip_depth / 2)])
            rotate([270, 270, 0])
            rotate_extrude(angle=90)
            translate([$b_edge_radius + 0.001, 0])
            _round_shape($b_edge_radius)
            _box_top_grip_shape();
        }
    }
}

// Label

module _box_label_holder_base() {
    rib_separation = _label_rib_separation();
    threshold = 50;
    label_height = (
        abs($b_outer_height - threshold) < $b_lip_height
            ? $b_outer_height
            : min($b_outer_height, threshold)
    );
    if (rib_separation > 0 && label_height > 0)
    difference() {
        translate([0, -$b_inner_length / 2 + $b_corner_radius])
        translate([0, 0, $b_outer_height - label_height])
        rotate([90, 0, -90])
        linear_extrude(height=rib_separation + $b_rib_width, center=true)
        union() {
            $b_outer_height = label_height;
            _box_wall_shape(reinforced=true);
        }
        rbox_interior();
    }
}

module _box_label_placement(label=false) {
    space = _label_space();
    label_holder_size = _label_holder_size();
    label_size = _label_size();
    slop = 0.001;
    rotate([90, 0, 0])
    translate([
        0, label ? ((label_holder_size[1] - label_size[1]) / 2) : 0, slop
    ])
    translate([
        0,
        $b_outer_height - space[1] / 2 - label_holder_inset * 0.5,
        $b_inner_length / 2 + $b_wall_thickness + $b_lip_thickness
    ])
    children();
}

module _box_label_holder() {
    label_holder_size = _label_holder_size();
    label_size = _label_size();
    if (_label_enabled() && $b_part == "bottom") {
        _box_label_holder_base();
        _box_label_placement(label=false)
        intersection() {
            render()
            difference() {
                linear_extrude(height=label_holder_thickness)
                _round_shape(label_holder_lip)
                difference() {
                    square(label_holder_size, center=true);
                    translate([0, (label_holder_size[1] - (label_size[1] - label_holder_lip)) / 2])
                    translate([0, label_holder_lip])
                    square([
                        label_size[0] - label_holder_lip * 2,
                        label_size[1] - label_holder_lip + label_holder_lip * 2
                    ], center=true);
                }
                linear_extrude(height=label_thickness + label_fit_thickness)
                translate([0, (label_holder_size[1] - label_size[1]) / 2])
                _round_shape(label_holder_lip)
                union() {
                    square(_vec_add(label_size, 0.1), center=true);
                    translate([0, label_size[1]])
                    square([label_size[0] * 2, label_size[1]], center=true);
                }
            }
            _hull_pair(label_holder_thickness) {
                _round_shape(label_holder_lip)
                square(label_holder_size, center=true);
                translate([0, label_holder_thickness / 2])
                _round_shape(label_holder_lip)
                square(_vec_add(label_holder_size, -label_holder_thickness), center=true);
            }
        }
    }
}

module _box_label_base() {
    label_size = _label_size();
    label_chamfer = label_thickness * 0.25;

    module _base_shape() {
        _round_shape(label_holder_lip)
        square(
            [label_size[0] - label_holder_lip / 2, label_size[1]], center=true
        );
    }

    color("mintcream", 0.8)
    render()
    _hull_stack([label_chamfer, label_thickness - label_chamfer * 2, label_chamfer]) {
        offset(delta=-label_chamfer)
        _base_shape();
        _base_shape();
        _base_shape();
        offset(delta=-label_chamfer)
        _base_shape();
    }
}

module _box_label_text() {
    color(rb_color($b_part), 0.8)
    translate([0, 0, label_thickness])
    linear_extrude(height=label_text_thickness)
    text(
        $b_label_text, size=$b_label_text_size, halign="center", valign="center"
    );
}

module _box_label_assembly() {
        _box_label_base();
        _box_label_text();
}

module _box_label(placement="default") {
    module _box_label_assembly() {
        _box_label_base();
        _box_label_text();
    }

    if (placement == "print") {
        _box_label_assembly();
    } else {
        _box_label_placement(label=true)
        _box_label_assembly();
    }
}

// Clip latches

module _clip_latch_shape() {
    bw = latch_base_size - screw_hole_diameter / 2;
    shd = _pin_hole_snug();
    _round_shape($b_edge_radius)
    difference() {
        union() {
            // Catch eyelets
            translate([0, $b_latch_screw_separation])
            circle(r=latch_base_size);
            // Hinge eyelet and main body
            hull() {
                circle(r=latch_base_size);
                translate([-latch_base_size, 0])
                square([bw, $b_latch_screw_separation]);
            }
            translate([-latch_base_size, 0])
            square([bw, $b_latch_screw_separation + latch_base_size * 2.5]);
        }
        // Hinge hole
        circle(d=_pin_hole_loose());
        // Catch hole
        translate([0, $b_latch_screw_separation])
        hull()
        union() {
            circle(d=shd);
            translate([
                latch_base_size + bw / 1.6,
                -$b_latch_screw_separation
            ])
            circle(d=shd);
            translate([(shd + bw) * 2, -shd])
            circle(d=shd);
        }
    }
}

module _clip_latch_part() {
    color("mintcream", 0.8)
    rotate([90, 0, 0])
    _linear_extrude_with_chamfer(
        height=_latch_width(), r=latch_edge_radius, center=true
    )
    _clip_latch_shape();
}

// Draw latches

module _draw_latch_each_segment(handle=false) {
    latch_width = _latch_width();
    vsep = (handle ? draw_latch_vsep : 0);
    for (segment = [0:1:5 - 1]) {
        if (segment % 2 == 1) {
            ht = latch_width / 5 + vsep * 2;
            translate([0, 0, latch_width / 5 * segment - vsep])
            _linear_extrude_with_chamfer(height=ht, r=latch_edge_radius)
            children();
        }
    }
}

module _draw_latch_handle_curve_shape() {
    thick = draw_latch_thickness;
    roff = draw_latch_pin_handle_radius - _draw_latch_screw_eyelet_radius();
    rr = draw_latch_pin_handle_radius;
    offset(-rr * 1.25)
    offset(rr * 1.25)
    union() {
        translate([-draw_latch_pin_handle_radius + _draw_latch_screw_eyelet_radius(), 0])
        circle(draw_latch_pin_handle_radius);
        translate([-roff + rr - thick, 0]) {
            translate([0, -thick])
            square(thick);

            translate([draw_latch_body_curve_radius + thick, -thick])
            rotate(draw_latch_body_angle)
            translate([-draw_latch_body_curve_radius, 0])
            rotate(180)
            square([thick, latch_edge_radius*1.5]);

            translate([thick, draw_latch_body_curve_radius - thick])
            translate(draw_latch_body_curve_radius * [1, -1])
            intersection() {
                difference() {
                    circle(r=draw_latch_body_curve_radius + thick);
                    circle(r=draw_latch_body_curve_radius);
                }
                rotate(180)
                square(draw_latch_body_curve_radius * 2);
                rotate(180 - (90 - draw_latch_body_angle))
                square(draw_latch_body_curve_radius * 2);
            }
        }
    }
}

module _draw_latch_handle_body_shape() {
    difference() {
        union() {
            hull() {
                circle(r=_draw_latch_screw_eyelet_radius());
                translate([-draw_latch_pin_handle_radius + _draw_latch_screw_eyelet_radius(), -draw_latch_handle_length, 0])
                circle(r=draw_latch_pin_handle_radius);
            }
            translate([0, -draw_latch_handle_length])
            _draw_latch_handle_curve_shape();
        }
        // Pin hole
        translate(_draw_latch_pin_offset())
        circle(r=draw_latch_pin_radius + draw_latch_sep);
        // Screw hole
        circle(d=_pin_hole_loose());
    }
}

module _draw_latch_grip_layer_polyhedron(h1=0, h2=1) {

    function _curve_points(angle, radius) = [
        let (steps = draw_latch_poly_div)
        for (a = [0:angle/steps:angle + 0.001]) [radius * sin(a), radius* cos(a)]
    ];

    function _translate_points(vector, add=[]) = [
        for (pt = vector) [
            for (i = [0:1:len(pt) - 1]) pt[i] + (i < len(add) ? add[i] : 0)
        ]
    ];

    function _curve_offset_inverse(ht) = (
        (draw_latch_grip_curve_radius - _curve_offset(ht)) / 2
    );

    function _curve_offset(y) = (
        let (lw = _latch_width())
        let (precision = 1000)
        let (deg = abs(y - lw / 2) / lw / 2 * 360 * 0.8)
        (
            round(
                (cos(deg) * (draw_latch_grip_curve_radius * 0.9)
            )
            * precision) / precision
        )
    );

    function _surface_points(h, z) = (
        let (angle = draw_latch_grip_angle)
        let (crad = _curve_offset(h))
        let (ler = _edge_chamfer_enabled() ? latch_edge_radius / 2 : 0)
        let (thick = draw_latch_thickness)
        let (origin_edge_points = [
            [ler, draw_latch_thickness - ler], [ler, ler]
        ])
        _vec_append_each(
            concat(
                origin_edge_points,
                _translate_points(
                    concat(
                        _curve_points(angle, crad + ler),
                        _vec_reverse(_curve_points(angle, crad + thick - ler))
                    ),
                    add=[_curve_offset_inverse(h), -crad]
                )
            ),
            z
        )
    );

    function _curve_faces(bpts) = [
        for (i = [0:1:len(bpts) / 2 - 2]) [len(bpts)+i, len(bpts)+i+1, i+1, i]
    ];

    // Bottom points
    bpts = _surface_points(h1, z=0);
    // Top points
    tpts = _surface_points(h2, z=(h2 - h1));
    // All points
    points = concat(bpts, tpts);
    // Faces
    faces_base = [
        // Top
        _vec_reverse(_vec_add([for(i = [0:1:len(bpts) - 1]) i], len(bpts))),
        // Bottom
        [for(i = [0:1:len(bpts) - 1]) i],
        // Near end
        [
            0, len(bpts) - 1, len(bpts) * 2 - 1, len(bpts)
        ],
        // Far end
        [
            len(bpts) / 2,
            len(bpts) / 2 - 1,
            len(bpts) + len(bpts) / 2 - 1,
            len(bpts) + len(bpts) / 2,
        ],
    ];
    // Near curve faces
    ncf = _curve_faces(bpts);
    // Far curve faces
    fcf = [for (f = _curve_faces(bpts)) _vec_add(f, len(bpts) / 2)];
    faces = concat(faces_base, ncf, fcf);
    polyhedron(points=points, faces=faces);
}

module _draw_latch_grip() {
    tr = _edge_chamfer_enabled() ? latch_edge_radius : 0;
    top = _latch_width() - tr * 2;
    steps = draw_latch_poly_div * 2;

    render(convexity=2)
    _chamfer_edges(r=latch_edge_radius)
    rotate([0, 0, 270])
    for (h = [tr:top / steps:top + tr - 0.01]) {
        translate([0, 0, h])
        _draw_latch_grip_layer_polyhedron(h1=h, h2=h + (top / steps));
    }
}

module _draw_latch_handle() {
    render(convexity=4)
    difference() {
        union() {
            _linear_extrude_with_chamfer(
                height=_latch_width(), r=latch_edge_radius
            )
            _draw_latch_handle_body_shape();

            translate([
                _draw_latch_screw_eyelet_radius(),
                -draw_latch_handle_length - draw_latch_thickness
            ])
            translate([draw_latch_body_curve_radius, 0, 0])
            rotate(draw_latch_body_angle)
            translate([-draw_latch_body_curve_radius, 0, 0])
            mirror([1, 0, 0])
            _draw_latch_grip();
        }

        _draw_latch_each_segment(handle=true)
        union() {
            translate([-draw_latch_sep / 2, draw_latch_sep / 2])
            _draw_latch_attach_shape(sep=-draw_latch_sep);
            translate([0, -draw_latch_handle_length, 0])
            translate([-draw_latch_pin_handle_radius + _draw_latch_screw_eyelet_radius(), 0])
            hull() {
                circle(r=draw_latch_pin_radius + draw_latch_sep);
                translate([latch_base_size * 1.5 + draw_latch_sep, draw_latch_sep])
                circle(_draw_latch_screw_eyelet_radius());
            }
        }
    }
}

module _draw_latch_attach_shape_base(sep=0.4) {
    pin_diameter = draw_latch_pin_radius - sep / 2;
    latch_offset_from_pin = sep + draw_latch_thickness + draw_latch_pin_handle_radius;
    pin_latch_size_delta = pin_diameter - draw_latch_thickness;

    _draw_latch_catch_shape_body();
    translate(_draw_latch_pin_offset())
    hull() {
        circle(r=draw_latch_pin_radius);
        for (i = [-1, 1])
        translate([
            latch_offset_from_pin,
            latch_offset_from_pin + pin_latch_size_delta * i
        ])
        circle(draw_latch_thickness);
    }
}

module _draw_latch_attach_shape(sep=0.4) {
    round_factor = 6;
    intersection() {
        union() {
            _draw_latch_attach_shape_base(sep=sep);
            intersection() {
                union() {
                    hull()
                    _draw_latch_attach_shape_base(sep=sep);
                    _draw_latch_attach_shape_base(sep=sep);
                }
                _round_shape(round_factor)
                for (dx = [0:1:round_factor], dy = [0:1:round_factor])
                translate([dx * latch_base_size / 2, dy * -latch_base_size / 2])
                _draw_latch_attach_shape_base(sep=sep);
            }
        }
        translate([-draw_latch_handle_length, -draw_latch_handle_length * 1.75])
        square(draw_latch_handle_length * 2);
    }
}

module _draw_latch_catch_shape_body() {
    pin_diameter = draw_latch_pin_radius - draw_latch_sep / 2;
    latch_offset_from_pin = draw_latch_sep + draw_latch_thickness + draw_latch_pin_handle_radius;
    pin_latch_size_delta = pin_diameter - draw_latch_thickness;

    // Body
    translate([_draw_latch_screw_eyelet_radius() + draw_latch_thickness + draw_latch_sep, 0])
    hull() {
        translate([0, -draw_latch_handle_length + latch_offset_from_pin - pin_latch_size_delta])
        circle(draw_latch_thickness);
        translate([0, -latch_base_size + screw_diameter / 2])
        translate([0, $b_latch_screw_separation])
        circle(draw_latch_thickness);
    }
}

module _draw_latch_catch_shape_hook() {
    compress_ratio = 0.65;
    catchsep = 0;
    outr = _draw_latch_screw_eyelet_radius() + draw_latch_thickness * 2;

    translate([draw_latch_sep, $b_latch_screw_separation])
    translate([0, -latch_base_size + screw_diameter / 2 - catchsep])
    difference() {
        union() {
            intersection() {
                circle(r=outr);
                square(outr);
            }
            mirror([1, 0]) {
                translate([0, outr * 0.2])
                square([outr * compress_ratio, outr * (1 - compress_ratio - 0.1)]);
                translate([0, outr * (1 - compress_ratio)])
                intersection() {
                    circle(r=outr * compress_ratio);
                    square(outr);
                }
            }
            // Grip
            translate([outr / 1.5, outr / 1.5])
            circle(d=draw_latch_thickness * 1.5);
        }
        cr = compress_ratio * 0.8;
        translate([-_draw_latch_screw_eyelet_radius() * cr, 0])
        for (mx = [0:1:1])
        mirror([mx, 0])
        scale([mx ? 1 - (1 - cr) / 1.00 : 1 + cr, 1])
        intersection() {
            color(mx ? "lightblue" : "lightgreen", 0.6)
            circle(r=_draw_latch_screw_eyelet_radius());
            square(_draw_latch_screw_eyelet_radius());
        }
    }
}

module _draw_latch_pin_center_hole_shape() {
    translate(_draw_latch_pin_offset())
    circle(r=(draw_latch_pin_radius + draw_latch_sep) / 5);
}

module _draw_latch_catch() {
    _linear_extrude_with_chamfer(height=_latch_width(), r=latch_edge_radius)
    difference() {
        union() {
            _round_shape($b_edge_radius) {
                _draw_latch_catch_shape_body();
                _draw_latch_catch_shape_hook();
            }
            // Pin
            translate(_draw_latch_pin_offset())
            circle(r=draw_latch_pin_radius);
        }
        _draw_latch_pin_center_hole_shape();
    }

    difference() {
        _draw_latch_each_segment(handle=false)
        _draw_latch_attach_shape();
        linear_extrude(height=_latch_width())
        _draw_latch_pin_center_hole_shape();
    }
}

module _draw_latch_part() {
    translate([0, 0, $b_size_tolerance]) {
        color("lightgray", 0.8)
        _draw_latch_handle();
        color("mintcream", 0.8)
        translate(_draw_latch_pin_offset())
        rotate([0, 0, $b_preview_box_open ? -45 : 0])
        translate(-_draw_latch_pin_offset())
        _draw_latch_catch();
    }
}

// Main latch type selection

module _latch(placement="default") {

    module _latch_by_type() {
        if ($b_latch_type == "clip") {
            _clip_latch_part();
        } else if ($b_latch_type == "draw") {
            rotate([90, 0, 180])
            translate([0, 0, -$b_latch_width / 2])
            _draw_latch_part();
        }
    }

    if (placement == "print") {
        rotate([90, 0, 0])
        _latch_by_type();
    } else if (placement == "box-preview") {
        rotate([0, 0, 270])
        _latch_by_type();
    } else {
        _latch_by_type();
    }
}

// Stacking latches

module _stacking_latch_shape() {
    catch_heights = [
        stacking_latch_screw_separation,
        stacking_latch_screw_separation + stacking_latch_catch_offset
    ];

    bw = latch_base_size - screw_hole_diameter / 2;
    blsep = min(catch_heights);
    slcatch = max(catch_heights);
    shd = _pin_hole_snug();
    mirror([stacking_latch_catch_offset < 0 ? 1 : 0, 0, 0])
    _round_shape($b_edge_radius)
    difference() {
        union() {
            // Catch eyelets
            _hull_in_order() {
                translate([0, blsep])
                circle(r=latch_base_size);
                translate([0, slcatch])
                circle(r=latch_base_size);
                translate([
                    0,
                    slcatch + stacking_latch_grip_length + bw / 2
                ])
                circle(d=bw);
            }
            // Hinge eyelet and main body
            hull() {
                circle(r=latch_base_size);
                translate([-latch_base_size, 0])
                square([bw, blsep]);
            }
        }
        // Hinge hole
        circle(d=_pin_hole_loose());
        // Catch hole
        translate([0, blsep])
        hull()
        union() {
            circle(d=shd);
            translate([latch_base_size + bw / 1.6, -blsep])
            circle(d=shd);
            translate([(shd + bw) * 2, -shd])
            circle(d=shd);
        }
        // Stacking catch
        translate([0, slcatch])
        hull()
        union() {
            circle(d=shd);
            translate([-(shd + bw) * 2, -shd * 0.75])
            circle(d=shd);
            translate([-(shd + bw) * 2, -(shd + bw)])
            circle(d=shd);
        }
    }
}

module _stacking_latch_part() {
    color("mintcream", 0.8)
    rotate([90, 0, 0])
    _linear_extrude_with_chamfer(
        height=_latch_width(), r=latch_edge_radius, center=true
    )
    _stacking_latch_shape();
}

// Axle sleeves

module _axle_sleeve(length) {
    render(convexity=2)
    difference() {
        cylinder(length, d=axle_sleeve_diameter);
        translate([0, 0, -0.5])
        cylinder(length + 1, d=_axle_sleeve_bore());
    }
}

module _stacking_latch(placement="default") {
    if (placement == "print") {
        rotate([90, 0, 0])
        _stacking_latch_part();
    } else if (placement == "box-preview") {
        rotate([180, 0, 90])
        _stacking_latch_part();
    } else {
        _stacking_latch_part();
    }
}

// Lid handle
//
// Part coordinates for the box top place the outer lid surface at z=0 with
// +z extending into the lid interior. The pivot axis runs along X at
// y=_lid_handle_axis_offset(), z=_lid_handle_axis_depth(). The bail folds
// flat toward +Y into the pocket and swings up to vertical for carrying.

module _lid_handle_pocket_footprint(expand=0, floor_level=false) {
    back = _lid_handle_pocket_back();
    reach = (
        _lid_handle_pocket_reach()
        // The split style needs no finger scoop: the halves are raised by
        // dragging their textured bars toward the center
        - ((floor_level && !_lid_handle_split()) ? lid_handle_scoop_inset : 0)
    );
    translate([0, _lid_handle_axis_offset() + (reach - back) / 2])
    _rounded_square(
        [
            _lid_handle_bar_length()
            + (lid_handle_fit + lid_handle_boss_width) * 2
            + expand * 2,
            back + reach + expand * 2
        ],
        lid_handle_pocket_corner_radius + expand,
        center=true
    );
}

module _lid_handle_pocket_cavity_raw() {
    // Volume above the lid surface, to clear any exterior plate features
    translate([0, 0, -6])
    linear_extrude(height=6.01)
    _lid_handle_pocket_footprint();
    // Pocket body. The far wall slopes inward toward the floor, forming a
    // finger scoop ahead of the folded grip bar.
    _hull_pair(_lid_handle_pocket_depth()) {
        _lid_handle_pocket_footprint();
        _lid_handle_pocket_footprint(floor_level=true);
    }
}

// X centers of one split half's two interleaved arms, in half-local
// coordinates (the other half is the same part rotated 180 degrees)
function _split_handle_arm_slots() = [
    -(_lid_handle_pivot_spacing() / 2),
    _lid_handle_pivot_spacing() / 2 - split_handle_arm_slot
];

// Boss block shape shared by both split-handle pivot bosses: pivot
// cylinder blended into a base on the pocket floor. Origin at the pivot
// axis, extending +X by width.
module _split_handle_boss_block(width, expand=0) {
    er = split_handle_eyelet_radius;
    hull() {
        rotate([0, 90, 0])
        translate([0, 0, -expand])
        cylinder(h=width + expand * 2, r=er + expand);
        translate([
            -expand,
            -er - 2 - expand,
            _lid_handle_pocket_depth() - _lid_handle_axis_depth() - 1
        ])
        cube([
            width + expand * 2,
            (er + 2 + expand) * 2,
            1 + expand
        ]);
    }
}

module _split_handle_bosses(expand=0) {
    aw = split_handle_arm_width;
    bw = split_handle_boss_width;
    for (r = [0, 180])
    rotate([0, 0, r])
    translate([0, split_handle_axis_offset, _lid_handle_axis_depth()])
    for (sx = _split_handle_arm_slots(), side = [0:1:1]) {
        translate([
            sx + (
                side
                    ? aw / 2 + lid_handle_fit
                    : -(aw / 2 + lid_handle_fit + bw)
            ),
            0, 0
        ])
        _split_handle_boss_block(bw, expand);
    }
}

module _split_handle_screw_holes() {
    hole_start = split_handle_arm_width / 2 + lid_handle_fit - 0.5;
    thread_radius = (
        (lid_handle_screw_diameter + screw_hole_diameter_size_tolerance) / 2
    );
    clearance_radius = (
        (lid_handle_screw_diameter + lid_handle_screw_hole_fit) / 2
    );
    for (r = [0, 180])
    rotate([0, 0, r])
    translate([0, split_handle_axis_offset, _lid_handle_axis_depth()])
    for (sx = _split_handle_arm_slots())
    translate([sx, 0, 0]) {
        // Thread-forming hole in the +X boss
        rotate([0, 90, 0])
        translate([0, 0, hole_start])
        cylinder(h=split_handle_boss_width + 2, r=thread_radius);
        // Clearance hole through the -X boss
        rotate([0, -90, 0])
        translate([0, 0, hole_start])
        cylinder(h=split_handle_boss_width + 2, r=clearance_radius);
    }
}

// One split-handle half in local coordinates: pivot axis along X at the
// origin, folding toward -Y. Uniform thickness; prints flat. The second
// half is the same part rotated 180 degrees about Z.
module _split_handle_half() {
    arm_length = split_handle_arm_length;
    t = split_handle_bar_thickness;
    bar_length = _lid_handle_bar_length();
    screw_hole_diameter_loose = (
        lid_handle_screw_diameter
        + screw_hole_diameter_size_tolerance
        + lid_handle_screw_hole_fit
    );
    color("mintcream", 0.8)
    render(convexity=4)
    difference() {
        translate([0, 0, -t / 2])
        linear_extrude(height=t)
        offset(r=1.5) offset(r=-1.5)
        union() {
            // Grip bar
            translate([
                -bar_length / 2,
                -arm_length - split_handle_bar_width / 2
            ])
            square([bar_length, split_handle_bar_width]);
            // Arms and pivot eyelets
            for (sx = _split_handle_arm_slots()) {
                translate([sx - split_handle_arm_width / 2, -arm_length])
                square([split_handle_arm_width, arm_length]);
                translate([sx, 0])
                circle(r=split_handle_eyelet_radius);
            }
        }
        // Pivot screw holes
        for (sx = _split_handle_arm_slots())
        translate([sx, 0, 0])
        rotate([0, 90, 0])
        cylinder(
            h=split_handle_arm_width * 3,
            d=screw_hole_diameter_loose,
            center=true
        );
        // Drag-texture grooves across the bar face toward the lid surface
        for (dy = [-2.4, 0, 2.4])
        translate([0, -arm_length + dy, -t / 2])
        rotate([45, 0, 0])
        cube([bar_length + 1, 1.0, 1.0], center=true);
    }
}

module _lid_handle_bosses(expand=0) {
    if (_lid_handle_split()) {
        _split_handle_bosses(expand);
    } else {
        _lid_handle_bail_bosses(expand);
    }
}

module _lid_handle_bail_bosses(expand=0) {
    eyelet_radius = _lid_handle_eyelet_radius();
    boss_width = lid_handle_boss_width;
    axis_offset = _lid_handle_axis_offset();
    for (mx = [0:1:1], side = [0:1:1]) {
        boss_x = (
            side
                ? lid_handle_arm_width / 2 + lid_handle_fit
                : -(lid_handle_arm_width / 2 + lid_handle_fit + boss_width)
        );
        mirror([mx, 0, 0])
        translate([_lid_handle_pivot_spacing() / 2 + boss_x - expand, 0, 0])
        hull() {
            translate([0, axis_offset, _lid_handle_axis_depth()])
            rotate([0, 90, 0])
            cylinder(h=boss_width + expand * 2, r=eyelet_radius + expand);
            // Widened base merging into the pocket floor
            translate([
                0,
                axis_offset - eyelet_radius - 2 - expand,
                _lid_handle_pocket_depth() - 1
            ])
            cube([
                boss_width + expand * 2,
                (eyelet_radius + 2 + expand) * 2,
                1 + expand
            ]);
        }
    }
}

module _lid_handle_screw_holes() {
    if (_lid_handle_split()) {
        _split_handle_screw_holes();
    } else {
        _lid_handle_bail_screw_holes();
    }
}

module _lid_handle_bail_screw_holes() {
    hole_start = lid_handle_arm_width / 2 + lid_handle_fit - 0.5;
    thread_radius = (
        (lid_handle_screw_diameter + screw_hole_diameter_size_tolerance) / 2
    );
    clearance_radius = (
        (lid_handle_screw_diameter + lid_handle_screw_hole_fit) / 2
    );
    for (mx = [0:1:1])
    mirror([mx, 0, 0])
    translate([
        _lid_handle_pivot_spacing() / 2,
        _lid_handle_axis_offset(),
        _lid_handle_axis_depth()
    ]) {
        // Thread-forming hole in the outer boss
        rotate([0, 90, 0])
        translate([0, 0, hole_start])
        cylinder(h=lid_handle_boss_width + 2, r=thread_radius);
        // Clearance hole through the inner boss
        rotate([0, -90, 0])
        translate([0, 0, hole_start])
        cylinder(h=lid_handle_boss_width + 4, r=clearance_radius);
    }
}

module _box_lid_handle_housing() {
    housing_height = (
        _lid_handle_pocket_depth() + lid_handle_floor_thickness
    );
    render(convexity=4)
    difference() {
        union() {
            _hull_stack([housing_height - 2, 2]) {
                _lid_handle_pocket_footprint(expand=lid_handle_pocket_wall);
                _lid_handle_pocket_footprint(expand=lid_handle_pocket_wall);
                offset(delta=-2)
                _lid_handle_pocket_footprint(expand=lid_handle_pocket_wall);
            }
            _lid_handle_bosses();
        }
        rbox_lid_handle_pocket_cavity();
        _lid_handle_screw_holes();
    }
}

module _lid_handle_bail() {
    arm_length = _lid_handle_arm_length();
    bar_thickness = lid_handle_bar_thickness;
    screw_hole_diameter_loose = (
        lid_handle_screw_diameter
        + screw_hole_diameter_size_tolerance
        + lid_handle_screw_hole_fit
    );
    color("mintcream", 0.8)
    render(convexity=4)
    difference() {
        union() {
            for (mx = [0:1:1])
            mirror([mx, 0, 0])
            translate([_lid_handle_pivot_spacing() / 2, 0, 0]) {
                // Pivot eyelet
                rotate([0, 90, 0])
                translate([0, 0, -lid_handle_arm_width / 2])
                _rounded_cylinder(
                    lid_handle_arm_width, _lid_handle_eyelet_radius()
                );
                // Arm
                rotate([-90, 0, 0])
                linear_extrude(height=arm_length)
                _rounded_square(
                    [lid_handle_arm_width, bar_thickness],
                    $b_edge_radius,
                    center=true
                );
            }
            // Grip bar
            translate([0, arm_length, 0])
            rotate([0, 90, 0])
            linear_extrude(height=_lid_handle_bar_length(), center=true)
            _rounded_square(
                [bar_thickness, lid_handle_bar_width],
                lid_handle_bar_edge_radius,
                center=true
            );
        }
        // Pivot screw holes
        for (mx = [0:1:1])
        mirror([mx, 0, 0])
        translate([_lid_handle_pivot_spacing() / 2, 0, 0])
        rotate([0, 90, 0])
        cylinder(
            h=lid_handle_arm_width * 2,
            d=screw_hole_diameter_loose,
            center=true
        );
    }
}

module _lid_handle(placement="default") {
    rbox_for_top()
    if (_lid_handle_enabled()) {
        if (_lid_handle_split()) {
            if (placement == "print") {
                // Both halves are the same part; print two
                for (i = [0:1:1])
                translate([
                    0,
                    i * (
                        split_handle_arm_length
                        + split_handle_bar_width + 6
                    ),
                    split_handle_bar_thickness / 2
                ])
                _split_handle_half();
            } else {
                // Folded flat into the lid pocket, part coordinates
                for (r = [0, 180])
                rotate([0, 0, r])
                translate([
                    0, split_handle_axis_offset, _lid_handle_axis_depth()
                ])
                _split_handle_half();
            }
        } else if (placement == "print") {
            translate([0, 0, lid_handle_bar_thickness / 2])
            _lid_handle_bail();
        } else {
            // Folded flat into the lid pocket, in box top part coordinates
            translate([
                0, _lid_handle_axis_offset(), _lid_handle_axis_depth()
            ])
            _lid_handle_bail();
        }
    }
}

// Handle

module _handle_part() {
    width = _handle_dimensions()[0];
    height = _handle_dimensions()[1];
    thick = handle_thickness;
    radius = handle_radius;
    // Ensure minimum size
    if (_handle_enabled())
    color("mintcream", 0.8)
    render(convexity=2)
    difference() {
        union() {
            // Sides
            for (mx = [0:1:1])
            mirror([mx, 0, 0])
            translate([(width - thick) / 2, 0, 0])
            union() {
                rotate([90, 0, 0])
                linear_extrude(height=height - radius)
                _rounded_square([thick, thick], $b_edge_radius, center=true);
                rotate([0, 90, 0])
                _rounded_cylinder(h=thick, r1=thick / 2, center=true);
            }
            // Grip
            translate([0, -(thick / 2 + height), 0])
            union() {
                rotate([0, 90, 0])
                linear_extrude(height=width - (thick + radius) * 2, center=true)
                _rounded_square([thick, thick], $b_edge_radius, center=true);
            }
            // Corners
            union() {
                for (mx = [0:1:1])
                mirror([mx, 0, 0])
                translate([width / 2 - thick - radius, -height + radius, 0])
                rotate(270)
                rotate_extrude(angle=90)
                translate([radius, -thick / 2])
                _rounded_square([thick, thick], $b_edge_radius);
            }
        }
        // Screw holes
        for (mx = [0:1:1])
        mirror([mx, 0, 0])
        translate([width / 2, 0, 0])
        rotate([0, 0, 90])
        _box_screw_hole(thick * 4 , increase_screw_diameter=true);
    }
}

module _handle(placement="default") {
    rbox_for_bottom()
    if (placement == "print") {
        _handle_part();
    } else if (placement == "box-preview" || placement == "box-preview-open") {
        translate([0, -$b_outer_length / 2, 0])
        translate([0, -$b_latch_screw_offset / 2, 0])
        translate([0, 0, _latch_offset_from_base()])
        rotate([(placement == "box-preview") ? 90 : 0, 0, 0])
        _handle_part();
    } else {
        _handle_part();
    }
}
