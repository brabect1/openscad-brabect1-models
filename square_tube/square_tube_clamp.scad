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

$fn=32;


function get_screw_z(
    d, // diameter
    l, // length
    bt = 3, // body thickness of the clamp
    ww = 9, // clamp "wing" width
    wt = 6, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    clamp_dilat = 1, // dilataion between the head and nut clamp halves
    tol = 2 // tolerance (margin by which the clamp exceeds the tube profile)
) = l/2-6;


function get_screw_y(
    d, // diameter
    l, // length
    bt = 3, // body thickness of the clamp
    ww = 9, // clamp "wing" width
    wt = 6, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    clamp_dilat = 1, // dilataion between the head and nut clamp halves
    tol = 2 // tolerance (margin by which the clamp exceeds the tube profile)
) = 
    let(
        r = d/2.0,
        body_thick = bt,
        body_width = d+tol+2*body_thick,
        body_depth = r+tol/2+body_thick
    ) 
    (body_width+ww)/2;


module square_tube_clamp_nut(
    d, // diameter
    l, // length
    bt = 3, // body thickness of the clamp
    ww = 9, // clamp "wing" width
    wt = 6, // clamp "wing" thickness (this is the thickness just for the clamp half being construed),
    ss = screw_info("M4,4"), // screw specification (as returned by `BOSL2::screw_info()`
    clamp_dilat = 1, // dilataion between the head and nut clamp halves
    tol = 2 // tolerance (margin by which the clamp exceeds the tube profile)
) {
    r = d/2.0; // "radius" (i.e. half of the square tube edge length)

    body_thick = bt;
    body_width = d+tol+2*body_thick;
    body_depth = r+tol/2+body_thick;

    screw_y = (body_width+ww)/2;
    screw_z = l/2-6;

    left(clamp_dilat/2)
    difference() {
        union() {
            cuboid([body_depth-clamp_dilat/2,body_width,l], rounding=2, anchor=RIGHT);
            diff()
                cuboid([wt-clamp_dilat/2,body_width+2*ww,l], rounding=2, anchor=RIGHT)
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
        right(1) cuboid([r+tol/2+1-clamp_dilat/2,d+tol,l+1], anchor=RIGHT);
    }
}


module square_tube_clamp_head(
    d, // diameter
    l, // length
    bt = 3, // body thickness of the clamp
    ww = 9, // clamp "wing" width
    wt = 6, // clamp "wing" thickness (this is the thickness just for the clamp half being construed)
    clamp_dilat = 1, // dilataion between the head and nut clamp halves
    tol = 2 // tolerance (margin by which the clamp exceeds the tube profile)
) {
    r = d/2.0; // "radius" (i.e. half of the square tube edge length)

    body_thick = bt;
    body_width = d+tol+2*body_thick;
    body_depth = r+tol/2+body_thick;

    screw_y = (body_width+ww)/2;
    screw_z = l/2-6;

    left(clamp_dilat/2)
    difference() {
        union() {
            cuboid([body_depth-clamp_dilat/2,body_width,l], rounding=2, anchor=RIGHT);
            diff()
                cuboid([wt-clamp_dilat/2,body_width+2*ww,l], rounding=2, anchor=RIGHT)
                attach(LEFT) {
                    fwd( screw_z) right(screw_y) screw_hole("M4x1,4",head="socket",counterbore=true,head_oversize=1.5,anchor="top");
                    fwd( screw_z) left( screw_y) screw_hole("M4x1,4",head="socket",counterbore=true,head_oversize=1.5,anchor="top");
                    back(screw_z) right(screw_y) screw_hole("M4x1,4",head="socket",counterbore=true,head_oversize=1.5,anchor="top");
                    back(screw_z) left( screw_y) screw_hole("M4x1,4",head="socket",counterbore=true,head_oversize=1.5,anchor="top");
                }
        }
        color("Red") {
        fwd( screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        back(screw_y) right(1) cylinder(h=wt+1, d=2, orient=LEFT);
        }
        right(1) cuboid([r+tol/2+1-clamp_dilat/2,d+tol,l+1], anchor=RIGHT);
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
    square_tube_clamp_head(d=d, l=l, clamp_dilat=dil, tol=tol);
    
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
    xflip() square_tube_clamp_nut(d=d, l=l, clamp_dilat=dil, tol=tol);
    
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
    square_tube_clamp_head(d=d, l=l, clamp_dilat=dil, tol=tol);
    xflip() square_tube_clamp_nut(d=d, l=l, clamp_dilat=dil, tol=tol);
    
    color("Silver") {
        assembly_project_comps(d=d, l=l);
    }
}

diam=15;
len=30;
tol=1;
dil=2;

//projection(cut=true) xrot(-90) {
//assembly_screw_and_nut(diam, len);
//}

// assembly
difference() {
all_assembly(d=diam, l=len, dil=dil, tol=tol);
fwd(diam/2+get_screw_y(d=diam, l=len)) cuboid([2*diam,diam,2*len]);
}

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
// vim: expandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
