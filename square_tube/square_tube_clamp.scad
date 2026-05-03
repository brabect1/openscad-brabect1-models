// Copyright 2025 Tomas Brabec
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
//     
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/structs.scad>
include <BOSL2/vnf.scad>

$fn=32;

// Creates a "clamp_info" structure.
function clamp_info(
    d, // diameter
    l, // length
    bt, // body thickness of the clamp
    ww, // clamp "wing" width
    wt, // clamp "wing" thickness (this is the thickness just for the clamp half being construed),
    ss, // screw specification (as returned by `BOSL2::screw_info()`
    dilat, // dilataion between the head and nut clamp halves
    tol, // tolerance (margin by which the clamp exceeds the tube profile)
    ci // default clamp info structure
) = let(
        ci = is_undef(ci) ? struct_set([], ["bthick", 3, "wwidth", 9, "wthick", 6, "screw_info", screw_info("M4,4", head="pan"), "dilat", 1, "tolerance", 2]) : ci,
        d = is_undef(d) ? struct_val(ci, "diameter") : d,
        l = is_undef(l) ? struct_val(ci, "length") : l,
        bt = is_undef(bt) ? struct_val(ci, "bthick") : bt,
        ww = is_undef(ww) ? struct_val(ci, "wwidth") : ww,
        wt = is_undef(wt) ? struct_val(ci, "wthick") : wt,
        ss = is_undef(ss) ? struct_val(ci, "screw_info") : ss,
        dilat = is_undef(dilat) ? struct_val(ci, "dilat") : dilat,
        tol = is_undef(tol) ? struct_val(ci, "tolerance") : tol
    ) struct_set([], ["diameter", d, "length", l, "bthick", bt, "wwidth", ww, "wthick", wt, "screw_info", ss, "dilat", dilat, "tolerance", tol], grow=true);


function get_body_width(
    ci, // clamp info
    d, // diameter
    l, // length
    bt, // body thickness of the clamp
    ww, // clamp "wing" width
    wt, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    ss, // screw_info specification
    dilat, // dilataion between the head and nut clamp halves
    tol // tolerance (margin by which the clamp exceeds the tube profile)
) = 
    let(
        ci = clamp_info(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol)
    )
    struct_val(ci, "diameter") + struct_val(ci, "tolerance") + 2*struct_val(ci, "bthick");


function get_body_depth(
    ci, // clamp info
    d, // diameter
    l, // length
    bt, // body thickness of the clamp
    ww, // clamp "wing" width
    wt, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    ss, // screw_info specification
    dilat, // dilataion between the head and nut clamp halves
    tol // tolerance (margin by which the clamp exceeds the tube profile)
) = 
    let(
        ci = clamp_info(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol)
    )
    (struct_val(ci, "diameter") + struct_val(ci, "tolerance"))/2.0 + struct_val(ci, "bthick");


function get_clamp_width(
    ci, // clamp info
    d, // diameter
    l, // length
    bt, // body thickness of the clamp
    ww, // clamp "wing" width
    wt, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    ss, // screw_info specification
    dilat, // dilataion between the head and nut clamp halves
    tol // tolerance (margin by which the clamp exceeds the tube profile)
) = 
    let(
        ci = clamp_info(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol)
    )
    2 * struct_val(ci, "wwidth") + get_body_width(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol);


function get_screw_z(
    ci, // clamp info
    d, // diameter
    l, // length
    bt, // body thickness of the clamp
    ww, // clamp "wing" width
    wt, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    ss, // screw_info specification
    dilat, // dilataion between the head and nut clamp halves
    tol // tolerance (margin by which the clamp exceeds the tube profile)
) = 
    let(
        ci = clamp_info(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol)
    ) 
    struct_val(ci, "length")/2-6;



function get_screw_y(
    ci, // clamp info
    d, // diameter
    l, // length
    bt, // body thickness of the clamp
    ww, // clamp "wing" width
    wt, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    ss, // screw_info specification
    dilat, // dilataion between the head and nut clamp halves
    tol // tolerance (margin by which the clamp exceeds the tube profile)
) = 
    let(
        ci = clamp_info(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol)
    ) 
    (get_body_width(ci) + struct_val(ci, "wwidth"))/2;
    


