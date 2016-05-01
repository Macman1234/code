import processing.pdf.*;
float sideLength;
//Good values: (PI/4, 0.17), (PI/3, 0.3), (PI/6, 0.06), (PI/5, 0.15)
float levelFraction = 1.0/3;
float rotationAngle = PI / 3;
boolean alternateUpDown = false;

void setup() {
  size(800, 600);//, PDF, "tesselationKoch5.pdf");
  background(255 );
  strokeWeight(0.072 );

  float sideInCM = 10;
  sideLength = 72 * sideInCM / 2.54; 
  translate(sideLength *0.1, sideLength * 0.4);

  drawParallelogram1by2();
}

void drawParallelogram1by1() {
  drawSide();
  translate(sideLength, 0);
  rotate(PI/3);
  drawSideFlipped();
  translate(sideLength, 0);
  rotate(2 * PI/3);
  drawSide();
  translate(sideLength, 0);
  rotate(PI/3);
  drawSideFlipped();
}

void drawRect1by2() {
  drawSide();
  translate(sideLength, 0);
  drawSideFlipped();
  translate(sideLength, 0);
  rotate(PI/2);
  drawSide();
  translate(sideLength, 0);
  rotate(PI/2);
  drawSideFlipped();
  translate(sideLength, 0);
  drawSide();
  translate(sideLength, 0);
  rotate(PI/2);
  drawSideFlipped();
}

void drawSquare1by1() {
  drawSide();
  translate(sideLength, 0);
  rotate(PI/2);
  drawSideFlipped();
  translate(sideLength, 0);
  rotate(PI/2);
  drawSide();
  translate(sideLength, 0);
  rotate(PI/2);
  drawSideFlipped();
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

void drawParallelogramTromineoe() {
  drawSide();
  translate(sideLength, 0);
  drawSideFlipped();
  translate(sideLength, 0);
  rotate(PI/3);
  drawSide();
  translate(sideLength, 0);
  drawSideFlipped();
  translate(sideLength, 0);
  rotate(2 * PI/3);
  drawSide();
  translate(sideLength, 0);
  rotate(PI/3);
  drawSideFlipped();
  translate(sideLength, 0);
  rotate(-PI/3);
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
  if (thisSideLength < 2) {
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