import processing.pdf.*;
float PIXELS_PER_INCH = 72;
float WIDTH = 18;
float HEIGHT = 18;
float HOLE_DIAMETER = 0.4; 
boolean HOLES_ARE_CIRCLES = false;

void setup() {
  size(1296, 1296, PDF, "grillCircleHex_18x18.pdf");//8.5 by 11
  background(255);
  noFill();
  strokeWeight(PIXELS_PER_INCH * 0.001);

  drawOnTriangleGrid();
}

void drawOnSquareGrid() {
  float diameter = HOLE_DIAMETER * PIXELS_PER_INCH;
  float xOffset = diameter * 1.5;
  float yOffset = xOffset;
  float distanceBetweenCenters = HOLE_DIAMETER * 2 * PIXELS_PER_INCH;
  for (int row = 0; row <  11 / HOLE_DIAMETER; ++row) {
    for (int col = 0; col < 8.5 / HOLE_DIAMETER; ++col) {
      float x = xOffset + (col + 0.5 * (row % 2))* distanceBetweenCenters;
      float rowHeightMultiplier = 0.5; //use 0.5 for squares, sqrt(3)/2 for triangles
      float y = yOffset + row * distanceBetweenCenters * rowHeightMultiplier;
      if (x < width - diameter && y < height - diameter) {
        drawHole(x, y, diameter);
      }
    }
  }
}

void drawOnTriangleGrid() {
  float diameter = HOLE_DIAMETER * PIXELS_PER_INCH;
  float xOffset = diameter * 1.5;
  float yOffset = xOffset;
  float separationMultiplier = sqrt(PI / sqrt(3));//equal area inside and outside of circles
  float distanceBetweenCenters = HOLE_DIAMETER * separationMultiplier * PIXELS_PER_INCH;
  float rowHeightMultiplier = sqrt(3)/2; //use 0.5 for squares, sqrt(3)/2 for triangles
  for (int row = 0; row <  HEIGHT / HOLE_DIAMETER; ++row) {
    float y = yOffset + row * distanceBetweenCenters * rowHeightMultiplier;
    for (int col = 0; col < WIDTH / HOLE_DIAMETER; ++col) {
      float x = xOffset + (col + 0.5 * (row % 2))* distanceBetweenCenters;
      if (x < width - xOffset && y < height - diameter) {
        drawHole(x, y, diameter);
      }
    }
  }
}

void drawHole(float x, float y, float diameter) {
  if (HOLES_ARE_CIRCLES) {
    ellipse(x, y, diameter, diameter);
    return;
  }
  //draw a hexagon
  pushMatrix();
  translate(x, y);
  
  noFill();
  float sideLength = diameter * 0.5;
  beginShape();
  vertex(sideLength *sqrt(3) /2, -sideLength / 2);
  vertex(sideLength *sqrt(3) /2, sideLength / 2);
  vertex(0, sideLength );
  vertex(-sideLength *sqrt(3) /2, sideLength / 2);
  vertex(-sideLength *sqrt(3) /2, -sideLength / 2);
  vertex(0, -sideLength );
  vertex(sideLength *sqrt(3) /2, -sideLength / 2);
  endShape();
  popMatrix();
}

//float sideLength = diameter * 0.5;
//translate(sideLength *sqrt(3) /2, sideLength / 2);
//for (int sideCtr = 0; sideCtr < 6; ++sideCtr) {
//  vertex(0, 0);
//  translate(0, sideLength);
//  rotate(PI / 3);
//}