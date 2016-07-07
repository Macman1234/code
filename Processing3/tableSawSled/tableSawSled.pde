import processing.pdf.*;

float DPI = 72;
float backOfFenceToEdge = 3 * DPI;
float backMaxFenceHeight = 6 * DPI;
float backMinFenceHeight = 2.5 * DPI;
float supportInset = 4 * DPI;
float fenceThickness = (1.0 + 13.0/32) / 4.0  * DPI;//using 9mm (~3/8")
float baseThickness = (1.0 + 29.0/32) / 4.0 * DPI;//using 12mm (~1/2")
float MITER_SLOT_OFFSET = 4.25 * DPI;
int NUM_MITER_SCREWS = 6;
float MITER_SCREW_DIAMETER = 0.06 * DPI;
float topInset = 8 * DPI;
float bottomWidth = 35 * DPI;
float topWidth = bottomWidth - 2 * topInset;
float depth = 23 * DPI;
float NUDGE = 0.25 * DPI;
float cornerRadius = backOfFenceToEdge;
float cornerDiam = cornerRadius * 2;

void setup() {
  //35.5" x 23.5", plus brackets
  size(2556, 2800, PDF, "tableSawSled.pdf");
  drawSled();
}

void drawSled() {
  background(255);
  strokeWeight(0.072);
  noFill();

  translate(NUDGE, NUDGE);

  //draw top edge
  arc(topInset + cornerRadius, cornerRadius, cornerDiam, cornerDiam, PI, PI * 1.5);
  arc(topInset + topWidth - cornerRadius, cornerRadius, cornerDiam, cornerDiam, -HALF_PI, 0);
  pushMatrix();
  translate(topInset + cornerRadius, 0);
  line(0, 0, topWidth - 2 * cornerRadius, 0);
  popMatrix();

  //draw bottom edge
  pushMatrix();
  translate(0, depth);
  arc(cornerRadius, -cornerRadius, cornerDiam, cornerDiam, HALF_PI, PI);
  line(cornerRadius, 0, bottomWidth - cornerRadius, 0);
  arc(bottomWidth-cornerRadius, -cornerRadius, cornerDiam, cornerDiam, 0, HALF_PI);
  popMatrix();

  //draw sides
  bezier(topInset, cornerRadius, topInset, depth/2, 0, depth/2, 0, depth - cornerRadius);
  pushMatrix();
  translate(bottomWidth, 0);
  scale(-1, 1);
  bezier(topInset, cornerRadius, topInset, depth/2, 0, depth/2, 0, depth - cornerRadius);
  popMatrix();

  //draw mortises at top
  pushMatrix();
  translate(topInset, cornerRadius);
  drawMortises(topWidth);
  popMatrix();

  //draw mortises at bottom
  pushMatrix();
  translate(0, depth - cornerRadius - fenceThickness);
  drawMortises(bottomWidth);
  popMatrix();

  //draw top support mortises
  drawSupportMortices(topInset + supportInset, cornerRadius, topInset + topWidth - supportInset - fenceThickness, backOfFenceToEdge);

  //draw bottom support mortises
  drawSupportMortices(supportInset, depth, bottomWidth - supportInset - fenceThickness, backOfFenceToEdge);

  //draw miter slot guidelines
  float miterEdge = bottomWidth * 0.5 + MITER_SLOT_OFFSET;
  float miterWidth = 0.75 * DPI;
  line(miterEdge, 0, miterEdge, depth);
  line(miterEdge + miterWidth, 0, miterEdge + miterWidth, depth);
  float y = depth * 0.5 /NUM_MITER_SCREWS;
for(int screwCtr = 0; screwCtr < NUM_MITER_SCREWS; ++screwCtr) {
  ellipse(miterEdge + miterWidth * 0.5, y, MITER_SCREW_DIAMETER, MITER_SCREW_DIAMETER);
  y += depth / NUM_MITER_SCREWS;
}

  //Draw fences
  translate(0, depth + baseThickness + NUDGE);
  drawFence(bottomWidth, 0.5, 0.15);
  translate(0, backMaxFenceHeight + baseThickness + NUDGE);
  drawFence(topWidth, 0.4, 0.2);

  //fence supports
  translate(topWidth + NUDGE, 0);
  for (int supportCtr = 0; supportCtr < 4; ++supportCtr) {
    drawFenceSupport();
    translate(backOfFenceToEdge + baseThickness + NUDGE, 0);
  }
}

