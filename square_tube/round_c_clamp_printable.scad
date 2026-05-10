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

// Creates C clamp structures for printing
// =======================================

include <BOSL2/std.scad>
include <BOSL2/structs.scad>

use <round_c_clamp.scad>

td=25;
ccw=6;
cca=280;

// thicknes of 3mm yields good flexibility (using higher may get too stiff)
cct=3;

// PETG printed on the side needs no tolerance (as it is flexible to stretch enough)
cctol=0.0;

// outer diameter
ccod=td+2*cct;


module cclamp_2x(
    td=25, // tube diameter
    cct=3, // clamp thickness,
    ccw=5, // clamp width
    cca=280, // clamp arc angle
    cctol=0.5, // inner diameter tolerance
    ers=1.0 // ednding rounding scale
) {
    ccod=td+2*cct;
    right(ccod/2+1) round_tube_c_clamp_simple(td=td, cct=cct, ccw=ccw, cca=cca, cctol=cctol, ers=ers);
    left(ccod/2+1)  round_tube_c_clamp_simple(td=td, cct=cct, ccw=ccw, cca=cca, cctol=cctol, ers=ers);
}


module cclamp_set(
    td=25, // tube diameter
    cct=3, // clamp thickness,
    ccw=5, // clamp width
    cca=280, // clamp arc angle
    cctol=0.5, // inner diameter tolerance
    ers=1.0 // ednding rounding scale
) {
    // using wider thickness for more robustness
    round_tube_2c_clamp_hooks(td=td, cct=cct+1, ccw=ccw, cca=cca, cctol=cctol);

    for (i=[1,2,3,4,5]) {
        fwd(i*(ccod + 2))
        cclamp_2x(td=td, cct=cct, ccw=ccw, cca=cca, cctol=cctol, ers=ers);
    }
}

cclamp_set(td=td, cct=cct, ccw=ccw, cca=cca, cctol=cctol, ers=1.0);
right(2*ccod+10)
    cclamp_set(td=td, cct=cct, ccw=ccw, cca=cca, cctol=cctol, ers=1.0);


