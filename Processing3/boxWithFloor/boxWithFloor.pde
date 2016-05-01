import processing.pdf.*;

//

//Draw the grid pieces
float DPI = 72;
float heightInInches = 2;
float kerfInInches = 0.005;//0.01;
float kerf = kerfInInches * DPI;
float sideThicknessInInches = 7.0 / 32;//nominal 1/4"
float floorThicknessInInches = 3 / 25.4;
float NUDGE = DPI * 0.1;
float lengthInInches = 6;
float widthInInches = 6;
int numSideFingers = 6;
float floorFingerWidthInInches = 0.5;

//computed
float halfKerf = kerf / 2;
int heightInTenths = round(heightInInches * 10);
float ht = heightInInches * DPI;
float wdth = widthInInches * DPI;
float sideThickness = sideThicknessInInches * DPI;
float lengthInPixels = lengthInInches * DPI;
float floorFingerWidth = floorFingerWidthInInches * DPI;
float floorThickness = floorThicknessInInches * DPI;
float floorGap = floorThicknessInInches * DPI;
int lengthInTenths = round(lengthInInches * 10);
int widthInTenths = round(widthInInches * 10);
int kerfInThous = round(kerfInInches * 1000);

void setup() {
  size(470, 1650, PDF, "boxWithFloor"+heightInTenths +"H_"+lengthInTenths+"L_"+widthInTenths+"W_"+kerfInThous+"K.pdf");
  background(255);
  noFill();
  strokeWeight(1/DPI);

  translate(NUDGE, NUDGE);
  drawLength();
  translate(0, ht + NUDGE + kerf);
  drawLength();
  translate(0, ht + NUDGE + kerf);
  drawWidth();
  translate(0, ht + NUDGE + kerf);
  drawWidth();
  translate(0, ht + NUDGE + kerf);
  drawFloor();
  exit();
}

void drawLength() {
  pushMatrix(); 
  for (int halfCtr = 0; halfCtr < 2; ++halfCtr) {  
    float x = 0;
    float y = 0;
    beginShape();
    vertex(x, y);
    x += lengthInPixels + kerf;
    vertex(x, y);
    float heightBetweenFingers = sideFingerWidth();
    //y += halfKerf;
    for (int fingerCtr = 0; fingerCtr < numSideFingers -1; ++fingerCtr) {
      y += heightBetweenFingers + kerf;
      vertex(x, y);
      x -= sideThickness;
      vertex(x, y);
      y += heightBetweenFingers - kerf;
      vertex(x, y);
      x += sideThickness;
      vertex(x, y);
    }
    y += heightBetweenFingers + kerf;
    vertex(x, y);
    endShape();
    translate(x, y);
    rotate(PI);
  }
  popMatrix();

  drawFloorFingers(lengthInPixels);
}

float sideFingerWidth() {
  return ht / (numSideFingers * 2 - 1);
}

void drawFloorFingers(float sideLength) {
  pushMatrix();
  float x = sideThickness + distanceBetweenFloorFingers(sideLength) * 2;
  for (int fingerCtr = 0; fingerCtr < numFloorFingers(sideLength); ++fingerCtr) {
    float y = ht - sideFingerWidth();
    beginShape();
    vertex(x, y);
    x += floorFingerWidth;
    vertex(x, y);
    y -= floorThickness;
    vertex(x, y);
    x -= floorFingerWidth;
    vertex(x, y);
    endShape(CLOSE);
    x += floorFingerWidth + distanceBetweenFloorFingers(sideLength);
  }
  popMatrix();
}

float numFloorFingers(float sideLength) {
  return round(sideLength / floorFingerWidth / 2) ;
}

float distanceBetweenFloorFingers(float sideLength) {
  return (sideLength - 2 * sideThickness - numFloorFingers(sideLength) * floorFingerWidth) / (numFloorFingers(sideLength) + 3);
}

void drawWidth() {
  pushMatrix(); 
  for (int halfCtr = 0; halfCtr < 2; ++halfCtr) {  
    float x = 0;
    float y = 0;
    beginShape();
    x += sideThickness;
    vertex(x, y);
    x += wdth + kerf -  2 * sideThickness;
    vertex(x, y);
    float heightBetweenFingers = sideFingerWidth();
    y = kerf;
    for (int fingerCtr = 0; fingerCtr < numSideFingers - 1; ++fingerCtr) {
      y += heightBetweenFingers - kerf;
      vertex(x, y);
      x += sideThickness;
      vertex(x, y);
      y += heightBetweenFingers + kerf;
      vertex(x, y);
      x -= sideThickness;
      vertex(x, y);
    }
    y += heightBetweenFingers;
    vertex(x, y);
    endShape();
    translate(x + sideThickness, y);
    rotate(PI);
  }
  popMatrix();

  drawFloorFingers(wdth);
}

void drawFloor() {
  pushMatrix();
  for (int halfCtr = 0; halfCtr < 2; ++halfCtr) {
    float x = sideThickness; 
    float y = sideThickness;
    beginShape();
    //width first
    vertex(x, y);
    float sideLength = wdth;
    float fingerGap = distanceBetweenFloorFingers(sideLength);
    x += 2 * fingerGap;
    vertex(x, y);
    for (int fingerCtr = 0; fingerCtr < numFloorFingers(sideLength); ++fingerCtr) {
      y -= sideThickness;
      vertex(x, y);
      x+= floorFingerWidth;
      vertex(x, y);
      y += sideThickness;
      vertex(x, y);
      x+= fingerGap;
      if (fingerCtr == numFloorFingers(sideLength)-1) {
        x+= fingerGap;
      }  
      vertex(x, y);
    }
    //now length
    sideLength =  lengthInPixels;
    fingerGap = distanceBetweenFloorFingers(lengthInPixels);
    y += 2 * fingerGap;
    vertex(x, y);
    for (int fingerCtr = 0; fingerCtr < numFloorFingers(sideLength); ++fingerCtr) {
      x += sideThickness;
      vertex(x, y);
      y+= floorFingerWidth;
      vertex(x, y);
      x -= sideThickness;
      vertex(x, y);
      y+= fingerGap;
      if (fingerCtr == numFloorFingers(sideLength)-1) {
        y+= fingerGap;
      }  
      vertex(x, y);
    }
    endShape();
    translate(wdth, lengthInPixels);
    rotate(PI);
  }
  popMatrix();
}