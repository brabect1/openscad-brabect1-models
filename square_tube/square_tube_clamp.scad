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

//TODO:remove    d, // diameter
//TODO:remove    l, // length
//TODO:remove    bt = 3, // body thickness of the clamp
//TODO:remove    ww = 9, // clamp "wing" width
//TODO:remove    wt = 6, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
//TODO:remove    clamp_dilat = 1, // dilataion between the head and nut clamp halves
//TODO:remove    tol = 2 // tolerance (margin by which the clamp exceeds the tube profile)
//TODO:remove) = l/2-6;


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
    
//TODO:remove    d, // diameter
//TODO:remove    l, // length
//TODO:remove    bt = 3, // body thickness of the clamp
//TODO:remove    ww = 9, // clamp "wing" width
//TODO:remove    wt = 6, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
//TODO:remove    clamp_dilat = 1, // dilataion between the head and nut clamp halves
//TODO:remove    tol = 2 // tolerance (margin by which the clamp exceeds the tube profile)
//TODO:remove) = 
//TODO:remove    let(
//TODO:remove        r = d/2.0,
//TODO:remove        body_thick = bt,
//TODO:remove        body_width = d+tol+2*body_thick,
//TODO:remove        body_depth = r+tol/2+body_thick
//TODO:remove    ) 
//TODO:remove    (body_width+ww)/2;


module square_tube_clamp_nut(
//TODO:remove    d, // diameter
//TODO:remove    l, // length
//TODO:remove    bt = 3, // body thickness of the clamp
//TODO:remove    ww = 9, // clamp "wing" width
//TODO:remove    wt = 6, // clamp "wing" thickness (this is the thickness just for the clamp half being construed),
//TODO:remove    ss = screw_info("M4,4"), // screw specification (as returned by `BOSL2::screw_info()`
//TODO:remove    clamp_dilat = 1, // dilataion between the head and nut clamp halves
//TODO:remove    tol = 2 // tolerance (margin by which the clamp exceeds the tube profile)
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
//TODO:remove    screw_z = l/2-6;

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
                    fwd( screw_z) right(screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.5, anchor=TOP);
                    fwd( screw_z) left( screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.5, anchor=TOP);
                    back(screw_z) right(screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.5, anchor=TOP);
                    back(screw_z) left( screw_y) up(1) zrot(30) nut_trap_inline(wt/2+1,ss, $slop=.5, anchor=TOP);
                }
        }
        color("Red") {
        fwd( screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        back(screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        }
        right(1) cuboid([r+tol/2+1-dilat/2,d+tol,l+1], anchor=RIGHT);
    }
}


module square_tube_clamp_head(
//TODO:remove    d, // diameter
//TODO:remove    l, // length
//TODO:remove    bt = 3, // body thickness of the clamp
//TODO:remove    ww = 9, // clamp "wing" width
//TODO:remove    wt = 6, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
//TODO:remove    ss = screw_info("M4,4", head="pan"), // screw specification (as returned by `BOSL2::screw_info()`
//TODO:remove    dilat = 1, // dilataion between the head and nut clamp halves
//TODO:remove    tol = 2 // tolerance (margin by which the clamp exceeds the tube profile)
//TODO:remove) {
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
//TODO:remove    r = d/2.0; // "radius" (i.e. half of the square tube edge length)
//TODO:remove
//TODO:remove    body_thick = bt;
//TODO:remove    body_width = d+tol+2*body_thick;
//TODO:remove    body_depth = r+tol/2+body_thick;
//TODO:remove
//TODO:remove    screw_y = (body_width+ww)/2;
//TODO:remove    screw_z = l/2-6;

    left(dilat/2)
    difference() {
        union() {
            cuboid([body_depth-dilat/2,body_width,l], rounding=2, anchor=RIGHT);
            diff()
                cuboid([wt-dilat/2,body_width+2*ww,l], rounding=2, anchor=RIGHT)
                attach(LEFT) {
                    fwd( screw_z) right(screw_y) down(2) screw_hole(ss,counterbore=true,head_oversize=1.5,anchor="head_bot");
                    fwd( screw_z) left( screw_y) down(2) screw_hole(ss,counterbore=true,head_oversize=1.5,anchor="head_bot");
                    back(screw_z) right(screw_y) down(2) screw_hole(ss,counterbore=true,head_oversize=1.5,anchor="head_bot");
                    back(screw_z) left( screw_y) down(2) screw_hole(ss,counterbore=true,head_oversize=1.5,anchor="head_bot");
                }
        }
        color("Red") {
        fwd( screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        back(screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        }
        right(1) cuboid([r+tol/2+1-dilat/2,d+tol,l+1], anchor=RIGHT);
    }
}


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

    cuboid([d, d, l+10]);

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

//projection(cut=true) xrot(-90) {
//assembly_screw_and_nut(diam, len);
//}


diam=15;
len=30;
tol=1;
dil=2;
ww=11.5;

square_tube_clamp_head(d=diam, l=len, dilat=dil, tol=tol, ww=ww);
xflip() square_tube_clamp_nut(d=diam, l=len, dilat=dil, tol=tol, ww=ww);

//diff()
//cuboid([6,20,100],anchor=RIGHT)
//attach(LEFT)
//color("Red") { up(1) zrot(30) nut_trap_inline(4,"M4", $slop=.5, orient=BOT); }

//screw_hole("M4",length=10,head="none",anchor=BOT)
//attach(TOP)
//color("Green") { screw_hole("M4",length=10,head="none",head_oversize=1.5,anchor=BOT); }

//            difference() {
//                cuboid([5,10,100], rounding=2, anchor=RIGHT);
//down(10) cylinder(h=100, d=2, orient=LEFT);
//}


// Example of working with structures
// ==================================

echo("----------------------");
ci = clamp_info(d=diam, l=len);
echo("Clamp info: ", ci);
echo_struct(ci);

cc = struct_set([], ["length", 11]);
//cc = clamp_info(ci=ci);
echo("screw_y=", get_screw_y(d=diam, l=len) );
echo("----------------------");


// vim: expandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
