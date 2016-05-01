import processing.pdf.*;

//TODO
//replace drawTenonsUp with drawTenonsUpAndTranslate everywhere


//parameters
float materialThicknessInInches = 0.375;
float screwDiameterInInches = 0.125;
float shelfWidthInInches = 8;
float shelfDepthInInches = 3;
float backHeightInInches = 5;
int numSupportMortises = 2;
int mortisesBetweenScrewHoles = 3;
float SCALE = 72;

//
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
float trimHeight = 2 * (thickness + mortiseSpacing);

void setup() {
  size(1000, 1000);
  background(255);
  translate(offset, offset);
  strokeWeight(0.5);
  noFill();

  drawBack();
  translate(mortiseSpacing, backHeight  + thickness + NUDGE);
  drawShelf();

  translate(-thickness, shelfDepth + thickness + NUDGE);
  drawFrontTrim();
  drawSideTrims();

  drawRedDot();
  //drawSupportBrackets();
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
  drawTenonsUpAndTranslate(2, true, false);
  rotate(HALF_PI);
  drawLineAndTranslate(sideTrimLength);
  rotate(HALF_PI);

  drawLineAndTranslate(2 * ( thickness + mortiseSpacing));
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
  rotate(HALF_PI);
  drawOneMorticeSpaceAndTranslate();
  drawTenonsUp(1, false, false);
  translate(2 * mortiseSpacing + thickness, 0);
  rotate(-HALF_PI);
  drawLineAndTranslate(2 * thickness + mortiseSpacing);

  drawTenonsUp(1, true, true);
  beginShape();
  vertex(thickness, 0);
  vertex(backWidth - 4 * (thickness + mortiseSpacing), 0);
  endShape();
  translate(backWidth - 4 * (thickness  + mortiseSpacing), 0);
  drawTenonsUp(1, false, false);
  translate(2 * mortiseSpacing + thickness, 0);
  beginShape();
  vertex(0, 0);
  vertex(mortiseSpacing + thickness, 0);
  endShape();
  translate(mortiseSpacing + thickness, 0);
  rotate(-HALF_PI);
  drawTenonsUp(1, false, false);
  translate(2 * mortiseSpacing + thickness, 0);
  drawOneMorticeSpaceAndTranslate();
  rotate(-HALF_PI);
  beginShape();
  vertex(0, 0);
  vertex(backWidth, 0);
  endShape();
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
  translate(shelfWidth + (thickness + mortiseSpacing)+ NUDGE, 0);
  drawSupportBracket();
  translate(shelfDepth, bracketBack + (thickness + mortiseSpacing)+ NUDGE);
  rotate(PI);
  drawSupportBracket();
  popMatrix();
}

void drawSupportBracket() {
  pushMatrix();
  drawTenonsUp(numMortisesInShelf, false, false);
  translate(numMortisesInShelf * (thickness + mortiseSpacing) + mortiseSpacing, 0);
  rotate(HALF_PI);
  drawTenonsUp(1, false, true);
  popMatrix();

  pushMatrix();
  translate(0, bracketBack);
  rotate(1.5 * PI);
  drawTenonsUp(numSupportMortises, false, false);
  beginShape();
  vertex(0, 0);
  vertex((numSupportMortises - 1)*(thickness + mortiseSpacing)+mortiseSpacing
    , shelfDepth);
  endShape();
  popMatrix();
}

void drawShelf() {
  //outline
  pushMatrix();
  drawTenonsUp(numMortisesInBack, true, true);
  translate(shelfWidth, 0);
  rotate(HALF_PI);
  drawTenonsUp(numMortisesInShelf, false, false);
  translate(shelfDepth, 0);
  rotate(HALF_PI);
  drawTenonsUp(numMortisesInBack - 1, false, false);
  translate(shelfWidth, 0);
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
  translate(numTenons * (mortiseSpacing + thickness), 0);
}


void drawRedDot() {
  stroke(255, 0, 0);
  strokeWeight(2);
  pushMatrix();
  ellipse(0, 0, 10, 10);
  line(0, 0, 20, 0);
  popMatrix();
}