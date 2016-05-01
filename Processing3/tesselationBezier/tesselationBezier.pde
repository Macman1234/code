import processing.pdf.*;

ArrayList<ControlPoint> controlPoints;
float sideLength;
//Good values: (PI/4, 0.17), (PI/3, 0.3), (PI/6, 0.06), (PI/5, 0.15)
float levelFraction = 0.21;
float rotationAngle = PI /3;
boolean alternateUpDown = true;
float sideInCM = 2 * 2.54;
float xOffset, yOffset;
float sw = 3;
int numRows = 8;
int numColumns = 4;

void setup() {
  size(1000, 800);

  sideLength = 72 * sideInCM / 2.54; 
  xOffset = sideLength *1.2;
  yOffset = sideLength * 1.1;
  setupControlPoints();
}  

void draw() {
  background(255 );
  fill(0);
  noStroke();
  String msg = "Type 's' to save single, 'h' for a "+numRows+"x"+numColumns+"sheet of singles. 'j' is experimental. ";
  text(msg, (width - textWidth(msg)) * 0.5, 20);

  translate(xOffset, yOffset);

  for (int i = 1; i < controlPoints.size() - 1; ++i) {
    controlPoints.get(i).displayPoint();
  }
  //drawParallelogram1by2Experimental();
  drawParallelogram1by2();
}

void keyTyped() {
  if (key == 's') {
    PGraphics pdf = createGraphics(width, height, PDF, "pdf/bezierTile"+timeStampText()+".pdf");
    pdf.beginDraw();
    pdf.translate(xOffset, yOffset);
    drawParallelogram1by2(pdf);
    pdf.dispose();
    pdf.endDraw();
  } else if (key == 'j') {
    PGraphics pdf = createGraphics((int) (width + 2 * sideLength * numColumns)
      , (int) (height + sideLength * sqrt(3) / 2 * numRows)
      , PDF, "pdf/bezierSheet"+timeStampText()+".pdf");
    pdf.beginDraw();
    pdf.translate(xOffset - sideLength * 2, yOffset);
    drawParallelogram1by2SheetExperimental(pdf);
    pdf.dispose();
    pdf.endDraw();
  } else if (key == 'h') {
    PGraphics pdf = createGraphics((int) (width + 2 * sideLength * numColumns)
      , (int) (height + sideLength * sqrt(3) / 2 * numRows)
      , PDF, "pdf/bezierSheet"+timeStampText()+".pdf");
    pdf.beginDraw();
    pdf.translate(xOffset - sideLength, yOffset);
    drawParallelogram1by2Sheet(pdf);
    pdf.dispose();
    pdf.endDraw();
  }
}

void drawParallelogram1by2Sheet(PGraphics pg) {
  for (int row = 0; row <= numRows; ++row) {
    pg.pushMatrix();
    boolean needExtraHalfEdge = row > 0;// && row % 4 == 0);
    boolean drawHalfEdgeInFront = needExtraHalfEdge && row % 4 == 0;
    //if (drawHalfEdgeInFront) {
    //  drawSide(pg);
    //}
    for (int col = 0; col <= numColumns; ++col) {
      pg.pushMatrix();
      if (col != 0) {
        drawSide(pg);
      }
      pg.translate(sideLength, 0);
      if (col != 0 || drawHalfEdgeInFront) {
        drawSideFlipped(pg);
      }
      pg.translate(sideLength, 0);
      pg.rotate(PI/3);
      if (row != numRows) {
        //  if (!needExtraHalfEdge || (col < numColumns)) {
        drawSide(pg);
      }
      pg.popMatrix();
      pg.translate(sideLength * 2, 0);
    }
    if (needExtraHalfEdge && !drawHalfEdgeInFront) { 
      drawSide(pg);
    }
    pg.popMatrix();
    if (row % 4 == 3) {
      pg.translate(1.5 * sideLength, sideLength * sqrt(3)/2);
    } else {
      pg.translate(-sideLength /2, sideLength * sqrt(3)/2);
    }
  }
}


