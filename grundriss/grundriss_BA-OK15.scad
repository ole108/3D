// Grundriss: Obere Königstr. 15, 96052 Bamberg

// Global resolution
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm
$fa = 5;    // Don't generate larger angles than 5 degrees

// Masse der 5 bzw. 6 Schlafzimmer:
r1L = 3900;
r1B = 5600;

r2L = 3600;
r2B = 5700;

r3L = 4000;
r3B = 5200;

// r4L = 4960;
// r4B = 4100;
r4_1L = 2430;
r4_1B = 4100;
r4_2L = 2430;
r4_2B = 4100;

r5L = 4340;
r5B = 1950;
f5L = 1300;
f5B = 5130;


// Masse der Funktionsräume:
drL = 2170;
drB = 2410;

bad1L = 2900;
bad1B = 2200;
kloL = 1170;
kloB = 2800;

thL = 5000;
thB = 2000;

bad2L = 2000;
bad2B = 1300;

wkL = 4300;
wkLs = 900;
wkB = 5300;
wkBs = 850;


// Sonstige Masse, Farben und Stärken:
tuerL = 1000;
fensterL = 1100;

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
  text(
    "Obere Königstraße 15",
    font = "Noto Sans",
    size = 500,
    halign = "left"
  );

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
  let (tl = r1L + 50, tb = -r2B - 400) {
    translate([tl, tb, 0]) raum2();
    let (tl = tl + r2L + 50, tb = -r3B - 800) {
      translate([tl, tb, 0]) raum3();
      color("red") line([0, 200], [tl + r3L, tb + r3B - 200]); // Aussenwand
      let (tl = tl + r3L, tb = tb - drB - 50) {
        translate([tl - drL, tb, 0]) durchgangsRaum();
        let (tl = tl-r4_1L, tb = tb - r4_1B - 50) {
          translate([tl, tb, 0]) raum4_1();
          let (tl = tl - r4_2L - 100, tb = tb) {
            translate([tl, tb, 0]) raum4_2();

            line([tl - 10500, tb], [tl, tb]); // Raum4 - Bad2
            line([0, tb], [0, tb+2200]); // Turm - Treppenhaus
          }
        }
      }
    }
    let (tl = 0, tb = -r1B - kloB - 50) {
      translate([tl, tb, 0]) klo();
      translate([tl + kloL + 50, tb, 0]) bad1();
      let (tl = 0, tb = tb - thB - 50) {
        translate([tl, tb, 0]) treppenhaus();
        let (tl = -5650, tb = tb - 2080) {
          translate([0, tb-1500, 0]) turm();

          // 3 Stufen:
          line([tl+bad2L+2200, tb], [tl+bad2L+2200, tb-bad2B-100]);
          line([tl+bad2L+2400, tb], [tl+bad2L+2400, tb-bad2B-100]);
          line([tl+bad2L+2600, tb], [tl+bad2L+2600, tb-bad2B-100]);
          let (tl = tl, tb = tb - bad2B - 50) {
            translate([tl, tb, 0]) bad2();

            line([tl, tb], [tl, tb - 2300]); // Bad2 - Flur5
            let (tl = tl + f5L + 50, tb = tb - wkB - 50) {
              translate([tl, tb, 0]) wohnkueche();
              let (tl = tl, tb = tb - r5B - 50) {
                translate([tl - f5L - 50, tb, 0]) flur5();
                translate([tl, tb, 0]) raum5();
              }
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
    [[2280, 0, false, false]],
    [[1000, r1B, false], [3000, r1B, false]]
  );
}

module raum2() {
  rechteckigerRaum(
    r2L, r2B, cSchlafen, "Xiaotong",
    [[1530, 0, false, true]],
    [[1000, r2B, false], [2800, r2B, false]]
  );
}

module raum3() {
  rechteckigerRaum(
    r3L, r3B, cSchlafen, "Hartmut",
    [[2700, 0, false, false]],
    [[1000, r3B, false], [3000, r3B, false]]
  );
}

module durchgangsRaum() {
  rechteckigerRaum(
    drL, drB, cArbeiten, "Büro",
    [[0, 1430, true, false]],
    []
  );
}

module raum4_1() {
  rechteckigerRaum(
    r4_1L, r4_1B, cSchlafen, "Name 4_1",
    [[1630, r4_1B, false, false]],
    [[1000, 0, false]]
  );
}

module raum4_2() {
  rechteckigerRaum(
    r4_2L, r4_2B, cSchlafen, "Name 4_2",
    [[0, 2070, true, false]],
    [[1000, 0, false]]
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
    [[0, 1320, true, true], [bad1L, 1660, true, true]],
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

module turm() {
  rechteckigerRaum(
    1800, 1500, cArbeiten, "Turm",
    [],
    []
  );
}

module bad2() {
  rechteckigerRaum(
    bad2L, bad2B, cBad, "Bad 2",
    [[1200, 0, false, true]],
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

  translate([0, 1920, 0])
    color("black") square([620, 770], false);

  line([0, 1920], [wkL, 1920]);

  tuer(wkL/2, wkB, false, true);

  fenster(wkL, wkB-1950, true);
  fenster(wkL, 900, true);

  translate([wkL/2, wkB/2, 0]) color("black")
    text(
      "Wohnküche",
      font = "Noto Sans", size = 250, halign = "center"
    );
}

module flur5() {
  rechteckigerRaum(
    f5L, f5B, cSchlafen, "Ole",
    [[550, f5B, false, false]],
    [[0, 2000, true], [0, 5800, true]]
  );
}

module raum5() {
  rechteckigerRaum(
    r5L, r5B, cSchlafen, "Ole",
    [[0, 1350, true, true]],
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
  color("black") translate([0, b - pen,  0])
    square([l, pen], center = false);
  color("black") translate([l - pen, 0, 0])
    square([pen, b], center = false);

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
    color("black") translate([offL-tuerL/2, offB,  0])
      rotate([0, 0, rechts?-45:45])
      square([tuerL, pen], center = false);
  }
}

module fenster(offL, offB, hoch) {
    color("black") translate([offL, offB,  0])
      square([
        hoch?boldPen:fensterL,
        hoch?fensterL:boldPen
      ], center = true);  
}

module beschriftung(l, b, name) {
  if (l >= 4000) {
    translate([l/2, b/2, 0]) color("black")
      text(
        str(oneDecimal((l/1000) * (b/1000)), " m\u00b2 ", name),
        font = "Noto Sans", size = 250, halign = "center"
      );
  } else { 
    translate([l/2, b/2 + 200, 0]) color("black")
      text(
        str(
          oneDecimal((l/1000) * (b/1000)),
          (l >= 1500) ? " m\u00b2": "m\u00b2"
        ),
        font = "Noto Sans",
        size = 250,
        halign = "center"
      );
    translate([l/2, b/2 - 200, 0]) color("black")
      text(
        name,
        font = "Noto Sans",
        size = 250,
        halign = "center"
      );
  }
}

function oneDecimal(f) =
  round(f * 10)/10;

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