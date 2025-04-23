// key holder: base file

// Global resolution
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm
$fa = 5;    // Don't generate larger angles than 5 degrees

keyH = 2.3;
keyW = 6.1;
keyL = 7;
keyNotchDia = 2;
keyNotchDepth = 3;

pinL = 20;
pinDia = keyNotchDia;

screwDia = 5;      // 5mm screw
screwW = 10.5; // 10mm + rounded edge
screwLOff = 3;
screwWOff = 7.5;
nutW = 8.1;    // 8mm + space
nutH = 2.7;    // 2.7mm from Amazon product page

length = 30;
width = screwW*2 + 5;    // width of the grip
height = 8.1;  // length of screw (8mm) + rounded edge

margin = 2;
holeDia = 10;      // diameter of cut out
wedgeL = 15;
blockL = length - wedgeL;


//holder();

module holder() {
  difference() {
    base();
    translate([screwWOff,blockL-screwW/2-screwLOff,0])
      screw();
    translate([-screwWOff,blockL-screwW/2-screwLOff,0])
      screw();
    translate([0,blockL,0])
      pinKey();
  }
}



// -------------------------------------------------------------
// S C R E W
// -------------------------------------------------------------
module screw() {
  union() {
    translate([0,0,0])
      cylinder(h=height*2,d=screwDia,center=true); // screw bolt
    translate([0,0,height/2])
      cylinder(h=screwW,d1=0,d2=screwW*2,center=true); // screw head
    translate([0,0,-height/2])
      cube([nutW,nutW,nutH*2],center=true);          // screw nut
  }
}



// -------------------------------------------------------------
// K E Y   +   N A I L 
// -------------------------------------------------------------

module pinKey() {
  union() {
    color("yellow") cube([keyW, keyL*2, keyH],true);
    translate([0,-keyNotchDepth,-keyH/2-pinDia/4]) pin();
  }
}
module pin() {
  color("black")
    rotate([0,90,0])
    union() {
      cylinder(h=pinL,d=pinDia,center=true);
    }
}

// -------------------------------------------------------------
// B A S E
// -------------------------------------------------------------

module base() {
  difference() {
    baseFull();
    translate([0,-wedgeL+3+holeDia/2,0])
      cylinder(h=height*2,d=holeDia,center=true);
  }
}

module baseFull() {
  l = blockL-margin;
  union() {
    translate([0,l/2,0])
      block();
    color("Red") wedge();
    for(i=[1 : 2.5 : l-0.5]) {
      translate([0,i,-height/2])
        grip();
      translate([0,i,+height/2])
        grip();
    }
  }
}

module block() {
  l = blockL-margin;
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
    union() {
      translate([0,0,width/2-margin/2])
        sphere(d=1);
      cylinder(h=width-margin,d=1,center=true);
      translate([0,0,-width/2+margin/2])
        sphere(d=1);
    }
}

module wedge() {
  l = wedgeL-margin/2;
  union() {
    translate([-width/2,0,0])
      rotate([0,90,0])
      linear_extrude(height=width, center=false, twist=0)
      hull() {
        square([height,0.0001],true);
        translate([0,-l,0]) circle(d=margin);
      }
    translate([-width/2,0,0])
      wedgeSide(l);
    translate([width/2,0,0])
      wedgeSide(l);
  }
}

module wedgeSide(l) {
  hull() {
    translate([0,margin/PI/2,+(height/2-margin)])
      sphere(r=margin);
    translate([0,-l,0])
      sphere(d=margin);
    translate([0,margin/PI/2,-(height/2-margin)])
      sphere(r=margin);
  }
}