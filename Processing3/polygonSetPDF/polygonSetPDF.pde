import processing.pdf.*;

PGraphics pdf;
float sideLengthInPixels = 72;

void setup() {
  size(400, 1000);
  background(255);
  pdf = createGraphics(width, height, PDF, "polygonSet.pdf");
  pdf.beginDraw();
  pdf.strokeWeight(0.072 );

  int sides[] = {3, 4, 6, 8, 12};
  pdf.translate(sideLengthInPixels, sideLengthInPixels);
  for (int numSidesIndex = 0; numSidesIndex < sides.length; ++numSidesIndex) {
    int numSides = sides[numSidesIndex];
    drawPolygon(numSides);
    if (numSidesIndex < sides.length - 1) { 
      pdf.translate(radius(sides[numSidesIndex + 1]) - radius(numSides), 2.5 * radius(numSides));
    }
  }

  pdf.dispose();
  pdf.endDraw();
  exit();
}

float radius(int numSides) {
  return sideLengthInPixels /2/ sin(PI/numSides);
}

void drawPolygon(int numSides) {
  pdf.pushMatrix();
  pdf.rotate(PI / numSides);
  pdf.beginShape();
  float r =  radius(numSides);
  for (int sideCtr = 0; sideCtr < numSides; ++sideCtr) {
    float angle = sideCtr * TWO_PI / numSides;
    pdf.vertex(r * cos(angle), r *  sin(angle));
  }
  pdf.endShape(CLOSE);
  pdf.popMatrix();
}