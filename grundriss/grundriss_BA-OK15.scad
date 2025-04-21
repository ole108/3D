// Grundriss: Obere Königstr. 15, 96052 Bamberg

// Global resolution
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm
$fa = 5;    // Don't generate larger angles than 5 degrees

// Masse der 5 bzw. 6 Schlafzimmer:
r1L = 4000;
r1B = 5000;

r2L = 4000;
r2B = 5000;

r3L = 4000;
r3B = 5000;

r4L = 4000;
r4B = 5000;
r4_1L = 5000;
r4_1B = 2000;
r4_2L = 5000;
r4_2B = 2000;

r5L = 4000;
r5B = 2000;
f5L = 1500;
f5B = 6000;


// Masse der Funktionsräume:
drL = 2000;
drB = 2500;

bad1L = 3000;
bad1B = 2500;
kloL = 1000;
kloB = bad1B;

thL = 5000;
thB = 2000;

bad2L = 3000;
bad2B = 1500;

wkL = 4000;
wkLs = 1000;
wkB = 5000;
wkBs = 1000;


// Sonstige Masse, Farben und Stärken:
tuerL = 1000;
fensterL = 1300;

cSchlafen = "lightBlue";
cWohnen = "lightGreen";
cBad = "yellow";
cArbeiten = "orange";

pen = 40;
boldPen = 120;

//
// Überschrift / Straße, Grundriss und Richtungspfeil:
//
translate([50, 300, 0]) color("black")
  text("Obere Königstraße 15", font = "Noto Sans", size = 500, halign = "left");

grundriss();

translate([8000, -15000, 0]) color("black")
  text(" N", font = "Noto Sans", size = 500, halign = "left");
translate([8000, -15000, 0]) line([0, 1000], [0, -2000]);
translate([8000, -15000, 0]) line([-1000, -1000], [0, -2000]);
translate([8000, -15000, 0]) line([1000, -1000], [0, -2000]);


//
// Grundriss und einzelne Räume
//

module grundriss() {
  translate([0, -r1B, 0]) raum1();
  let (tl = r1L + 50, tb = -r2B) {
    translate([tl, tb, 0]) raum2();
    let (tl = tl + r2L + 50, tb = -r3B) {
      translate([tl, tb, 0]) raum3();
      let (tl = tl, tb = tb - drB - 50) {
        translate([tl + r3L - drL, tb, 0]) durchgangsRaum();
        let (tl = tl, tb = tb - r4B - 50) {
          translate([tl, tb, 0]) raum4();

          line([tl - 3000, tb + 1000], [tl, tb + 1000]);
        }
      }
    }
    let (tl = 0, tb = tb - kloB - 50) {
      translate([tl, tb, 0]) klo();
      translate([tl + kloL + 50, tb, 0]) bad1();
      let (tl = 0, tb = tb - thB - 50) {
        translate([tl, tb, 0]) treppenhaus();

        line([bad2L+1200, tb], [bad2L+1200, tb - bad2B - 100]);
        line([bad2L+1400, tb], [bad2L+1400, tb - bad2B - 100]);
        line([bad2L+1600, tb], [bad2L+1600, tb - bad2B - 510]);
        let (tl = 0, tb = tb - bad2B - 50) {
          translate([tl, tb, 0]) bad2();

          line([0, tb], [0, tb - 1100]);
          let (tl = f5L + 50, tb = tb - wkB - 50) {
            translate([tl, tb, 0]) wohnkueche();
            let (tl = tl, tb = tb - r5B - 50) {
              translate([0, tb, 0]) flur5();
              translate([tl, tb, 0]) raum5();
            }
          }
        }
      }
    }
  }
}

module raum1() {
  rechteckigerRaum(
    r1L, r1B, cSchlafen, "Name 1",
    [[r1L/2, 0, false, false]],
    [[1000, r1B, false], [3000, r1B, false]]
  );
}

module raum2() {
  rechteckigerRaum(
    r2L, r2B, cSchlafen, "Name 2",
    [[r2L/2, 0, false, true]],
    [[1000, r2B, false], [3000, r2B, false]]
  );
}

module raum3() {
  rechteckigerRaum(
    r3L, r3B, cSchlafen, "Name 3",
    [[3000, 0, false, false]],
    [[1000, r3B, false], [3000, r3B, false]]
  );
}

module durchgangsRaum() {
  rechteckigerRaum(
    drL, drB, cArbeiten, "Büro",
    [[0, drB/2, true, false]],
    []
  );
}

module raum4() {
  rechteckigerRaum(
    r4L, r4B, cSchlafen, "Name 4",
    [[3000, r4B, false, false], [0, 3000, true, false]],
    [[1000, 0, false], [3000, 0, false]]
  );
}

module klo() {
  rechteckigerRaum(
    kloL, kloB, cBad, "Klo",
    [],
    []
  );
}

module bad1() {
  rechteckigerRaum(
    bad1L, bad1B, cBad, "Bad 1",
    [[0, bad1B/2, true, true], [bad1L, bad1B/2, true, true]],
    []
  );
}

