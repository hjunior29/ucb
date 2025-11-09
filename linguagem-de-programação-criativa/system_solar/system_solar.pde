ArrayList<Planet> planets;
Starfield stars;
float zoom = 1.0;
boolean trails = true;
float t = 0;

void setup() {
  size(1024, 768, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  smooth(4);
  initSystem();
}

void draw() {
  if (!trails) {
    background(220, 20, 5);     // deep space
    stars.draw();
  } else {
    noStroke();
    fill(220, 20, 5, 12);       // translucent veil for motion trails
    rect(0, 0, width, height);
    stars.twinkle();
  }

  translate(width/2f, height/2f);
  scale(zoom);

  // sun glow
  noStroke();
  for (int i = 20; i >= 1; i--) {
    float a = map(i, 20, 1, 2, 90);
    fill(45, 100, 100, a);
    ellipse(0, 0, i*3, i*3);
  }
  fill(45, 100, 100);
  ellipse(0, 0, 20, 20);  


  // orbits
  stroke(0, 0, 100, 10);
  noFill();
  for (Planet p : planets) {
    ellipse(0, 0, p.orbit*2, p.orbit*2);
  }

  // update+draw planets
  t += 1/60.0;
  for (Planet p : planets) p.updateAndDraw();
}

void keyPressed() {
  if (key == ' ') trails = !trails;
  if (key == 'r' || key == 'R') initSystem();
  if (key == 's' || key == 'S') saveFrame("planet_orbits-####.png");
  if (key == '+' || key == '=') zoom = min(2.5, zoom * 1.1);
  if (key == '-' || key == '_') zoom = max(0.4, zoom / 1.1);
}

void initSystem() {
  background(220, 20, 5);
  stars = new Starfield(160);
  planets = new ArrayList<Planet>();

  // orbit, size, speed, hue, hasRing
  planets.add(new Planet( 70,  8,  0.020,  15, false)); // Mercury-like
  planets.add(new Planet(110, 12,  0.016,  35, false)); // Venus-like
  Planet earth = new Planet(160, 12, 0.013, 200, false);
  earth.addMoon(22, 4, 0.07, 210);
  planets.add(earth);

  Planet mars = new Planet(210, 10, 0.011, 10, false);
  mars.addMoon(15, 3, 0.09, 20);
  planets.add(mars);

  planets.add(new Planet(280, 22, 0.008, 45, true));  // Saturn-like (ring)
  planets.add(new Planet(360, 18, 0.006, 190, false));// Uranus-like
}

class Planet {
  float orbit;   // orbit radius
  float size;    // planet diameter
  float speed;   // angular speed
  float hue;
  boolean ring;

  float ang;     // current angle
  ArrayList<Moon> moons;

  Planet(float orbit, float size, float speed, float hue, boolean ring) {
    this.orbit = orbit;
    this.size = size;
    this.speed = speed;
    this.hue = hue;
    this.ring = ring;
    this.ang = random(TWO_PI);
    this.moons = new ArrayList<Moon>();
  }

  void addMoon(float orbit, float size, float speed, float hue) {
    moons.add(new Moon(orbit, size, speed, hue));
  }

  void updateAndDraw() {
    ang += speed;
    float x = cos(ang) * orbit;
    float y = sin(ang) * orbit;

    pushMatrix();
    translate(x, y);

    // planet body
    noStroke();
    fill(hue, 80, 95);
    ellipse(0, 0, size, size);

    // simple specular highlight
    fill(0, 0, 100, 60);
    ellipse(-size*0.18, -size*0.18, size*0.35, size*0.35);

    // ring if any
    if (ring) {
      noFill();
      stroke(hue, 40, 95, 80);
      strokeWeight(2);
      pushMatrix();
      rotate(PI/6);
      ellipse(0, 0, size*2.4, size*0.9);
      popMatrix();
      strokeWeight(1);
    }

    // moons
    for (Moon m : moons) m.updateAndDraw();

    popMatrix();
  }
}

class Moon {
  float orbit, size, speed, hue;
  float ang;

  Moon(float orbit, float size, float speed, float hue) {
    this.orbit = orbit;
    this.size = size;
    this.speed = speed;
    this.hue = hue;
    this.ang = random(TWO_PI);
  }

  void updateAndDraw() {
    ang += speed;
    float x = cos(ang) * orbit;
    float y = sin(ang) * orbit;

    // orbit path
    stroke(0, 0, 100, 20);
    noFill();
    ellipse(0, 0, orbit*2, orbit*2);

    // body
    noStroke();
    fill(hue, 20, 90);
    ellipse(x, y, size, size);
  }
}

class Starfield {
  PVector[] pts;
  float[] a;

  Starfield(int n) {
    pts = new PVector[n];
    a = new float[n];
    for (int i = 0; i < n; i++) {
      pts[i] = new PVector(random(width), random(height));
      a[i] = random(40, 100);
    }
  }

  void draw() {
    noStroke();
    for (int i = 0; i < pts.length; i++) {
      fill(0, 0, 100, a[i]);
      rect(pts[i].x, pts[i].y, 2, 2);
    }
  }

  void twinkle() {
    // light twinkle when trails on
    noStroke();
    for (int i = 0; i < pts.length; i++) {
      a[i] += sin(frameCount*0.05 + i)*0.2;
      a[i] = constrain(a[i], 30, 100);
      fill(0, 0, 100, a[i]);
      rect(pts[i].x, pts[i].y, 2, 2);
    }
  }
}
