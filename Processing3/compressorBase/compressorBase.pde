import processing.pdf.*;

float PIXELS_PER_INCH = 72;
float radiusInInches = 2;
float sideLength = 23 * 0.5 * sqrt(3) * PIXELS_PER_INCH;
float boltDiameter = 7.0 / 16 * PIXELS_PER_INCH;

float radius = radiusInInches * PIXELS_PER_INCH;
float diameter = radius * 2;
float shortestDimension = 24 * PIXELS_PER_INCH;

void setup() {
  size(1728, 1728, PDF, "compressorBase.pdf");
}

void draw() {
  background(255);

  noFill();
  strokeWeight(0.25);
  translate(width * 0.55, height * .55);
  scale(1, -1);
  //rotate(-PI / 12);
  float x = -sideLength / 2;
  float y = -sideLength * sqrt(3)/6;
  for (int sideCtr = 0; sideCtr < 3; ++sideCtr) {
    arc(x, y, diameter, diameter, 5 * PI / 6, 3 *  HALF_PI);
    line(x, y - radius, x + sideLength, y - radius);
    ellipse(x, y, boltDiameter, boltDiameter);
    rotate(TWO_PI / 3);
  }
  ////lower left arc
  //arc(inset + radius, height - inset - radius, diameter, diameter, HALF_PI, 7 * PI / 6);
  // //lower right arc
  //rc(width - (inset + radius), height - inset - radius, diameter, diameter, - PI / 6, HALF_PI);
  // //top arc
  //arc(width * 0.5, height - inset - radius, diameter, diameter, HALF_PI, 7 * PI / 6);

  // Exit the program 
  println("sidelength = " + sideLength / PIXELS_PER_INCH);
  float actualShortestDimension = diameter + sideLength * sqrt(3) / 2 ;
  if (actualShortestDimension > shortestDimension) {
    println("sideLength + diameter = "+actualShortestDimension/PIXELS_PER_INCH+" is too large");
  }
  println("Finished.");
  exit();
}