import processing.pdf.*;
float NUDGE = 5;
int numRows = 25;
boolean needsRedraw = true;

void setup() {
  size(2400, 2400, PDF, "puzzleCut"+numRows+'x'+numRows+".pdf");
}

void draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  background(255);
  translate(NUDGE, NUDGE);
  strokeWeight(0.072);
  float sideLength = (width - NUDGE * 2) * 1.0 / numRows;
  for (int row = 0; row < numRows; ++row) {
    for (int col = 0; col < numRows; ++col) {
      float x0 = col * sideLength;
      float y0 = row * sideLength;
      //draw vertical
      if (col > 0) {
        wavy(x0, y0, x0, y0 + sideLength);
      }
      //draw horizontal
      if (row > 0) {
        wavy(x0, y0, x0 + sideLength, y0);
      }
    }
  }
  rect(0, 0, numRows * sideLength, numRows * sideLength);
  exit();
}

float noyz() {
  return 0.1 * (random(1) - 0.5);
}

void wavy(float x0, float y0, float x1, float y1) {
  //assume this vector points right, or down
  pushMatrix();
  translate(x0, y0);
  float side = dist(x0, y0, x1, y1);
  if (abs(x0 - x1) < 1e-3) {
    //reorient so that we can assume going left to right
    rotate(HALF_PI);
  }

  float direction = random(1) < 0.5 ? -1 : 1;
  float neckSize = 0.08;
  float headSize = 0.15;
  noFill();
  beginShape();
  curveVertex(-side * 0.3, 0);
  curveVertex(0, 0);
  curveVertex(side * (0.5 - neckSize + noyz()), direction * side * noyz());
  curveVertex(side * (0.5- headSize + noyz()), direction * side * (0.2 + noyz()));
  curveVertex(side * (0.5 + headSize + noyz()), direction * side * (0.2 + noyz()));
  curveVertex(side * (0.5 + neckSize + noyz()), direction * side * noyz());
  curveVertex(side, 0);
  curveVertex(side * 1.3, 0);
  endShape();
  popMatrix();
}