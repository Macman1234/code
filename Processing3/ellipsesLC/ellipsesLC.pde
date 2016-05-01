float strkWeight, distanceToEllipseCenter, ellipseRotation, ellipseWidth, heightFactor;
int n;

interface JavaScript {
  void showValues(int numberOfRepeats, float strokeWt, float distEC, float ellipseRotation, float axis1, float axis2);
}

void bindJavascript(JavaScript js) {
  javascript = js;
}

JavaScript javascript;

void setup() {
  //High resolution of the bitmap version is needed 
  //if our vector-based drawing is to look smooth.
  size(480, 480);
  strkWeight = 5;
  distanceToEllipseCenter = 0.37;
  ellipseRotation = 15;
  ellipseWidth = 0.5;
  heightFactor = 0.15;
  n = 24;
  noLoop();
}

void draw() {
  background(255);
  if (javascript!=null) 
    javascript.showValues(n, strkWeight, distanceToEllipseCenter, ellipseRotation, ellipseWidth, heightFactor);
  drawEllipses();
}


void drawEllipses() {
  translate(width/2, height/2);
  noFill();
  strokeWeight(strkWeight);
  float sizeMultiplier = 0.5;// ((float)0.5) / (ellipseWidth + distanceToEllipseCenter);
  float phi = ellipseRotation * PI /180;
  float x = width * distanceToEllipseCenter * cos(phi) * sizeMultiplier;
  float y = - height * distanceToEllipseCenter * sin(phi * sizeMultiplier);
  for (int i = 0; i < n; ++i) {
    ellipse(x, y, ellipseWidth * width * sizeMultiplier, heightFactor * height * sizeMultiplier);
    rotate(2 * PI / n);
  }
}

void setStrokeWeight(float s) {
  strkWeight = s;
  redraw();
}

void setDistanceToCenter(float s) {
  distanceToEllipseCenter = s;
  redraw();
}

void setEllipseRotation(float s) {
  ellipseRotation = s;
  redraw();
}

void setEllipseWidth(float w_) {
  ellipseWidth = w_;
  redraw();
}

void setEllipseHeight(float s) {
  heightFactor = s;
  redraw();
}

void setEllipseRotation(int phi) {
  ellipseRotation = phi;
  redraw();
}

void setNumberOfRepeats(int s) {
  n = s;
  redraw();
}