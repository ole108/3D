// Razor holder: lid

margin = 1.5;
echo("margin:", margin);

// Global resolution
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm
$fa = 5;    // Don't generate larger angles than 5 degrees

width = 43;    // width of the blade
height = 8.75;    // length of screw
stem = 2.5;    // length of stems for half blades
screwW = 9.5;  // 9.5mm max
screwH = 2.75; // 2.8mm from Amazon product page
bolt = 5.1;    // 5mm + space
thick = height/2 - screwH;
echo("thickness at screw head:", thick);

// from https://www.badgerandblade.com/forum/wiki/Double-Edge_DE_Razor_Blade_Dimensions_Table
tab = 12.7;      // maximum length of blunt edges standing out to the side
blade = 22;      // maximum length of shorter side of a blade
cutoutLen = 36;  // minimum length of cutout in blades
cutoutWidth = 2; // minimum width of cutout in blades
minW = ceil((height/2-1)/tan(30)*10)/10;
mid = tab/2 - minW+2;
bodyL = 30-minW;
echo(str("minimal wedge = ", minW, "; middle of blade = ", mid+minW));
gap = (mid + minW) - minW;
echo(str("gap = ", gap, "; overlap with screw head = ", screwW/2 - gap));

lid();

module lid() {
  difference() {
    base();
    union() {
      bladeCutout();
      translate([0,mid,0])
        cylinder(h=height*4,d=bolt,center=true); // bolt
      translate([0,mid,height/2])
        cylinder(h=screwH*2,d=screwW,center=true); // screw head
    }
  }
}

module bladeCutout() {
  baseH = 2.25 - cutoutWidth/2;
  union() {
    translate([0,mid,0])
      cube([cutoutLen-cutoutWidth,cutoutWidth,baseH],center=true); // cutout block base
    translate([-cutoutLen/2+cutoutWidth/2,mid,0])
      cylinder(h=baseH,d=cutoutWidth,center=true);  // cutout block base edge
    translate([+cutoutLen/2-cutoutWidth/2,mid,0])
      cylinder(h=baseH,d=cutoutWidth,center=true);  // cutout block base edge
    translate([0,mid,baseH/2])
      rotate([0,90,0])
      cylinder(h=cutoutLen-cutoutWidth,d=cutoutWidth,center=true); // cutout block top
    translate([-cutoutLen/2+cutoutWidth/2,mid,baseH/2]) // cutout block top edge
      sphere(d=cutoutWidth);
    translate([+cutoutLen/2-cutoutWidth/2,mid,baseH/2]) // cutout block top edge
      sphere(d=cutoutWidth);
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
    translate([0,20-margin-safeLen/2+4,-margin])
      cube([width+2, safeLen+8, height], center=true); // saving material
  }
}

module baseFull() {
  union() {
    translate([0,bodyL/2,0])
      block();
    color("Red") wedge();
    for(i=[bodyL-30+15 : 3 : bodyL-2.5]) {
      translate([0,i,+height/2])
        grip();
    }
  }
}

module grip() {
  color("Blue") rotate([0,90,0])
    cylinder(h=width-margin,d=1,center=true);
}

module block() {
  l = bodyL;
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
