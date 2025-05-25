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

use <square_tube_clamp.scad>

diam=15;
len=30;
tol=1;
dil=2;

// square tube assembly visualization
difference() {
    all_assembly(d=diam, l=len, dil=dil, tol=tol);
    fwd(diam/2+get_screw_y(d=diam, l=len)) cuboid([2*diam,diam,2*len]);
}