void drawFenceSupport() {
  pushMatrix();
  arc(backOfFenceToEdge, 0, 2 * backOfFenceToEdge, 2 * backMinFenceHeight, HALF_PI, PI);
  drawTenons(backOfFenceToEdge);
  translate(backOfFenceToEdge, 0);
  rotate(HALF_PI);
  drawTenons(backMinFenceHeight);
  popMatrix();
}

void drawMortiseFromUpperLeft() {
  rect(0, 0, fenceThickness, fenceThickness);
}

void drawMortises(float fenceWidth) {
  pushMatrix();
  int   numMortises = numberOfMortises(fenceWidth);
  float distanceBetweenMortises = distanceBetweenMortises(fenceWidth);

  translate(distanceBetweenMortises, 0);
  for (int mortCtr = 0; mortCtr < numMortises; ++mortCtr) {
    drawMortiseFromUpperLeft();
    translate(fenceThickness + distanceBetweenMortises, 0);
  }
  popMatrix();
}

void drawSupportMortices(float xLeft, float y, float xRight, float span) {
  pushMatrix();
  translate(xLeft, y);
  rotate(3 * HALF_PI);
  drawMortises(span);
  popMatrix();
  pushMatrix();
  translate(xRight, y);
  rotate(3 * HALF_PI);
  drawMortises(span);
  popMatrix();
}

void drawTenons(float span) {
  float numMortises = numberOfMortises(span);
  float distanceBetweenTenons = distanceBetweenMortises(span);
  
  //...tenons
  beginShape();
  vertex(0, 0);
  float x = 0;
  for (int tenonCtr = 0; tenonCtr < numMortises; ++tenonCtr) {
    vertex(x + distanceBetweenTenons, 0);
    vertex(x + distanceBetweenTenons, -baseThickness);
    vertex(x + distanceBetweenTenons + fenceThickness, -baseThickness);
    vertex(x + distanceBetweenTenons + fenceThickness, 0);
    x += distanceBetweenTenons + fenceThickness;
  }
  vertex(x + distanceBetweenTenons, 0);
  endShape();
}

void drawFence(float fenceWidth, float outerControlPointMultipler, float innerControlPointMultiplier) {
  drawTenons(fenceWidth);
  drawSupportMortices(supportInset, backMinFenceHeight, fenceWidth - supportInset - fenceThickness, backMinFenceHeight);

  //curvy top edge
  arc(cornerRadius, 0, cornerDiam, backMinFenceHeight * 2, HALF_PI, PI);
  arc(fenceWidth-cornerRadius, 0, cornerDiam, backMinFenceHeight * 2, 0, HALF_PI);
  float outerControlPointLength = fenceWidth * outerControlPointMultipler;
  float innerControlPointLength = fenceWidth * innerControlPointMultiplier;
  float midPoint = fenceWidth * 0.5;
  pushMatrix();
  for (int halfCtr = 0; halfCtr < 2; ++halfCtr) {
    bezier(cornerRadius, backMinFenceHeight, cornerRadius + outerControlPointLength, backMinFenceHeight, 
      midPoint - innerControlPointLength, backMaxFenceHeight, midPoint, backMaxFenceHeight);
    translate(fenceWidth, 0);
    scale(-1, 1);
  }
  popMatrix();
}

int numberOfMortises(float span) {
  return(int) (span/ (2 * fenceThickness) - 1);
}

float distanceBetweenMortises(float span) {
  return (span - numberOfMortises(span) * fenceThickness) / (numberOfMortises(span)  + 1);
}