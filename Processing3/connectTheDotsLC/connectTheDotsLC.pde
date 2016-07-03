import processing.pdf.*;

float penFractionOfWidth = 0.025;
int numPointsOuterRing = 2;
int numPointsInnerRing = 12;
float radiusInnerRing = 1;
boolean  redrawNeeded = true;
float horizontalStretch = 0.5;
boolean includeRing = false;
boolean generatePDF = true;

//index.html settings:
//float penFractionOfWidth = 0.02;
//int numPointsOuterRing = 4;
//int numPointsInnerRing = 6;
//float radiusInnerRing = 0.7;
//boolean  redrawNeeded = true;

interface JavaScript {
  void showValues(float strokeWt, int nOuter, int nInner, float radius);
}

void bindJavascript(JavaScript js) {
  javascript = js;
}

JavaScript javascript;

void setup() {
  //int w = generatePDF ? 2000 : 800;
  //size(w, w);
  size(2000, 2000);
  if (javascript == null) {  
    initializeEdgeCalculator();
  }
}

String fileName() {
  return  "connectDots_stretch"+horizontalStretch+"_pen"+penFractionOfWidth
    +"_outer"+numPointsOuterRing+"_inner"
    +numPointsInnerRing+"_radius"
    +radiusInnerRing 
    + (includeRing?"":"_noRing");
}

void setStrokeWeight(float s) {
  penFractionOfWidth = s;
  redrawNeeded = true;
}

void setNumberVerticesInnerRing(int n) {
  numPointsInnerRing = n;
  redrawNeeded = true;
}

void setNumberVerticesOuterRing(int n) {
  numPointsOuterRing = n;
  redrawNeeded = true;
}

void setRadiusInnerRing(float r) {
  radiusInnerRing = r;
  redrawNeeded = true;
}

void draw() {
  if (!redrawNeeded) return;
  redrawNeeded = false;
  if (javascript!=null) 
    javascript.showValues(penFractionOfWidth, numPointsOuterRing, numPointsInnerRing, radiusInnerRing);
  background(255);
  noSmooth();
  translate(width/2, height/2);
  rotate(PI/2);
  strokeWeight(penFractionOfWidth * width);

  Ring r1 = new Ring();
  r1.setPoints(numPointsOuterRing);
  r1.setRadiusAsFractionOfWidth(1);

  Ring r2 = new Ring();
  r2.setPoints(numPointsInnerRing);
  r2.setRadiusAsFractionOfWidth(radiusInnerRing);
  //  r2.rotation = PI /4.5;

  r1.connectToRing(r2);

  if (includeRing) {
    float ringDiameter = width * 0.06;
    rotate(-PI/2);
    ellipse(0, -height * 0.43, ringDiameter, ringDiameter);
  }

  if (generatePDF && javascript == null) {
    createEdgeOnlyPDF(fileName()+".pdf", 72*12);
    exit();
  }
}

class Ring {
  float radiusAsFractionOfWidth;
  int numPoints;
  float rotation = 0;

  void setRadiusAsFractionOfWidth(float r) {
    radiusAsFractionOfWidth = r;
  }

  void setPoints(int n) {
    numPoints = n;
  }

  void connectToRing(Ring ring) {
    for (int i = 0; i < numPoints; ++i) {
      Point p = pointAtIndex(i);
      for (int j = 0; j < ring.numPoints; ++j) {
        Point p2 = ring.pointAtIndex(j);
        p.connectToPoint(p2);
      }
    }
  }

  Point pointAtIndex(int j) {
    float radius =  width * radiusAsFractionOfWidth / 2 * 0.95;
    float angle = 2 * PI / numPoints * j + rotation;
    return new Point(radius * cos(angle), radius * sin(angle) * horizontalStretch);
  }
}

class Point {
  float x, y;

  Point(float x_, float y_) {
    x = x_;
    y = y_;
  }

  void connectToPoint(Point p) {
    line(x, y, p.x, p.y);
  }
}