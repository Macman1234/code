import processing.pdf.*;

//TODO
// - provide for mortiseSpacing != thickness
// - account properly for kerf.

//parameters
//For material thickness, measure carefully, 
// then subtract ~0.02 inches to account for kerf.

float materialThicknessInInches = 0.34;
float screwDiameterInInches = 3.0/32;
float shelfWidthInInches = 10;
float shelfDepthInInches = 8;
float shelfBackHeightInInches = 5.5;
int numSupportMortises = 8;
int mortisesBetweenScrewHoles = 3;

PGraphics pdf;
float SCALE = 72;
float thickness = materialThicknessInInches * SCALE;
float screwDiameter = screwDiameterInInches * SCALE;
float offset = thickness * 0.1;
float NUDGE = offset;
float mortiseSpacing = thickness;//this breaks if we use any other value
int numMortisesInBack =  roundUp( (shelfWidthInInches * SCALE + mortiseSpacing)/ (thickness + mortiseSpacing));
int numMortisesInShelf =  roundUp( (shelfDepthInInches * SCALE - mortiseSpacing)/ (thickness + mortiseSpacing));
float shelfWidth = numMortisesInBack * (thickness + mortiseSpacing) - mortiseSpacing;
float shelfDepth = numMortisesInShelf * (thickness + mortiseSpacing) + mortiseSpacing;
float backWidth = shelfWidth + 2 * mortiseSpacing;
float bracketBack = numSupportMortises * (thickness + mortiseSpacing) + mortiseSpacing;
float shelfBackHeight = shelfBackHeightInInches * SCALE;
float backHeight = shelfBackHeight + bracketBack + thickness;
float trimHeight = thickness + 2 * mortiseSpacing;

void setup() {
  size(320, 200);
  int w = (int) (3 * NUDGE + 1 + max(backWidth, 2 * (shelfDepth + thickness)));
  int h = (int) (backHeight + shelfDepth + 3 * thickness + 2 * trimHeight + bracketBack + 6 * NUDGE);
  pdf = createGraphics(w, h, PDF, "pdf/"+filename());
  //setup pdf
  pdf.beginDraw();
  pdf.background(255);
  pdf.translate(offset, offset);
  pdf.strokeWeight(0.072);
  pdf.noFill();

  drawBack();
  drawShelf();
  drawFrontTrim();
  drawSideTrims();
  drawSupportBrackets();

  pdf.dispose();
  pdf.endDraw();
  println("Drawing "+filename()+" complete!");
  exit();
}

String filename() {
  return "fcshelf_"+round(materialThicknessInInches * 1000)+"t_"+round(shelfWidth / SCALE * 100)+"w_"+round(shelfDepth/ SCALE * 100)+"d.pdf";
}

void drawSideTrims() {
  drawSideTrim();
  pdf.pushMatrix();
  pdf.translate(2 * (shelfDepth + thickness) + NUDGE, 0);
  pdf.scale(-1, 1);
  drawSideTrim();
  pdf.popMatrix();
  pdf.translate(0, trimHeight + NUDGE);
}  

void drawSideTrim() {
  pdf.pushMatrix();
  float sideTrimLength = numMortisesInShelf * ( thickness + mortiseSpacing) +  mortiseSpacing;
  drawLineAndTranslate(sideTrimLength);
  pdf.rotate(HALF_PI);
  drawTenonsUpAndTranslate(2, true, true);
  pdf.rotate(HALF_PI);
  drawLineAndTranslate(sideTrimLength);
  pdf.rotate(HALF_PI);

  drawLineAndTranslate(trimHeight);
  pdf.rotate(HALF_PI);
  pdf.translate(mortiseSpacing, mortiseSpacing);
  drawMortises(numMortisesInShelf);
  pdf.popMatrix();
}

void drawLineAndTranslate(float s) {
  pdf.beginShape(); 
  pdf.vertex(0, 0);
  pdf.vertex(s, 0);
  pdf.endShape();
  pdf.translate(s, 0);
}

void drawFrontTrim() {
  //outline, drawn ccw
  pdf.pushMatrix();
  pdf.translate(thickness, 0);
  for (int halfCtr = 0; halfCtr < 2; ++halfCtr) {
    drawLineAndTranslate(shelfWidth);
    pdf.rotate(HALF_PI);
    drawTenonsUpAndTranslate(1, false, false);
    pdf.rotate(HALF_PI);
  }
  pdf.popMatrix();

  //mortises
  pdf.pushMatrix();
  pdf.translate( mortiseSpacing + thickness, thickness);
  drawMortises(numMortisesInBack - 1);
  pdf.popMatrix();
  pdf.translate(0, trimHeight + NUDGE);
}

void drawOneMorticeSpaceAndTranslate() {
  pdf.beginShape();
  pdf.vertex(0, 0);
  pdf.vertex(mortiseSpacing, 0);
  pdf.endShape();
  pdf.translate(mortiseSpacing, 0);
}

void drawSupportBrackets() {
  pdf.pushMatrix();
  pdf.translate( thickness, thickness);
  drawSupportBracket();
  pdf.popMatrix();

  pdf.pushMatrix();
  pdf.translate(2 * shelfDepth + thickness + NUDGE, thickness);
  pdf.scale(-1, 1);
  drawSupportBracket();
  pdf.popMatrix();
}

void drawSupportBracket() {
  pdf.pushMatrix();
  drawTenonsUpAndTranslate(numMortisesInShelf, false, false);
  //translate(numMortisesInShelf * (thickness + mortiseSpacing) + mortiseSpacing, 0);
  pdf.rotate(HALF_PI);
  drawLineAndTranslate(mortiseSpacing);
  pdf.popMatrix();

  pdf.pushMatrix();
  pdf.translate(0, bracketBack);
  pdf.rotate(1.5 * PI);
  drawTenonsUp(numSupportMortises, false, false);
  pdf.beginShape();
  pdf.vertex(0, 0);
  pdf.vertex(numSupportMortises*(thickness + mortiseSpacing), shelfDepth);
  pdf.endShape();
  pdf.popMatrix();
}

