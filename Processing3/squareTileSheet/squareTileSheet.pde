import processing.pdf.*;
float sideLength;
float sideInMM = 25.4;
float levelFraction = 1.0/3;
float rotationAngle = PI / 3;
boolean alternateUpDown = false;
float MAX_SEGMENT_LENGTH = 1;

void setup() {
  //23.5 by 11.5 inches ( 72 * 23.5, 72 * 11.5)
  size(1692, 828, PDF, "hexagonSheet.pdf");
  background(255 );
  strokeWeight(0.5);

  sideLength = sideInMM * 72 / 25.4;

  //drawSquares();
  //drawTriangles();
  drawHexagons();
}

void drawSquares() {
  //draw all horizontals
  float inset = sideLength / 2;
  translate(inset, inset);
  pushMatrix();
  float y = inset;
  float x;
  while (y  < height) {
    x = inset;
    pushMatrix();
    while (x + sideLength < width) {
      drawSide(sideLength);
      translate(sideLength, 0);
      x += sideLength;
    }
    popMatrix();
    y += sideLength;
    translate(0, sideLength);
  } 
  popMatrix();
  //translate(0, -inset);

  //draw verticals
  x = inset;
  while (x  < width) {
    y = inset;
    pushMatrix();
    rotate(PI/2);
    while (y + sideLength < height) {
      drawSide(sideLength);
      translate(sideLength, 0);
      y += sideLength;
    }
    popMatrix();
    x += sideLength;
    translate(sideLength, 0);
  }
}

void drawTriangles() {
  //draw row of triangles, then shift left/right, and draw next row
  float inset = sideLength / 2;
  translate(inset, inset);
  float y = inset;
  boolean evenRow = true;
  float rowHeight =  sideLength * sqrt(3) / 2;
  while (y + rowHeight < height) {
    float x = inset + (evenRow ? 0 : sideLength/2);
    pushMatrix();
    while (x + sideLength < width) {
      for (int sideCtr = 0; sideCtr < 3; ++sideCtr) {
        drawSide(sideLength);
        translate(sideLength, 0);
        rotate(TWO_PI / 3);
      }
      translate(sideLength, 0);
      x += sideLength;
    }
    popMatrix();
    y += rowHeight;
    evenRow = !evenRow;
    float xShift = sideLength/2 * (evenRow ? -1 : 1);
    translate(xShift, rowHeight);
  }
}

void drawHexagons() {
  //draw rows of 3 radially-spaced legs
  float inset = 0 ;
  translate(sideLength * 0.2, sideLength * 0.6);
  float y = inset;
  boolean evenRow = true;
  float rowHeight =  sideLength * 1.5;
  float xMove =  sideLength * sqrt(3);
  while (y  < height) {
    float x = inset + (evenRow ? 0 : xMove);
    pushMatrix();
    while (x < width) {
      pushMatrix();
      rotate(HALF_PI);
      for (int sideCtr = 0; sideCtr < 3; ++sideCtr) {
        drawSide(sideLength);
        rotate(TWO_PI / 3);
      }
      popMatrix();
      translate(xMove, 0);
      x += xMove;
    }
    popMatrix();
    y += rowHeight;
    evenRow = !evenRow;
    float xShift = xMove / 2 * (evenRow ? -1 : 1);
    translate(xShift, rowHeight);
  }
}

void drawSide(float s) {
  puzzleSide2(s);
}

void puzzleSide1(float s) { 
  float radiusBase = s * 0.04;
  float straightLength = s * 0.15;

  float diamBase = radiusBase * 2;
  float radiusTop = (s/4 - straightLength - radiusBase * sqrt(0.5)) * sqrt(2);
  float diamTop = radiusTop * 2;
  pushMatrix();
  for (int sideCtr = 0; sideCtr < 2; ++sideCtr) {
    //draw first half of side first time through, and other side 2nd time through
    line(0, 0, straightLength, 0);
    arc(straightLength, -radiusBase, diamBase, diamBase, - QUARTER_PI, HALF_PI);
    arc(s/4, -radiusBase*(1 + sqrt(0.5))-radiusTop*sqrt(0.5), diamTop, diamTop, 3 * QUARTER_PI, 9 * QUARTER_PI);
    arc(s/2 - straightLength, -radiusBase, diamBase, diamBase, HALF_PI, 5 * QUARTER_PI);
    line(s/2 - straightLength, 0, s/2, 0);
    //move to other end of side, and flip
    translate(s, 0);
    rotate(PI);
  }
  popMatrix();
}

void puzzleSide2(float s) { 
  float radiusBase = s * 0.04;
  float insetLength = s * 0.25;
  float radiusTop = s * 0.06;

  float distToBulbCenter = insetLength + (radiusBase +radiusTop) * sqrt(0.5);
  float remainderLength = s/2 - (insetLength + (radiusBase +radiusTop) * sqrt(2));
  float diamBase = radiusBase * 2;
  float diamTop = radiusTop * 2;
  pushMatrix();
  for (int sideCtr = 0; sideCtr < 2; ++sideCtr) {
    //draw first half of side first time through, and other side 2nd time through
    line(0, 0, insetLength, 0);
    arc(insetLength, -radiusBase, diamBase, diamBase, - QUARTER_PI, HALF_PI);
    arc(distToBulbCenter, -radiusBase*(1 + sqrt(0.5))-radiusTop*sqrt(0.5), diamTop, diamTop, 3 * QUARTER_PI, 9 * QUARTER_PI);
    arc(s/2 - remainderLength, -radiusBase, diamBase, diamBase, HALF_PI, 5 * QUARTER_PI);
    line(s/2 - remainderLength, 0, s/2, 0);
    //move to other end of side, and flip
    translate(s, 0);
    rotate(PI);
  }
  popMatrix();
}

void spikeSide(float s) { 
  // a test example to be called by drawSide
  line(0, 0, s/2, s/4);
  line(s/2, s/4, s, 0);
}

void straightSide(float s) { 
  // a test example to be called by drawSide
  line(0, 0, s, 0);
}