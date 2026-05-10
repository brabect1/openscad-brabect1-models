// Copyright 2026 Tomas Brabec
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


$fn=120;

include <BOSL2/std.scad>

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


module round_tube_c_clamp_simple(
    td=25, // tube diameter
    cct=3, // clamp thickness,
    ccw=5, // clamp width
    cca=280, // clamp arc angle
    cctol=0.5, // inner diameter tolerance
    ers=1.0 // ednding rounding scale
) {
    difference() {
        union() {
            difference() {
                // outer diameter cylinder
                cylinder(h=ccw, d=td+2*cct);
    
                down(.05) union() {
                    // inner diameter cylinder extrusion (incl. tolerance)
                    cylinder(h=ccw+.1, d=td+cctol);
    
                    // pie slice extrusion to yeild "C" shape
                    color("Red") { pie_slice(radius=cct+td/2 + .1, angle=360-cca, height=ccw+.1); }
                }
            }
            
            // round edges
            scale = ers;
            color("Blue") {
                for (a = [0, 360-cca]) {
                    rotate([0, 0, a])
                    translate([cct*scale/2 + (td+cctol)/2, 0, 0])
                    xscale(scale) cylinder(h=ccw, r=cct/2);
                }
            }
        }
    }
}


module round_tube_c_clamp_hooks(
    td=25, // tube diameter
    cct=3, // clamp thickness,
    ccw=5, // clamp width
    cca=280, // clamp arc angle
    cctol=0.5 // inner diameter tolerance
) {
    difference() {
        union() {
            difference() {
                // outer diameter cylinder
                cylinder(h=ccw, d=td+2*cct);
    
                down(.05) union() {
                    // inner diameter cylinder extrusion (incl. tolerance)
                    cylinder(h=ccw+.1, d=td+cctol);
    
                    // pie slice extrusion to yeild "C" shape
                    color("Red") { pie_slice(radius=cct+td/2 + .1, angle=360-cca, height=ccw+.1); }
                }
            }
            
            // round edges
            scale = 2;
            color("Blue") {
                for (a = [0, 360-cca]) {
                    rotate([0, 0, a])
                    translate([cct*scale/2 + (td+cctol)/2, 0, 0])
                    xscale(scale) cylinder(h=ccw, r=cct/2);
                }
            }
        }
    
        union() {
            scale = 2;
            color("Blue") {
                for (a = [[0,-15,-45], [360-cca,15,45]]) {
                    rotate([0, 0, a[0]+a[1]])
                    translate([cct*scale*3/4 + (td+cctol)/2, 0, 0])
                    zrot(a[2]) xscale(scale) down(.5) cylinder(h=ccw+1, r=cct/2);
                }
            }
        }
    }
}


// two connected C clamps (of the same diameter)
module round_tube_2c_clamp_hooks(
    td=25, // tube diameter
    cct=3, // clamp thickness,
    ccw=5, // clamp width
    cca=280, // clamp arc angle
    cctol=0.5 // inner diameter tolerance
) {
    ccod=td+2*cct;
    up(ccw/2) union() {
        color("Blue") {
            right(ccod/2+1.0) zrot(45) down(ccw/2) round_tube_c_clamp_hooks(td=td, cct=cct, ccw=ccw, cca=cca, cctol=cctol);
        }
        color("Red") {
        left(ccod/2+1.0) yrot(180) zrot(45)
            down(ccw/2) round_tube_c_clamp_hooks(td=td, cct=cct, ccw=ccw, cca=cca, cctol=cctol);
        }

        cuboid([6, td/2, ccw]);
    }
}

