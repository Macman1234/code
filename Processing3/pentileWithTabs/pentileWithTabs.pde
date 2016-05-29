import processing.pdf.*;
//THis is all ridiculously bloated because it was a port from JS with 
//minimal rewriting.

int NUMBER_OF_SIDES = 5;
float SCREEN_WIDTH = 800;
float SIDE_LENGTH, ALTITUDE, DIST_TO_VERTEX;

void setup() {
  size(1000,1000, PDF, "pentileWithTabs.pdf");
  SIDE_LENGTH = 1.0;
  ALTITUDE = SIDE_LENGTH / 2 / tan(PI / NUMBER_OF_SIDES);
  DIST_TO_VERTEX = sqrt(ALTITUDE * ALTITUDE + SIDE_LENGTH * SIDE_LENGTH / 4);

  background(255);
  strokeWeight(0.072);
  noFill();

  new Pentagon(0, 0).draw();
}

float toScreenX(float x) {
  return x * screenSideLength() + width * 0.5;
}

float toScreenY(float y) {
  return y * screenSideLength() + height * 0.5;
}

float screenSideLength() {
  return width / SCREEN_WIDTH * 450;
}