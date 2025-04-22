// key holder: top

include <keyholder-base.scad>


halfHolderTop();

module halfHolderTop() {
  difference() {
    holder();
    translate([0,0,-height/2])
      cube([length*2,width*2,height],true); // cut off lower part
  }
}