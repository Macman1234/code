import processing.pdf.*;

PGraphics pdf;

void setup() {
  size(800, 800);
  background(255);
  int numSides = 4;
  pdf = createGraphics(width, height, PDF, "polygon"+numSides+".pdf");
  pdf.beginDraw();
  drawPolygon(numSides);
  
  pdf.dispose();
  pdf.endDraw();
  exit();
}

void drawPolygon(int numSides) {

  pdf.translate(width * 0.5, height * 0.5);
  pdf.rotate(-HALF_PI/2);
  float scale_ = width * 0.495;
  pdf.scale(scale_, scale_);
  pdf.strokeWeight(0.072 / scale_);
  pdf.beginShape();
  for (int sideCtr = 0; sideCtr < numSides; ++sideCtr) {
    float angle = sideCtr * TWO_PI / numSides;
    pdf.vertex(cos(angle), sin(angle));
  }
  pdf.endShape(CLOSE);
}