// Creates a clamp half with a screw hole and a combined opening for both head and nut.
// This clamp representation ought to be most universal (compared to `square_tube_clamp_head`
// and `square_tube_clamp_nut`, which are complement to each other).
module square_tube_clamp_uni(
    ci, // clamp info
    d, // diameter
    l, // length
    bt, // body thickness of the clamp
    ww, // clamp "wing" width
    wt, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    ss, // screw_info specification
    dilat, // dilataion between the head and nut clamp halves
    tol // tolerance (margin by which the clamp exceeds the tube profile)
) {
    ci = clamp_info(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol);

    // redefine module parameters
    l = struct_val(ci, "length");
    d = struct_val(ci, "diameter");
    bt = struct_val(ci, "bthick");
    ww = struct_val(ci, "wwidth");
    wt = struct_val(ci, "wthick");
    ss = struct_val(ci, "screw_info");
    dilat = struct_val(ci, "dilat");
    tol = struct_val(ci, "tolerance");

    r = d/2.0; // "radius" (i.e. half of the square tube edge length)

    body_width = get_body_width(ci);
    body_depth = get_body_depth(ci);

    screw_y = get_screw_y(ci);
    screw_z = get_screw_z(ci);

    left(dilat/2)
    difference() {
        union() {
            cuboid([body_depth-dilat/2,body_width,l], rounding=2, anchor=RIGHT);
            diff()
                cuboid([wt-dilat/2,body_width+2*ww,l], rounding=2, anchor=RIGHT)
                attach(LEFT) {
                    fwd( screw_z) right(screw_y) down(1.5) screw_hole(ss,length=wt+1,counterbore=true,head_oversize=0.5,anchor="head_bot");
                    fwd( screw_z) left( screw_y) down(1.5) screw_hole(ss,length=wt+1,counterbore=true,head_oversize=0.5,anchor="head_bot");
                    back(screw_z) right(screw_y) down(1.5) screw_hole(ss,length=wt+1,counterbore=true,head_oversize=0.5,anchor="head_bot");
                    back(screw_z) left( screw_y) down(1.5) screw_hole(ss,length=wt+1,counterbore=true,head_oversize=0.5,anchor="head_bot");
                    fwd( screw_z) right(screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.1, anchor=TOP);
                    fwd( screw_z) left( screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.1, anchor=TOP);
                    back(screw_z) right(screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.1, anchor=TOP);
                    back(screw_z) left( screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.1, anchor=TOP);
                }
        }
        color("Red") {
        fwd( screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        back(screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        }
        right(1) cuboid([r+tol/2+1-dilat/2,d+tol,l+1], anchor=RIGHT);
    }
}


// Creates a clamp half with a screw hole and a screw nut opening (a.k.a. nut trap).
module square_tube_clamp_nut(
    ci, // clamp info
    d, // diameter
    l, // length
    bt, // body thickness of the clamp
    ww, // clamp "wing" width
    wt, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    ss, // screw_info specification
    dilat, // dilataion between the head and nut clamp halves
    tol // tolerance (margin by which the clamp exceeds the tube profile)
) {
    ci = clamp_info(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol);

    // redefine module parameters
    l = struct_val(ci, "length");
    d = struct_val(ci, "diameter");
    bt = struct_val(ci, "bthick");
    ww = struct_val(ci, "wwidth");
    wt = struct_val(ci, "wthick");
    ss = struct_val(ci, "screw_info");
    dilat = struct_val(ci, "dilat");
    tol = struct_val(ci, "tolerance");

    r = d/2.0; // "radius" (i.e. half of the square tube edge length)

    body_width = get_body_width(ci);
    body_depth = get_body_depth(ci);

    screw_y = get_screw_y(ci);
    screw_z = get_screw_z(ci);

    left(dilat/2)
    difference() {
        union() {
            cuboid([body_depth-dilat/2,body_width,l], rounding=2, anchor=RIGHT);
            diff()
                cuboid([wt-dilat/2,body_width+2*ww,l], rounding=2, anchor=RIGHT)
                attach(LEFT) {
                    color("Green") {
                    fwd( screw_z) right(screw_y) screw_hole(ss, length=wt+1, head="none", anchor=TOP);
                    fwd( screw_z) left( screw_y) screw_hole(ss, length=wt+1, head="none", anchor=TOP);
                    back(screw_z) right(screw_y) screw_hole(ss, length=wt+1, head="none", anchor=TOP);
                    back(screw_z) left( screw_y) screw_hole(ss, length=wt+1, head="none", anchor=TOP);
                    }
                    fwd( screw_z) right(screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.1, anchor=TOP);
                    fwd( screw_z) left( screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.1, anchor=TOP);
                    back(screw_z) right(screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.1, anchor=TOP);
                    back(screw_z) left( screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.1, anchor=TOP);
                }
        }
        color("Red") {
        fwd( screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        back(screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        }
        right(1) cuboid([r+tol/2+1-dilat/2,d+tol,l+1], anchor=RIGHT);
    }
}


// Creates a clamp half with a screw hole and a screw head opening.
module square_tube_clamp_head(
    ci, // clamp info
    d, // diameter
    l, // length
    bt, // body thickness of the clamp
    ww, // clamp "wing" width
    wt, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    ss, // screw_info specification
    dilat, // dilataion between the head and nut clamp halves
    tol // tolerance (margin by which the clamp exceeds the tube profile)
) {
    ci = clamp_info(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol);

    // redefine module parameters
    l = struct_val(ci, "length");
    d = struct_val(ci, "diameter");
    bt = struct_val(ci, "bthick");
    ww = struct_val(ci, "wwidth");
    wt = struct_val(ci, "wthick");
    ss = struct_val(ci, "screw_info");
    dilat = struct_val(ci, "dilat");
    tol = struct_val(ci, "tolerance");

    r = d/2.0; // "radius" (i.e. half of the square tube edge length)

    body_width = get_body_width(ci);
    body_depth = get_body_depth(ci);

    screw_y = get_screw_y(ci);
    screw_z = get_screw_z(ci);

    left(dilat/2)
    difference() {
        union() {
            cuboid([body_depth-dilat/2,body_width,l], rounding=2, anchor=RIGHT);
            diff()
                cuboid([wt-dilat/2,body_width+2*ww,l], rounding=2, anchor=RIGHT)
                attach(LEFT) {
                    fwd( screw_z) right(screw_y) down(1.5) screw_hole(ss,length=wt+1,counterbore=true,head_oversize=0.5,anchor="head_bot");
                    fwd( screw_z) left( screw_y) down(1.5) screw_hole(ss,length=wt+1,counterbore=true,head_oversize=0.5,anchor="head_bot");
                    back(screw_z) right(screw_y) down(1.5) screw_hole(ss,length=wt+1,counterbore=true,head_oversize=0.5,anchor="head_bot");
                    back(screw_z) left( screw_y) down(1.5) screw_hole(ss,length=wt+1,counterbore=true,head_oversize=0.5,anchor="head_bot");
                }
        }
        color("Red") {
        fwd( screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        back(screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        }
        right(1) cuboid([r+tol/2+1-dilat/2,d+tol,l+1], anchor=RIGHT);
    }
}


// Creates a "clamp_joint_info" structure.
function clamp_joint_info(
    jc, // joint "connect" diameter
    jh, // joint "head" diameter
    jw, // joint "head" thickness
    jt, // joint "wall" thickness
    jtol, // joint tolerance
    cji // default clamp info structure
) = let(
        cji = is_undef(cji) ? struct_set([], ["cdiam", 6, "hdiam", 10, "hsdiam", 8, "hthick", 3, "wthick", 3, "tolerance", 0.5]) : cji,
        jc = is_undef(jc) ? struct_val(cji, "cdiam") : jc,
        jh = max(is_undef(jh) ? struct_val(cji, "hdiam") : jh, jc+2), // make head exceed connection by at least 1mm (in radius)
        jhs = max(jc+2, jh/2), // shorter head diameter so it becomes eliptic but make it exceed connection
        jw = is_undef(jw) ? struct_val(cji, "hthick") : jw,
        jt = is_undef(jt) ? struct_val(cji, "wthick") : jt,
        jtol = is_undef(jtol) ? struct_val(cji, "tolerance") : jtol
    ) struct_set([], ["cdiam", jc, "hdiam", jh, "hsdiam", jhs, "hthick", jw, "wthick", jt, "tolerance", jtol], grow=true);


// Wrapper for clamps with different types of screw openings.
module square_tube_clamp(
    clamptype, // clamp type: "nut", "head", (default) "uni"
    jointtype, // joint type: "socket", "head", (default) "none"
    ci, // clamp info
    cji, // clamp joint info
    d, // diameter
    l, // length
    bt, // body thickness of the clamp
    ww, // clamp "wing" width
    wt, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    ss, // screw_info specification
    dilat, // dilataion between the head and nut clamp halves
    tol // tolerance (margin by which the clamp exceeds the tube profile)
) {

    // redefine module parameters (to make sure they are all defined and usable)
    ci = clamp_info(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol);
    l = struct_val(ci, "length");
    d = struct_val(ci, "diameter");
    bt = struct_val(ci, "bthick"); // clamp body thickness
    ww = struct_val(ci, "wwidth");
    wt = struct_val(ci, "wthick");
    ss = struct_val(ci, "screw_info");
    dilat = struct_val(ci, "dilat");
    tol = struct_val(ci, "tolerance");
    cji = clamp_joint_info(cji=cji);

    // define extra local variables
    r = d/2.0; // "radius" (i.e. half of the square tube edge length)
    bw = get_body_width(ci); // computed clamp body width
    bd = get_body_depth(ci); // computed clamp body depth

    jc = struct_val(cji, "cdiam");
    jh = struct_val(cji, "hdiam");
    jhs = struct_val(cji, "hsdiam");
    jw = struct_val(cji, "hthick");
    jt = struct_val(cji, "wthick");
    jtol = struct_val(cji, "tolerance");

    // union of the clamp half with the joint
    union() {

        // difference of the clamp half with conditional cylinder below a joint socket
        difference() {
            // create the clamp "half" of the selected srew opening
            if (clamptype == "nut") {
                square_tube_clamp_nut(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol);
            } else if (clamptype == "head") {
                square_tube_clamp_head(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol);
            } else {
                square_tube_clamp_uni(ci=ci, d=d, l=l, bt=bt, ww=ww, wt=wt, ss=ss, dilat=dilat, tol=tol);
            }

            if (jointtype == "socket") {
                left(-.05 + bd - bt) yrot(-90) cyl(d=jh+jtol, h=bt+0.1, anchor=BOTTOM);
            }
        }

        if (jointtype == "head") {
            left(bd) yrot(-90) simple_joint_head(cji=cji);
        } else if (jointtype == "socket") {
            left(bd) yrot(-90) simple_joint_socket(cji=cji);
            color("Cyan") {
                left(bd - struct_val(ci, "bthick")) yrot(-90)  difference() {
                    cyl(d=jh + 2*jtol + 2*jt, h=struct_val(ci, "bthick"), anchor=BOTTOM);
                    down(0.05) cyl(d=jh+jtol, h=struct_val(ci, "bthick")+0.1, anchor=BOTTOM);
                }
            }
        }
    }
}


// Creates a screw and nut assembly.
module assembly_screw_and_nut(
    d, // diameter
    l, // length
    bt = 3, // body thickness of the clamp
    ww = 9, // clamp "wing" width
    wt = 6, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    tol = 2 // tolerance (margin by which the clamp exceeds the tube profile)
) {
    ss = screw_info("M4,12", head="pan", drive="slot");
    sl = struct_val(ss, "length");
    screw(spec=ss);
    down(sl/2) nut(ss);
}


// Creates the tube profile and screws and nuts to complete the visualization
// of the entire clamp.
module assembly_project_comps(
    d, // diameter
    l, // length
    bt = 3, // body thickness of the clamp
    ww = 9, // clamp "wing" width
    wt = 6, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    tol = 2 // tolerance (margin by which the clamp exceeds the tube profile)
) {
    r = d/2.0; // "radius" (i.e. half of the square tube edge length)

    body_thick = bt;
    body_width = d+tol+2*body_thick;
    body_depth = r+tol/2+body_thick;

    screw_y = (body_width+ww)/2;
    screw_z = l/2-6;

    // instantiate the square tube
    cuboid([d, d, l+10]);

    // instantiate 4x screw+nut
    up(  screw_z) fwd( screw_y) rot(90,v=[0,-1,0]) assembly_screw_and_nut(d,l,bt,ww,wt,tol);
    down(screw_z) fwd( screw_y) rot(90,v=[0,-1,0]) assembly_screw_and_nut(d,l,bt,ww,wt,tol);
    up(  screw_z) back(screw_y) rot(90,v=[0,-1,0]) assembly_screw_and_nut(d,l,bt,ww,wt,tol);
    down(screw_z) back(screw_y) rot(90,v=[0,-1,0]) assembly_screw_and_nut(d,l,bt,ww,wt,tol);
}


module head_assembly(
    d, // diameter
    l, // length,
    dil, // clamp dilataion
    tol
) {
    square_tube_clamp_head(d=d, l=l, dilat=dil, tol=tol);
    
    color("Silver") {
        assembly_project_comps(d=d, l=l);
    }
}


module nut_assembly(
    d, // diameter
    l, // length,
    dil, // clamp dilataion
    tol
) {
    xflip() square_tube_clamp_nut(d=d, l=l, dilat=dil, tol=tol);
    
    color("Silver") {
        assembly_project_comps(d=d, l=l);
    }
}


module all_assembly(
    d, // diameter
    l, // length,
    dil, // clamp dilataion
    tol
) {
    square_tube_clamp_head(d=d, l=l, dilat=dil, tol=tol);
    xflip() square_tube_clamp_nut(d=d, l=l, dilat=dil, tol=tol);
    
    color("Silver") {
        assembly_project_comps(d=d, l=l);
    }
}


// Creates a head part of the joint. The socket can be then attached
// to the clamp.
module simple_joint_head(
    cji, // clamp joint info
    jc, // joint "connect" diameter
    jh, // joint "head" diameter
    jw, // joint "head" width
    jt, // joint "wall" thickness
    tol = 0.5 // joint tolerance
) {
    cji = clamp_joint_info(cji=cji, jc=jc, jh=jh, jw=jw, jt=jt, jtol=tol);

    jc = struct_val(cji, "cdiam");
    jh = struct_val(cji, "hdiam");
    jhs = struct_val(cji, "hsdiam");
    jw = struct_val(cji, "hthick");
    jt = struct_val(cji, "wthick");
    jtol = struct_val(cji, "tolerance");

    cyl(h=jt+jtol, d=jc, anchor=BOTTOM)
    attach(TOP)
    color("Red") { yscale(jhs/jh) cyl(h=jw, d=jh, rounding=0.2, anchor=BOTTOM); };
}


// Creates a socket part of the joint. The socket can be then attached
// to the clamp.
module simple_joint_socket(
    cji, // clamp joint info
    jc, // joint "connect" diameter
    jh, // joint "head" diameter
    jw, // joint "head" width
    jt, // joint "wall" thickness
    tol = 0.5 // joint tolerance
) {
    cji = clamp_joint_info(cji=cji, jc=jc, jh=jh, jw=jw, jt=jt, jtol=tol);

    jc = struct_val(cji, "cdiam");
    jh = struct_val(cji, "hdiam");
    jhs = struct_val(cji, "hsdiam");
    jw = struct_val(cji, "hthick");
    jt = struct_val(cji, "wthick");
    jtol = struct_val(cji, "tolerance");

    w = jh + 2*jtol + 2*jt;
    z = jw+jtol+jt;

    difference() {
        //cuboid([w, w, z], anchor=BOTTOM);
        cyl(d=w, h=z, anchor=BOTTOM);
        up(jw+jtol/2) cyl(h=jt+jtol, d=jc+jtol, anchor=BOTTOM);
        down(jtol/2) cyl(h=z+jtol-jt, d=jh+jtol, anchor=BOTTOM);
        color("Blue") { up(jw+jtol/2) left(w/4+jtol/2) cuboid([w/2+jtol, jc+jtol, jt+jtol], anchor=BOTTOM); }
        color("Green") { down(jtol) left(w/4+jtol/2) cuboid([w/2+jtol, jhs+jtol, z-jt+jtol], anchor=BOTTOM); }
    }
}

