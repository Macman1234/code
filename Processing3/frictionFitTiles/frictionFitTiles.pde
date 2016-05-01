import processing.pdf.*;

float PIXELS_PER_INCH = 72;

//float kerf = PIXELS_PER_INCH * 0.01;
//float sideLength = PIXELS_PER_INCH * 2;
//float toothLength = PIXELS_PER_INCH * 25/32 / 4;//4 thicknesses of material = 25/32"
//float toothWidth = toothLength;
//int numTeethPerSide = 3;

float kerf = PIXELS_PER_INCH * 0.01;
float sideLength = PIXELS_PER_INCH * 1.5;
float toothLength = PIXELS_PER_INCH * 25/32 / 4;//4 thicknesses of material = 25/32"
float toothWidth = toothLength;
int numTeethPerSide = 2;




DrawSide drawMethod;



void setup() {
  size(400, 420, PDF, "frictionFitTiles_1.5in.pdf");
  background(255);
  strokeWeight(0.072);
  drawMethod = straightTeeth;

  float shift =  toothLength + kerf * 3;
  translate(shift, shift);
  drawSides(4);

  shift = sideLength + toothLength * 2 + 4 * kerf;
  translate(shift, 0);
  drawSides(4);

  translate(-shift, shift);
  drawSides(3);

  translate(shift, 0);
  drawSides(5);
}

void drawSides(int numSides) {
  //we can do better to find a translation point that give the chord on a 
  //circle of radius of perhaps width / 3
  pushMatrix();
  for (int sideCtr = 0; sideCtr < numSides; ++sideCtr) {
    drawMethod.drawSide(sideLength);
    translate(sideLength, 0);
    rotate(2 * PI / numSides);
  }
  popMatrix();
}

interface DrawSide { 
  void drawSide(float length);
}

DrawSide straight = new DrawSide() {
  void drawSide(float sideLength) {
    line(0, 0, sideLength, 0);
  }
};

DrawSide straightTeeth = new DrawSide() {
  void drawSide(float sideLength) {
    float straightLength = sideLength * 0.5 - numTeethPerSide * toothWidth;
    float x = 0;
    float halfKerf = kerf * 0.5;
    float xNext = straightLength + halfKerf;
    float y = - halfKerf;
    float  yNext = - halfKerf;
    float dx = (sideLength - x) / numTeethPerSide / 2;
    line(x, y, xNext, y);
    for (int tooth = 0; tooth < numTeethPerSide; ++tooth) {
      x=xNext;
      yNext = toothLength - halfKerf;//down
      line(x, y, xNext, yNext);
      xNext = x + toothWidth - halfKerf;//right
      y=yNext;
      line(x, y, xNext, yNext);
      x=xNext;
      yNext = -toothLength - halfKerf;//up
      line(x, y, xNext, yNext);
      xNext = x + toothWidth + kerf;//right
      y=yNext;
      line(x, y, xNext, yNext);
      x=xNext;
      yNext = - halfKerf;//down to complete one cycle
      line(x, y, xNext, yNext);
    }
    line(xNext, yNext, sideLength, yNext);
  }
};