void drawShelf() {
  //outline
  pdf.pushMatrix();
  drawTenonsUpAndTranslate(numMortisesInBack, true, true);
  pdf.rotate(HALF_PI);
  drawTenonsUpAndTranslate(numMortisesInShelf, false, false);
  pdf.rotate(HALF_PI);
  drawTenonsUpAndTranslate(numMortisesInBack - 1, false, false);
  pdf.rotate(HALF_PI);
  drawTenonsUp(numMortisesInShelf, false, false);
  pdf.popMatrix();

  //bracket mortises
  pdf.pushMatrix();
  float insetFromEdge = shelfWidth * 0.25;
  pdf.translate(insetFromEdge, mortiseSpacing);
  pdf.rotate(HALF_PI);
  drawMortises(numMortisesInShelf);
  pdf.popMatrix();

  pdf.pushMatrix();
  pdf.translate(shelfWidth - insetFromEdge + thickness, mortiseSpacing);
  pdf.rotate(HALF_PI);
  drawMortises(numMortisesInShelf);
  pdf.popMatrix();

  pdf.translate(-thickness, shelfDepth + thickness + NUDGE);
}

void drawBack() {
  //outline
  pdf.beginShape();
  pdf.vertex(0, 0);
  pdf.vertex(backWidth, 0);
  pdf.vertex(backWidth, backHeight - mortiseSpacing); 
  pdf.vertex(backWidth - mortiseSpacing, backHeight); 
  pdf.vertex(mortiseSpacing, backHeight);  
  pdf.vertex(0, backHeight - mortiseSpacing);
  pdf.endShape(CLOSE);

  //shelf mortises
  pdf.pushMatrix();
  drawScrewHole(backWidth - mortiseSpacing * 0.5, shelfBackHeight + thickness * 0.5);
  pdf.translate(mortiseSpacing, shelfBackHeight);
  for (int mortCtr = 0; mortCtr < numMortisesInBack; ++mortCtr) {
    if (mortCtr % mortisesBetweenScrewHoles == 0) {
      drawScrewHole(-mortiseSpacing * 0.5, thickness * 0.5);
    }
    drawMortise();
    pdf.translate(thickness+mortiseSpacing, 0);
  }
  pdf.popMatrix();

  //bracket mortises
  pdf.pushMatrix();
  float insetFromEdge = backWidth * 0.25;
  pdf.translate(insetFromEdge + thickness * 0.5, shelfBackHeight + thickness + mortiseSpacing);
  drawBracketMortices();
  pdf.popMatrix();

  pdf.pushMatrix();
  pdf.translate(backWidth - insetFromEdge  + thickness * 0.5, shelfBackHeight + thickness + mortiseSpacing);
  drawBracketMortices();
  pdf.popMatrix();

  pdf.translate(mortiseSpacing, backHeight  + thickness + NUDGE);
}

void drawBracketMortices() {
  pdf.rotate(HALF_PI);
  drawMortises(numSupportMortises);
  drawScrewHole(- 0.5 * mortiseSpacing, 0.5 * thickness);
  drawScrewHole(thickness + 0.5 * mortiseSpacing, 0.5 * thickness);
}

void drawMortises(int numMortises) {
  float x = 0;
  for (int mortCtr = 0; mortCtr < numMortises; ++mortCtr) {
    drawMortiseAt(x, 0);
    x += mortiseSpacing  + thickness;
  }
}

void drawScrewHole(float x, float y) {
  pdf.ellipse(x, y, screwDiameter, screwDiameter);
}

void  drawMortise() {
  drawMortiseAt(0, 0);
}

void  drawMortiseAt(float x, float y) {
  pdf.pushMatrix();
  pdf.translate(x, y);
  pdf.beginShape();
  pdf.vertex(0, 0);
  pdf.vertex(thickness, 0);
  pdf.vertex(thickness, thickness);
  pdf.vertex(0, thickness);
  pdf.endShape(CLOSE);
  pdf.popMatrix();
}

void  drawTenonsUp(int numTenons, boolean startWithTenon, boolean endWithTenon) {
  pdf.beginShape();
  if (!startWithTenon) {
    pdf.vertex(0, 0);
  }
  float x = (startWithTenon ? 0 : mortiseSpacing);
  for (int tenonCtr = 0; tenonCtr < numTenons; ++tenonCtr) {
    pdf.vertex(x, 0);
    pdf.vertex(x, -thickness);
    pdf.vertex(x+thickness, -thickness);
    pdf.vertex(x+thickness, 0);
    x += (mortiseSpacing + thickness);
  }
  if (!endWithTenon) {
    pdf.vertex(x, 0);
  }  
  pdf.endShape();
}

void  drawTenonsUpAndTranslate(int numTenons, boolean startWithTenon, boolean endWithTenon) {
  drawTenonsUp(numTenons, startWithTenon, endWithTenon);
  float x = numTenons * (mortiseSpacing + thickness) + (startWithTenon ? -mortiseSpacing : 0) +(endWithTenon ? 0 : mortiseSpacing);
  pdf.translate(x, 0);
}

void drawRedDot() {
  pdf.stroke(255, 0, 0);
  pdf.strokeWeight(2);
  pdf.pushMatrix();
  pdf.ellipse(0, 0, 10, 10);
  pdf.line(0, 0, 20, 0);
  pdf.popMatrix();
}

int roundUp(float x) {
  int intX = (int) x;
  return (x - intX < 0.01) ? intX : intX + 1;
}