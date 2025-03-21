// Razor holder: lid

margin = 1.5;
echo("margin:", margin);

// Global resolution
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm
$fa = 5;    // Don't generate larger angles than 5 degrees

width = 43;    // width of the blade
height = 8.8;  // length of screw (6mm thread + 2.8mm head)
stem = 2.5;    // length of stems for half blades
screwW = 10.5; // 10mm + space for rounded edge
screwH = 2.8;  // 2.8mm from Amazon product page
bolt = 5.2;    // 5mm + space
thick = height/2 - screwH;
echo("thickness at screw head:", thick);

// from https://www.badgerandblade.com/forum/wiki/Double-Edge_DE_Razor_Blade_Dimensions_Table
tab = 12.7;      // maximum length of blunt edges standing out to the side
blade = 22;      // maximum length of shorter side of a blade
cutoutLen = 36;  // minimum length of cutout in blades
cutoutWidth = 2; // minimum width of cutout in blades
circ = 5;        // minimum diameter of circle shaped cutouts in blades
mid = tab/2 - 8;


lid();

module lid() {
  difference() {
    base();
    translate([0,mid,0])
      cube([cutoutLen,cutoutWidth,3],center=true); // cutout block base
    translate([0,mid,2])
      linear_extrude(height=1,center=true,scale=0.6)
      square([cutoutLen,cutoutWidth],center=true); // cutout block top
    translate([0, mid,0])
      cylinder(h=3,d=circ,center=true); // cutout circle base
    translate([0,mid,2])
      linear_extrude(height=1,center=true,scale=0.7) // cutout circle top
      circle(d=circ);
  }
}

module base() {
  safeX1 = width/2;           // outermost point of safe cutout
  safeX2 = screwW/2 + margin;   // innermost point of safe cutout
  safeWidth = safeX1 -safeX2; // width of safe cutout
  safeLen = 10 - margin*2;    // length of safe cutout

  difference() {
    baseFull();
    translate([0,0,-5])
      cube([100,50,10],center=true);  // remove lower side
    translate([-width/2,-10,0])
      cube([5,4,height],center=true); // left stem
    translate([width/2,-10,0])
      cube([5,4,height],center=true); // right stem
    translate([0,8.5,0])
      cube([width+2,3,0.4],center=true); // edge protection
    translate([-safeX2-safeWidth/2-1,20-margin-safeLen/2+1,-margin])
      cube([safeWidth+2, safeLen+2, height], center=true); // saving material (1)
    translate([safeX2+safeWidth/2+1,20-margin-safeLen/2+1,-margin])
      cube([safeWidth+2, safeLen+2, height], center=true); // saving material (2)
    translate([0,20,height/4-margin])
      cube([width+2, margin*2, height/2], center=true); // lid rest
    translate([0,blade/2+2,0])
      cylinder(h=height*2,d=bolt,center=true); // bolt
    translate([0,blade/2+2,height/2])
      cylinder(h=screwW,d1=0,d2=screwW*2,center=true); // screw head
  }
}

module baseFull() {
  union() {
    translate([0,10,0])
      block();
    color("Red") wedge();
    translate([0,5,height/2])
      grip();
    translate([0,8,height/2])
      grip();
    translate([0,12,height/2])
      grip();
    translate([0,15,height/2])
      grip();
  }
}

module grip() {
  color("Blue") rotate([0,90,0])
    cylinder(h=width-margin,d=1,center=true);
}

module block() {
  l = 20;
  cube([width,l,height],true);
}

module wedge() {
  union() {
    translate([-width/2,0,0])
      rotate([0,90,0])
      linear_extrude(height=width, center=false, twist=0)
      hull() {
        square([height,0.0001],true);
        translate([0,-9,0]) circle(r=1);
      }
  }
}
