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

diam=20;
len=30;
tol=1;
dil=2;
ww=11.5;


ci = clamp_info(d=diam, l=len, dilat=dil, tol=tol, ww=ww);
bd = get_body_depth(ci=ci);
bw = get_body_width(ci=ci);
cw = get_clamp_width(ci=ci);

jc = 6; // joint connect diameter
jh = 16; // joint header diameter
jw = 3; // joint head width
jt = 3; // joint wall thickness
jtol = 0.5; // joint tolerance
cji = clamp_joint_info(jc=jc, jh=jh, jw=jw, jt=jt, jtol=jtol);

yrot(90) union() {
    union() {
        square_tube_clamp(clamptype="uni", jointtype="socket", ci=ci, cji=cji);
        up(len+1) square_tube_clamp(clamptype="uni", ci=ci, cji=cji);
    }
    fwd(cw + 1) union() {
        square_tube_clamp(clamptype="uni", jointtype="head", ci=ci, cji=cji);
        up(len+1) square_tube_clamp(clamptype="uni", ci=ci, cji=cji);
    }
}

//---->>>>
// extra round tube C clamp experiment
// -----------------------------------
$fn = 120;

module round_tube_c_clamp(
    td=25, // tube diameter
    cct=3, // clamp thickness,
    ccw=5, // clamp width
    cca=280, // clamp arc angle
    cctol=0.5 // inner diameter tolerance
) {

    difference() {
        // outer diameter cylinder
        cylinder(h=ccw, d=td+2*cct);
        
        down(.05) union() {
            // inner diameter cylinder extrusion (incl. tolerance)
            cylinder(h=ccw+.1, d=td+tol);

            // pie slice extrusion to yeild "C" shape
//TODO            rotate([0, 0, cca/2])
//TODO            render() // make rendering faster
            color("Red") { pie_slice(radius=cct+td/2 + .1, angle=360-cca, height=ccw+.1); }
        }
    }
    
    // round edges
    color("Blue") {
        for (a = [0, 360-cca]) {
            rotate([0, 0, a])
            translate([(cct+td+2*cctol)/2, 0, 0])
            cylinder(h=ccw, r=cct/2);
        }
    }
}

// pie slice
// For pie slice code options, see https://3dprinting.stackexchange.com/questions/10638/creating-pie-slice-in-openscad
module pie_slice(
    radius,
    angle,
    height
) {
    linear_extrude(height=height)
    polygon(points = concat([[0,0]], [for(a=[0:5:angle]) [radius*cos(a), radius*sin(a)]], [[0,0]]));
}

// use `dil` to place at the same level with the square tube clamp parts
back(cw+1) up(dil/2) round_tube_c_clamp();

//<<<<----

// vim: expandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