module treppenhaus() {
  rechteckigerRaum(
    thL, thB, "lightGrey", "Treppenhaus",
    [[thL, thB/2, true, true]],
    []
  );
}

module bad2() {
  rechteckigerRaum(
    bad2L, bad2B, cBad, "Bad 2",
    [[bad2L, bad2B/2, true, true]],
    []
  );
}

module wohnkueche() {
  punkte = [[wkLs, wkB], [wkL, wkB], [wkL, 0], [0, 0], [0, wkB - wkBs]];
  color(cWohnen) polygon(punkte);
  m = len(punkte) - 1;
  for (i = [1 : m]) {
    line(punkte[i-1], punkte[i]);
  }
  line(punkte[m], punkte[0]);

  tuer(wkL/2, wkB, false, true);

  fenster(wkL, 3500, true);
  fenster(wkL, 1500, true);

  translate([wkL/2, wkB/2, 0]) color("black")
    text(
      "Wohnküche",
      font = "Noto Sans", size = 250, halign = "center"
    );
}

module flur5() {
  rechteckigerRaum(
    f5L, f5B, cSchlafen, "Name 5",
    [[f5L/2, f5B, false, true]],
    [[0, 2000, true], [0, 4500, true]]
  );
}

module raum5() {
  rechteckigerRaum(
    r5L, r5B, cSchlafen, "Name 5",
    [[0, r5B/2, true, true]],
    [[r5L, r5B/2, true]]
  );
}


//
// Hilfsmodule
//

// l: Länge des Raumes
// b: Breite des Raumes
// c: Farbe (color)
// ts: [tuer1, ..., tuerN]
// fs: [fenster1, ..., fensterN]
// tuerI: [offsetLänge, offsetBreite, hochkant, öffnendNachRechts]
// fensterI: [offsetLänge, offsetBreite, hochkant]
module rechteckigerRaum(l, b, c, name, ts, fs) {
  color(c) square([l, b], center = false);

  color("black") square([l, pen], center = false);
  color("black") square([pen, b], center = false);
  color("black") translate([0, b - pen,  0]) square([l, pen], center = false);
  color("black") translate([l - pen, 0, 0]) square([pen, b], center = false);

  for (t = ts) {
    tuer(t.x, t.y, t[2], t[3]);
  }
  for (f = fs) {
    fenster(f.x, f.y, f[2]);
  }
  
  beschriftung(l, b, name);
}

module tuer(offL, offB, hoch, rechts) {
  if (hoch) {
    color("black") translate([offL, offB,  0])
      square([boldPen, tuerL], center = true);  
    color("black") translate([offL, offB-tuerL/2,  0])
      rotate([0, 0, rechts?-45:45])
      square([pen, tuerL], center = false);  
  } else {
    color("black") translate([offL, offB,  0])
      square([tuerL, boldPen], center = true);
    color("black") translate([offL-tuerL/2, offB,  0]) rotate([0, 0, rechts?-45:45])
      square([tuerL, pen], center = false);
  }
}

module fenster(offL, offB, hoch) {
    color("black") translate([offL, offB,  0])
      square([hoch?boldPen:fensterL, hoch?fensterL:boldPen], center = true);  
}

module beschriftung(l, b, name) {
  if (l >= 4000) {
    translate([l/2, b/2, 0]) color("black")
      text(
        str((l/1000) * (b/1000), " m\u00b2 ", name),
        font = "Noto Sans", size = 250, halign = "center"
      );
  } else { 
    translate([l/2, b/2 + 200, 0]) color("black")
      text(
        str((l/1000) * (b/1000), (l >= 1500) ? " m\u00b2": "m\u00b2"),
        font = "Noto Sans", size = 250, halign = "center"
      );
    translate([l/2, b/2 - 200, 0]) color("black")
      text(
        name,
        font = "Noto Sans", size = 250, halign = "center"
      );
  }
}

module line(p1, p2, thick = pen) {
  df = thick/2;
  if (abs(p1.x - p2.x) <= thick) {
    color("black") polygon([
      [p1.x-df, p1.y],
      [p1.x+df, p1.y],
      [p2.x+df, p2.y],
      [p2.x-df, p2.y]
    ]);
  } else if (abs(p1.y - p2.y) <= thick) {
    color("black") polygon([
      [p1.x, p1.y-df],
      [p1.x, p1.y+df],
      [p2.x, p2.y+df],
      [p2.x, p2.y-df]
    ]);
  } else {
    q1 = p1.x < p2.x ? p1 : p2;
    q2 = p1.x < p2.x ? p2 : p1;
    if (q1.y < q2.y) {
      color("black") polygon([
        [q1.x-df, q1.y],
        [q1.x+df, q1.y-df],
        [q2.x+df, q2.y],
        [q2.x-df, q2.y+df]
      ]);
    } else {
      color("black") polygon([
        [q1.x-df, q1.y],
        [q1.x+df, q1.y+df],
        [q2.x+df, q2.y],
        [q2.x-df, q2.y-df]
      ]);
    }
  }
}