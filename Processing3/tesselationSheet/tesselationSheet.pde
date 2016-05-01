import processing.pdf.*;
float sideLength;
//Good values: (PI/4, 0.17), (PI/3, 0.3), (PI/6, 0.06), (PI/5, 0.15)
float sideInCM = 2.54;//240 on a 12x24 sheet
float levelFraction = 1.0/3;
float rotationAngle = PI / 3;
boolean alternateUpDown = false;
float MAX_SEGMENT_LENGTH = 1;

void setup() {
  //23.5 by 11.5 inches ( 72 * 23.5, 72 * 11.5)
  size(1692, 828, PDF, "tesselationSheet.pdf");
  background(255 );
  strokeWeight(0.072 );

  sideLength = 72 * sideInCM / 2.54; 
  translate(sideLength *0.1, sideLength * 0.4);

  //horizontals
  int row = 0;
  float y = 0;//height * 0.05;
  translate(0, y);
  float dy = sideLength * sqrt(3) / 2;
  float x;
  while (y < height) {
    x = - row++ * sideLength / 2;
    while (x < 0) {
      x += sideLength * 2;
    }
    pushMatrix();
    translate(x, 0);
    while (x < width) {
      if (y + dy < height && x < width) {
        //don't draw the last cuts off the bottom and right of the page
        rotate(PI/3);
        drawSide();
        rotate(-PI/3);
      }
      x += sideLength;
      if (x < width) {
        drawSide();
        translate(sideLength, 0);
        x += sideLength;
      }       
      if (x + sideLength < width) {
        drawSideFlipped();
        translate(sideLength, 0);
      }
    }
    popMatrix();
    y += dy;
    translate(0, dy);
  }
}

void drawParallelogram1by2() {
  drawSide();
  translate(sideLength, 0);
  drawSideFlipped();
  translate(sideLength, 0);
  rotate(PI/3);
  drawSide();
  translate(sideLength, 0);
  rotate(2 * PI/3);
  drawSideFlipped();
  translate(sideLength, 0);
  drawSide();
  translate(sideLength, 0);
  rotate(PI/3);
  drawSideFlipped();
}

void drawSide() {
  drawKochSide();
}

void drawSideFlipped() {
  pushMatrix();
  translate(sideLength, 0);
  rotate(PI);
  drawSide();
  popMatrix();
}

//Available methods to call in drawSide()
//Should start at (0,0) and finish at (sideLength,0)

void drawKochSide() {
  drawKoch(sideLength);
}

void drawKoch(float thisSideLength) {
  if (thisSideLength < MAX_SEGMENT_LENGTH) {
    line(0, 0, thisSideLength, 0); 
    return;
  }

  float nextSideLength = levelFraction*thisSideLength;

  //first part
  pushMatrix();
  if (alternateUpDown) {
    translate(nextSideLength, 0);
    rotate(PI);
  }
  drawKoch(nextSideLength);
  popMatrix();

  //last part
  pushMatrix();
  if (alternateUpDown) {
    translate(thisSideLength, 0);
    rotate(PI);
  } 
  else {
    translate(thisSideLength - nextSideLength, 0);
  }
  drawKoch(nextSideLength);
  popMatrix();


  //middle part
  pushMatrix();
  translate(nextSideLength, 0);
  rotate( - rotationAngle);
  float newSideLength = (0.5 - levelFraction)*thisSideLength/cos(rotationAngle);
  drawKoch(newSideLength);
  translate(newSideLength, 0);
  rotate(2 * rotationAngle);
  drawKoch(newSideLength);
  popMatrix();
}