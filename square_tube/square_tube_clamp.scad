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


difference() {
union() {
cuboid([17.5,35,100], rounding=2, anchor=RIGHT);
diff()
cuboid([6,56,100], rounding=2, anchor=RIGHT)
attach(LEFT) {
fwd(44) right( 22.5) screw_hole("M4x1,4",head="socket",counterbore=true,anchor="top");
fwd(44) left(  22.5) screw_hole("M4x1,4",head="socket",counterbore=true,anchor="top");
back(44) right(22.5) screw_hole("M4x1,4",head="socket",counterbore=true,anchor="top");
back(44) left( 22.5) screw_hole("M4x1,4",head="socket",counterbore=true,anchor="top");
}
}
right(0.5) cuboid([14,27,101], anchor=RIGHT);
}

// vim: expandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
