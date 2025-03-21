// Razor holder: body

margin = 1.5;
echo(margin=margin);

// Global resolution
$fs = 0.1; // Don't generate smaller facets than 0.1 mm
$fa = 5;   // Don't generate larger angles than 5 degrees

width = 43;    // width of the blade
height = 8.75; // length of screw
stem = 2.5;    // length of stems for half blades
nutW = 8.1;    // 8mm + space
nutH = 2.7;    // 2.7mm from Amazon product page
bolt = 5.1;    // 5mm + space
thick = height/2 - nutH - 0.1;
echo(str("thickness at nut = ", thick));

// from https://www.badgerandblade.com/forum/wiki/Double-Edge_DE_Razor_Blade_Dimensions_Table
tab = 12.7;      // maximum length of blunt edges standing out to the side
blade = 22;      // maximum length of shorter side of a blade
cutoutLen = 36;  // minimum length of cutout in blades
cutoutWidth = 2; // minimum width of cutout in blades
circ = 5;        // minimum diameter of circle shaped cutouts in blades
minW = ceil((height/2-1)/tan(30)*10)/10;
mid = tab/2 - minW+2;
bodyL = 30-minW;
echo(str("minimal wedge = ", minW, "; middle of blade = ", mid+minW, "; gap = ", mid+minW-minW));

body();

module body() {
  difference() {
    union() {
      base();
      bladeCutout();
    }
    translate([0,mid,-height])
      cylinder(h=height*4,d=bolt,center=true); // bolt
    translate([0,mid,-height/2-2+nutH])
      cube([nutW, nutW, 4], center=true); // nut    
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
  w1 = width - 2*stem; // width without stems
  epL = 4; // edge protection: 3mm + 1mm space
  epY2 = mid + blade/2 + 1; // edge protection ends behind blade
  safeY1 = epY2 + 2; // end of edge protection + extra margin
  safeY2 = bodyL - margin; // end saving material for lid rest
  safeLen = safeY2 - safeY1;    // length of safe cutout
  restY1 = -minW + 2;  // end of stems
  restY2 = safeY1 + 1; // start of saving material + overlap

  difference() {
    baseFull();
    translate([0,0,height/2])
      cube([w1,20,height],center=true);  // for edge to stick out
    translate([0,(restY1+restY2)/2,height/2])
      cube([width,restY2-restY1,height],center=true); // for blade rest
    translate([0,epY2-epL/2,0])
      cube([width,epL,0.4],center=true); // for edge protection
    translate([0,bodyL-margin-safeLen/2,-height/2+5+margin])
      cube([width, safeLen, 10], center=true); // for saving material
    translate([0,bodyL-margin,height/2])
      cube([width, margin*2, margin*2], center=true); // lid rest
  }
}

module baseFull() {
  union() {
    translate([0,bodyL/2,0])
      block();
    color("Red") wedge();
    for(i=[bodyL-30+15 : 3 : bodyL-2.5]) {
      translate([0,i,-height/2])
        grip();
    }
  }
}

module block() {
  l = bodyL;
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

module grip() {
  color("Blue") rotate([0,90,0])
    cylinder(h=width-margin,d=1,center=true);
}

module wedge() {
  union() {
    translate([-width/2,0,0])
      rotate([0,90,0])
      linear_extrude(height=width, center=false, twist=0)
      hull() {
        square([height,0.0001],true);
        translate([0,-minW+1,0]) circle(r=1);
      }
    translate([-width/2,0,0])
      wedgeSide();
    translate([width/2,0,0])
      wedgeSide();
  }
}

module wedgeSide() {
  hull() {
    translate([0,margin/PI,+(height/2-margin)])
      sphere(r=margin);
    translate([0,-minW+1,0])
      sphere(r=1);
    translate([0,margin/PI,-(height/2-margin)])
      sphere(r=margin);
  }
}