void drawParallelogram1by2SheetExperimental(PGraphics pg) {
  //verticesMeet
  for (int row = 0; row <= numRows; ++row) {
    pg.pushMatrix();
    boolean isLeftShifted = (row > 0 && row % 4 == 0);
    int numTopEdgesToDraw = isLeftShifted ? numColumns + 1 : numColumns;
    for (int col = 0; col <= numTopEdgesToDraw; ++col) {
      pg.pushMatrix();
      if (col != 0) {
        drawSide(pg);
      }
      pg.translate(sideLength, 0);
      if (col != 0) {
        drawSideFlipped(pg);
      }
      pg.translate(sideLength, 0);
      pg.rotate(PI/3);
      if (row != numRows) {
        if (!isLeftShifted || (col < numTopEdgesToDraw)) {
          drawSide(pg);
        }
      }
      pg.popMatrix();
      pg.translate(sideLength * 2, 0);
    }
    pg.popMatrix();
    if (row % 4 == 3) {
      pg.translate(-1.5 * sideLength, sideLength * sqrt(3)/2);
    } else {
      pg.translate(sideLength /2, sideLength * sqrt(3)/2);
    }
  }
}

void drawSide() {
  ArrayList<ControlPoint> cp = controlPoints;
  noFill();
  stroke(0, 0, 255);
  strokeWeight(sw);
  bezier(cp.get(0).x, cp.get(0).y, cp.get(1).x, cp.get(1).y, 
    cp.get(2).x, cp.get(2).y, cp.get(3).x, cp.get(3).y);
}

void drawSide(PGraphics pdf) {
  ArrayList<ControlPoint> cp = controlPoints;
  pdf.noFill();
  pdf.stroke(0);
  pdf.strokeWeight(0.072);
  pdf.bezier(cp.get(0).x, cp.get(0).y, cp.get(1).x, cp.get(1).y, 
    cp.get(2).x, cp.get(2).y, cp.get(3).x, cp.get(3).y);
}

void setupControlPoints() {
  controlPoints = new ArrayList<ControlPoint>();
  ControlPoint nextControlPoint 
    = new ControlPoint(sideLength, 0, null);
  controlPoints.add(nextControlPoint);
  nextControlPoint 
    = new ControlPoint(sideLength * 2/3, -sideLength * 1/4, nextControlPoint);
  controlPoints.add(nextControlPoint);
  nextControlPoint 
    = new ControlPoint(sideLength * 1/3, 0, nextControlPoint);
  controlPoints.add(nextControlPoint);
  nextControlPoint 
    = new ControlPoint(0, 0, nextControlPoint);
  controlPoints.add(nextControlPoint);
}


void mousePressed() {
  for (ControlPoint point : controlPoints) {
    if (point.dragIfSelected())
      return;
  }
}  

void mouseReleased() {
  for (ControlPoint point : controlPoints) {
    point.releaseDrag();
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

void drawParallelogram1by2Experimental() {
  drawSide();
  translate(sideLength, 0);
  drawSideFlipped();
  translate(sideLength, 0);
  rotate(PI/3);
  drawSide();
  translate(sideLength, 0);
  rotate(2 * PI/3);
  drawSide();
  translate(sideLength, 0);
  drawSideFlipped();
  translate(sideLength, 0);
  rotate(PI/3);
  drawSideFlipped();
}

void drawSideFlipped() {
  pushMatrix();
  translate(sideLength, 0);
  rotate(PI);
  drawSide();
  popMatrix();
}

void drawParallelogram1by2(PGraphics pg) {
  drawSide(pg);
  pg.translate(sideLength, 0);
  drawSideFlipped(pg);
  pg.translate(sideLength, 0);
  pg.rotate(PI/3);
  drawSide(pg);
  pg.translate(sideLength, 0);
  pg.rotate(2 * PI/3);
  drawSideFlipped(pg);
  pg.translate(sideLength, 0);
  drawSide(pg);
  pg.translate(sideLength, 0);
  pg.rotate(PI/3);
  drawSideFlipped(pg);
}

void drawSideFlipped(PGraphics pg) {
  pg.pushMatrix();
  pg.translate(sideLength, 0);
  pg.rotate(PI);
  drawSide(pg);
  pg.popMatrix();
}

String timeStampText() {
  return "" + year()
  + formatTwoDigitNumberWithLeadingZero(month()) 
  + formatTwoDigitNumberWithLeadingZero(day())
  + formatTwoDigitNumberWithLeadingZero(hour())
  + formatTwoDigitNumberWithLeadingZero(minute())
  + formatTwoDigitNumberWithLeadingZero(second());
}

String formatTwoDigitNumberWithLeadingZero(int x) {
  return x > 9 ? "" + x : "0" + x;
}