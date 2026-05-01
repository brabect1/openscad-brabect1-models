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

// Creates structures clamp structures for printing
// ================================================

use <square_tube_clamp.scad>

//projection(cut=true) xrot(-90) {
//assembly_screw_and_nut(diam, len);
//}

diam=15;
len=30;
tol=1;
dil=2;
ww=11.5;


// // Joint Assembly
// // ==============
// simple_joint_socket(jc=4, jh=12, jw=3, jt=3);
// left(0)
// zrot(45) up(7) yrot(180) simple_joint_head(jc=4, jh=12, jw=3, jt=3);

ci = clamp_info(d=diam, l=len, dilat=dil, tol=tol, ww=ww);
bd = get_body_depth(ci=ci);

jc = 6; // joint connect diameter
jh = 16; // joint header diameter
jw = 3; // joint head width
jt = 3; // joint wall thickness
jtol = 0.5; // joint tolerance
cji = clamp_joint_info(jc=jc, jh=jh, jw=jw, jt=jt, jtol=jtol);

yrot(90) union() {
square_tube_clamp(clamptype="uni", jointtype="socket", ci=ci, cji=cji);
}

//yrot(90) union() {
//difference() {
//square_tube_clamp(clamptype="uni",ci=ci);
//left(-.05 + bd - struct_val(ci, "bthick")) yrot(-90) cyl(d=jh+jtol, h=struct_val(ci, "bthick")+0.1, anchor=BOTTOM);
//}
//left(bd) yrot(-90) simple_joint_socket(jc=jc, jh=jh, jw=jw, jt=jt, tol=jtol);
//color("Red") {left(bd - struct_val(ci, "bthick")) yrot(-90)  difference() {
//cyl(d=jh + 2*jtol + 2*jt, h=struct_val(ci, "bthick"), anchor=BOTTOM);
//down(0.05) cyl(d=jh+jtol, h=struct_val(ci, "bthick")+0.1, anchor=BOTTOM);
//}
//}
//
//fwd(2*get_body_width(ci=ci))
//union() {
//square_tube_clamp(clamptype="uni", ci=ci);
//left(bd) yrot(-90) simple_joint_head(jc=jc, jh=jh, jw=jw, jt=jt, tol=jtol);
//}
//}

// // Clamp Structure
// // ===============
// square_tube_clamp_head(d=diam, l=len, dilat=dil, tol=tol, ww=ww);
// xflip() square_tube_clamp_nut(d=diam, l=len, dilat=dil, tol=tol, ww=ww);


// // Experiments
// // ===========
// diff()
// cuboid([6,20,100],anchor=RIGHT)
// attach(LEFT)
// color("Red") { up(1) zrot(30) nut_trap_inline(4,"M4", $slop=.5, orient=BOT); }

// screw_hole("M4",length=10,head="none",anchor=BOT)
// attach(TOP)
// color("Green") { screw_hole("M4",length=10,head="none",head_oversize=1.5,anchor=BOT); }

//             difference() {
//                 cuboid([5,10,100], rounding=2, anchor=RIGHT);
// down(10) cylinder(h=100, d=2, orient=LEFT);
// }


// // Example of working with structures
// // ==================================
// 
// echo("----------------------");
// ci = clamp_info(d=diam, l=len);
// echo("Clamp info: ", ci);
// echo_struct(ci);
// 
// cc = struct_set([], ["length", 11]);
// //cc = clamp_info(ci=ci);
// echo("screw_y=", get_screw_y(d=diam, l=len) );
// echo("----------------------");


// vim: expandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
