import processing.pdf.*;   //<>//

float centerHoleDiameterFraction = 0.15;
int numPieces = 10;

void setup() {
  size(432, 432, PDF, "inverseGeometryLaser.pdf");

  background(255);
  translate(width/2, height/2);
  //scale(width * 0.001, width * 0.001);
  //rotate(PI/4);

  noFill();
  stroke(0);
  strokeWeight(0.072);

  int pointsOnSide = 30;
  int borderSize = pointsOnSide / 2 - 5;
  float holeRatio = 0.7;
  float scalar = width * 950/ pointsOnSide;
  drawInvertedAndRotated(rectangularCuttables(pointsOnSide, borderSize, holeRatio), scalar);

  if (centerHoleDiameterFraction > 0) {
    ellipse(0, 0, centerHoleDiameterFraction * width, centerHoleDiameterFraction * width);
  }
}

void drawSegments(ArrayList<LineSegment> segments) {
  for (LineSegment segment : segments) {
    segment.draw();
  }
}

void drawInverted(ArrayList<LineSegment> segments, float scalar) {
  for (LineSegment segment : segments) {
    ArrayList<LineSegment> partSegments = segment.inPieces(numPieces );
    for (LineSegment partSegment : partSegments) {
      partSegment.drawInverted(scalar);
    }
  }
}

void drawInvertedAndRotated(ArrayList<LineSegment> segments, float scalar) {
  for (LineSegment segment : segments) {
    ArrayList<LineSegment> partSegments = segment.inPieces(numPieces );
    for (LineSegment partSegment : partSegments) {
      partSegment.drawInvertedAndRotated(scalar);
    }
  }
}

ArrayList<LineSegment> rectangularCuttables(int pointsOnSide, int borderSize, float holeRatio) {
  //create rectangular grid that is cuttable
  ArrayList<LineSegment> segments = new ArrayList<LineSegment>();
  float pointSeparation = width / (pointsOnSide + 1.0);
  float squareWidth = pointSeparation * holeRatio;

  //draw inverted grid that is cuttable

  //inner squares
  float upperLeft = - ((pointsOnSide - 1) * pointSeparation  + squareWidth )/ 2  ;
  for (int i = 0; i < pointsOnSide; ++i) {
    float x = upperLeft + pointSeparation * i;
    for (int j = 0; j < pointsOnSide; ++j) {
      float y = upperLeft + pointSeparation * j;
      if (( i < borderSize || pointsOnSide - i <= borderSize) ||
        ( j < borderSize || pointsOnSide - j <= borderSize)) {
        //horizontal lines
        segments.add(new LineSegment(x, y, x + squareWidth, y));
        segments.add(new LineSegment(x, y + squareWidth, x + squareWidth, y + squareWidth));

        //vertical lines
        segments.add(new LineSegment(x, y, x, y+ squareWidth));
        segments.add(new LineSegment(x+ squareWidth, y, x + squareWidth, y+ squareWidth));
      }
    }
  }

  //  //outer border
  upperLeft = - ( (pointsOnSide - borderSize * 2 - 1) * pointSeparation + squareWidth)/2  ;
  segments.addAll(new LineSegment(upperLeft, upperLeft, -upperLeft, upperLeft).inPieces(numPieces));
  segments.addAll(new LineSegment(-upperLeft, upperLeft, -upperLeft, -upperLeft).inPieces(numPieces));
  segments.addAll(new LineSegment(-upperLeft, -upperLeft, upperLeft, -upperLeft).inPieces(numPieces));
  segments.addAll(new LineSegment(upperLeft, -upperLeft, upperLeft, upperLeft).inPieces(numPieces));

  return segments;
}