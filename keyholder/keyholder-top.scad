// key holder: top

include <keyholder-base.scad>


halfHolder();

module halfHolder() {
  difference() {
    holder();
    translate([0,0,-height/2])
      cube([length*2,width*2,height],true); // cut off lower part
  }
}