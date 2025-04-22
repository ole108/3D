// key holder: top + bottom

include <keyholder-base.scad>


halfHolderBottom();

translate([length+5, 0, 0])
  halfHolderTop();


module halfHolderBottom() {
  rotate([0, 180, 0])
  difference() {
    holder();
    translate([0,0,+height/2])
      cube([length*2,width*2,height],true); // cut off upper part
    extrudePin();
  }
}

module extrudePin() {
  union() {
    translate([0,blockL-keyNotchDepth,0]) color("brown")
      cube([pinL,pinDia,keyH+1],center=true);
  }
}

module halfHolderTop() {
  difference() {
    holder();
    translate([0,0,-height/2])
      cube([length*2,width*2,height],true); // cut off lower part
  }
}