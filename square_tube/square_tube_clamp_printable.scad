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

diam=15;
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


// vim: expandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
