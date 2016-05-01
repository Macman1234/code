import processing.pdf.*;

//TODO
//replace drawTenonsUp with drawTenonsUpAndTranslate everywhere


//parameters
float materialThicknessInInches = 0.375;
float screwDiameterInInches = 0.125;
float shelfWidthInInches = 3;
float shelfDepthInInches = 2;
float backHeightInInches = 2;
int numSupportMortises = 1;
int mortisesBetweenScrewHoles = 2;
float SCALE = 72;

float thickness = materialThicknessInInches * SCALE;
float screwDiameter = screwDiameterInInches * SCALE;
float offset = thickness * 0.1;
float NUDGE = offset;
float mortiseSpacing = thickness;
int numMortisesInBack =  (int) (shelfWidthInInches * SCALE / (thickness + mortiseSpacing));
int numMortisesInShelf =  (int) (shelfDepthInInches * SCALE/ (thickness + mortiseSpacing));
float shelfWidth = numMortisesInBack * (thickness + mortiseSpacing) - mortiseSpacing;
float shelfDepth = numMortisesInShelf * (thickness + mortiseSpacing) + mortiseSpacing;
float backWidth = shelfWidth + 2 * mortiseSpacing;
float backHeight = backHeightInInches * SCALE;
float bracketBack = numSupportMortises * (thickness + mortiseSpacing) + mortiseSpacing;
float shelfBackHeight = backHeight - bracketBack - thickness;
float trimHeight = thickness + 2 * mortiseSpacing;

void setup() {
  size(1200, 1600, PDF, "fcshelf.pdf");
  background(255);
  translate(offset, offset);
  strokeWeight(0.5);
  noFill();

  drawBack();
  translate(mortiseSpacing, backHeight  + thickness + NUDGE);
  drawShelf();

  drawFrontTrim();
  drawSideTrims();

  drawSupportBrackets();
}

String filename() {
  return "fcshelf_"+round(materialThicknessInInches * 1000)+"t_"+round(shelfWidthInInches)+"w_"+round(shelfDepthInInches)+"d.pdf";
}

void drawSideTrims() {
  drawSideTrim();
  pushMatrix();
  translate(2 * (shelfDepth + thickness) + NUDGE, 0);
  scale(-1, 1);
  drawSideTrim();
  popMatrix();
  translate(0, trimHeight + NUDGE);
}  

void drawSideTrim() {
  pushMatrix();
  float sideTrimLength = numMortisesInShelf * ( thickness + mortiseSpacing) +  mortiseSpacing;
  drawLineAndTranslate(sideTrimLength);
  rotate(HALF_PI);
  drawTenonsUpAndTranslate(2, true, true);
  rotate(HALF_PI);
  drawLineAndTranslate(sideTrimLength);
  rotate(HALF_PI);

  drawLineAndTranslate(trimHeight);
  rotate(HALF_PI);
  translate(mortiseSpacing, mortiseSpacing);
  drawMortises(numMortisesInShelf);
  popMatrix();
}

void drawLineAndTranslate(float s) {
  beginShape(); 
  vertex(0, 0);
  vertex(s, 0);
  endShape();
  translate(s, 0);
}

void drawFrontTrim() {
  //outline, drawn ccw
  pushMatrix();
  translate(thickness, 0);
  for (int halfCtr = 0; halfCtr < 2; ++halfCtr) {
    drawLineAndTranslate(shelfWidth);
    rotate(HALF_PI);
    drawTenonsUpAndTranslate(1, false, false);
    rotate(HALF_PI);
  }
  popMatrix();

  //mortises
  pushMatrix();
  translate( mortiseSpacing + thickness, thickness);
  drawMortises(numMortisesInBack - 1);
  popMatrix();
  translate(0, trimHeight + NUDGE);
}

void drawOneMorticeSpaceAndTranslate() {
  beginShape();
  vertex(0, 0);
  vertex(mortiseSpacing, 0);
  endShape();
  translate(mortiseSpacing, 0);
}

void drawSupportBrackets() {
  pushMatrix();
  translate( thickness, thickness);
  drawSupportBracket();
  popMatrix();

  pushMatrix();
  translate(2 * shelfDepth + thickness + NUDGE, thickness);
  scale(-1, 1);
  drawSupportBracket();
  popMatrix();
}

