import processing.pdf.*;
float dRadius;
int backgroundGreyLevel = 255;

void setup() {
  size(2000, 2000);
  initializeNeighborPixelArray();

  dRadius = width * 0.04;
  background(backgroundGreyLevel);
  pushMatrix();
  translate(width/2, height * 0.5);
  scale(1, -1);
  strokeWeight(dRadius * 0.2);

  int numberOfRadiusesPerSide = 6;
  float yShift = dRadius * numberOfRadiusesPerSide * 0.5 /sqrt(3) * 1.5;
  drawEllipsesAbout(- dRadius * numberOfRadiusesPerSide * 0.5, - yShift);
  drawEllipsesAbout(dRadius * numberOfRadiusesPerSide * 0.5, - yShift);
  drawEllipsesAbout(0, dRadius * numberOfRadiusesPerSide * sqrt(3) / 2 - yShift);
  //drawEllipsesAbout(0, - (dRadius * numberOfRadiusesPerSide * sqrt(3) / 2 - yShift));
  drawFrame();
  popMatrix();

  EdgeCalculator ec = new EdgeCalculator();
  ec.createEdgeOnlyPDF("ripples.pdf", 72 * 12 );
  ec.sendToDisplay();
}

void drawFrame() {
  rectMode(CENTER);
  strokeWeight(dRadius*4);
  rect(0, 0, width, height);
  stroke(backgroundGreyLevel);
  strokeWeight(dRadius*2);
  rect(0, 0, width, height);
}

void drawEllipsesAbout(float x, float y) {
  noFill();
  stroke(255 - backgroundGreyLevel);
  for (float radius = dRadius; radius < dist(0, 0, width, height); radius += dRadius) {
    float diameter = radius * 2;
    ellipse(x, y, diameter, diameter);
  }
}