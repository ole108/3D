// Razor holder: cap

capMargin = 1;
echo("capMargin:", capMargin);
margin = 1.5;
echo("margin:", margin);

// Global resolution
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm
$fa = 5;    // Don't generate larger angles than 5 degrees

width = 43;    // width of the blade
height = 8.8;  // length of screw (6mm thread + 2.8mm head)
length = 19;   // length inside of the cap (5mm body + 10mm wedge + 2.5mm blade + space)

cap();

module cap() {
  difference() {
    resize([width+2*margin+2*capMargin,length+capMargin,height+2*capMargin])
      block(length-margin);
    translate([0,-capMargin,0]) block(length-margin);
  }
}

module blockPlus() {
}

module block(l) {
  union() {
    cube([width,l,height],true);
    translate([-width/2,l/2,0])
      rotate([0,90,0])
      color("Lime")
      blockSide(width);
    translate([-width/2,l/2,0])
      rotate([90,90,0])
      color("Lime")
      blockSide(l);
    translate([width/2,l/2,0])
      rotate([90,90,0])
      color("Lime")
      blockSide(l);
    translate([width/2,l/2,0])
      blockEdge();
    translate([-width/2,l/2,0])
      blockEdge();
  }
}

module blockSide(size) {
  dist = height-2*margin;
  linear_extrude(height=size, center=false, twist=0)
  hull() {
    translate([+dist/2,0,0]) circle(r=margin);
    translate([-dist/2,0,0]) circle(r=margin);
  }
}

module blockEdge() {
  union() {
    cylinder(h=height-2*margin,r=margin,center=true);
    translate([0,0,(height-2*margin)/2])
      sphere(r=margin);
    translate([0,0,-(height-2*margin)/2])
      sphere(r=margin);
  }
}
