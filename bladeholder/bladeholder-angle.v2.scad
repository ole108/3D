// Razor holder: angle

thick = 2;       // thickness of material
length = 40;     // length of the whole angle
base = 10+thick; // width of the base
height = length*tan(30); // height of the angle (without base)

angle();

module angle() {
  union() {
    base();
    color("Red") translate([0,0,thick/2])
      wedge();
  }
}

module wedge() {
  rotate([0,-90,0])
    linear_extrude(height=thick,center=true)
    polygon([[0,-length/2],[0,length/2],[height,length/2]]);
}

module base() {
  cube([base,length,thick],center=true);
}