void drawSupportBracket() {
  pushMatrix();
  drawTenonsUpAndTranslate(numMortisesInShelf, false, false);
  //translate(numMortisesInShelf * (thickness + mortiseSpacing) + mortiseSpacing, 0);
  rotate(HALF_PI);
  drawLineAndTranslate(mortiseSpacing);
  popMatrix();

  pushMatrix();
  translate(0, bracketBack);
  rotate(1.5 * PI);
  drawTenonsUp(numSupportMortises, false, false);
  beginShape();
  vertex(0, 0);
  vertex(numSupportMortises*(thickness + mortiseSpacing), shelfDepth);
  endShape();
  popMatrix();
}

void drawShelf() {
  //outline
  pushMatrix();
  drawTenonsUpAndTranslate(numMortisesInBack, true, true);
  rotate(HALF_PI);
  drawTenonsUpAndTranslate(numMortisesInShelf, false, false);
  rotate(HALF_PI);
  drawTenonsUpAndTranslate(numMortisesInBack - 1, false, false);
  rotate(HALF_PI);
  drawTenonsUp(numMortisesInShelf, false, false);
  popMatrix();

  //bracket mortises
  pushMatrix();
  translate(2 * thickness + mortiseSpacing, mortiseSpacing);
  rotate(HALF_PI);
  drawMortises(numMortisesInShelf);
  popMatrix();

  pushMatrix();
  translate(shelfWidth - (thickness + mortiseSpacing), mortiseSpacing);
  rotate(HALF_PI);
  drawMortises(numMortisesInShelf);
  popMatrix();

  translate(-thickness, shelfDepth + thickness + NUDGE);
}

void drawBack() {
  //outline
  beginShape();
  vertex(0, 0);
  vertex(backWidth, 0);
  vertex(backWidth, backHeight - mortiseSpacing); 
  vertex(backWidth - mortiseSpacing, backHeight); 
  vertex(mortiseSpacing, backHeight);  
  vertex(0, backHeight - mortiseSpacing);
  endShape(CLOSE);

  //shelf mortises
  pushMatrix();
  drawScrewHole(backWidth - mortiseSpacing * 0.5, shelfBackHeight + thickness * 0.5);
  translate(mortiseSpacing, shelfBackHeight);
  for (int mortCtr = 0; mortCtr < numMortisesInBack; ++mortCtr) {
    if (mortCtr % mortisesBetweenScrewHoles == 0) {
      drawScrewHole(-mortiseSpacing * 0.5, thickness * 0.5);
    }
    drawMortise();
    translate(thickness+mortiseSpacing, 0);
  }
  popMatrix();

  //bracket mortises
  pushMatrix();
  translate(2 * (mortiseSpacing + thickness), shelfBackHeight + thickness + mortiseSpacing);
  drawBracketMortices();
  popMatrix();

  pushMatrix();
  translate(backWidth - (2 * mortiseSpacing + thickness), shelfBackHeight + thickness + mortiseSpacing);
  drawBracketMortices();
  popMatrix();
}

void drawBracketMortices() {
  rotate(HALF_PI);
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
  ellipse(x, y, screwDiameter, screwDiameter);
}

void  drawMortise() {
  drawMortiseAt(0, 0);
}

void  drawMortiseAt(float x, float y) {
  pushMatrix();
  translate(x, y);
  beginShape();
  vertex(0, 0);
  vertex(thickness, 0);
  vertex(thickness, thickness);
  vertex(0, thickness);
  endShape(CLOSE);
  popMatrix();
}

void  drawTenonsUp(int numTenons, boolean startWithTenon, boolean endWithTenon) {
  beginShape();
  if (!startWithTenon) {
    vertex(0, 0);
  }
  float x = (startWithTenon ? 0 : mortiseSpacing);
  for (int tenonCtr = 0; tenonCtr < numTenons; ++tenonCtr) {
    vertex(x, 0);
    vertex(x, -thickness);
    vertex(x+thickness, -thickness);
    vertex(x+thickness, 0);
    x += (mortiseSpacing + thickness);
  }
  if (!endWithTenon) {
    vertex(x, 0);
  }  
  endShape();
}

void  drawTenonsUpAndTranslate(int numTenons, boolean startWithTenon, boolean endWithTenon) {
  drawTenonsUp(numTenons, startWithTenon, endWithTenon);
  float x = numTenons * (mortiseSpacing + thickness) + (startWithTenon ? -mortiseSpacing : 0) +(endWithTenon ? 0 : mortiseSpacing);
  translate(x, 0);
}


void drawRedDot() {
  stroke(255, 0, 0);
  strokeWeight(2);
  pushMatrix();
  ellipse(0, 0, 10, 10);
  line(0, 0, 20, 0);
  popMatrix();
}