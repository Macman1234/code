import processing.pdf.*;

//INPUTS
float sideLengthInPixels = 144;
float NUDGE = 5;

//CONSTANTS
float altitude = sideLengthInPixels * sqrt(3) / 2;
float diameter = sideLengthInPixels * 2;

void setup() {
  size(720, 720, PDF, "triTiles.pdf");
  background(255 );
  strokeWeight(0.072 * 300 );
  noFill();

  float y = sideLengthInPixels * 0.25 ;
  float altitude = sideLengthInPixels * sqrt(3) / 2;
  //draw horizontal
  int rowCtr = 0;
  while (y < height) {
    float x = sideLengthInPixels * 0.25  + ((rowCtr % 2 == 0) ? 0 : sideLengthInPixels/2) ;
    //drawHorizontal

    while (x  < width ) {
      drawRandomArcs(x, y);
      x += sideLengthInPixels;
    }
    y += altitude;
    ++rowCtr;
  }
}

void drawRandomArcs(float x, float y) {
  pushMatrix();
  translate(x, y);
  float xCenter = sideLengthInPixels/2;
  //draw horizontal arc randomly up or down
  for (int arcCtr = 0; arcCtr < 3; ++arcCtr) {
    boolean drawArc = true;
    if (arcCtr == 0) {
      drawArc = x + sideLengthInPixels < width;
    } else {
      if (y + altitude > height) {
        drawArc = false;
      } else {
        if (arcCtr == 1 && x + sideLengthInPixels/2 > width) {
          drawArc = false;
        }
        if (arcCtr == 2 && x - sideLengthInPixels/2 < 0) {
          drawArc = false;
        }
      }
    }
    if (drawArc) {
      if (random(1) > 0.5) {
        arc(xCenter, - altitude, diameter, diameter, PI / 3, 2* PI / 3);
      } else {
        arc(xCenter, altitude, diameter, diameter, 4 * PI / 3, 5 * PI / 3);
      }
    }
    rotate(PI/3);
  }
  popMatrix();
}