import processing.pdf.*;
/*
The idea here is to create a library for quickly 
 creating cut & fold patterns. 
 */
float w, h, d, c;

float inchesPerUnit = 1;
float xShift, yShift;
int cutCount = 0;
boolean showLabels = false;
float HAIRLINE_WEIGHT = 0.072;
float ETCH_WEIGHT = 0.072;
float SCORE_LENGTH = 72 *0.05;

void setup() {
  // 8.5 x 11 paper
//  size(576, 756, PDF, "shelfWedge_35w_40d2.pdf");
//  whd(3.5, 1.1, 4);

// 18 x 12 paper
//  size(864, 1296, PDF, "shelfWedge_6w_6d.pdf");
//  whd(6, 1.5, 6);

// 18 x 12 paper wide and shallow
  size(1296, 864, PDF, "shelfWedge_11w_4d.pdf");
  whd(11, 1.75, 4);

  xShift = (h + h * d /c) * 1.02;
  yShift = -h * 1.05;

  background(255);

  cut(-h, (d-h)* h /d, 0, h);//0
  cut(-h, (d-h)* h /d, -h, 0);
  cut(0, 0, -h, 0);
  fold(0, -d, 0, h);//3
  cut(w, h, 0, h);
  cut(w, h, w+h, (d-h)*h/d);
  cut(w+h, 0, w+h, (d-h)*h/d);
  cut(w+h, 0, w, 0);
  fold(0, 0, w, 0);//8
  fold(w, h, w, -d);//9
  fold(w, -d, w+h, 0);
  fold(w, -d, 0, -d);
  fold(-h, 0, 0, -d);
  cut(0, -d, 0, -d-c-h);//13
  cut(w, -d, w, -d-c-h);
  cut(0, -d-c-h, w, -d-c-h);
  fold(0, -d-c, w, -d-c);

  //left side tab
  cut(-h-h * d/c, -h *h/c, -h, 0);
  cut(-h-h * d/c, -h *h/c, -h *d/c, -d - h*h/c);
  cut(-h *d/c, -d - h*h/c, 0, -d);

  //right side tab
  cut(w + h, 0, w + h + h * d/c, -h * h /c);
  cut(w + h * d /c, -d-h*h/c, w + h + h * d/c, -h * h /c);
  cut(w + h * d /c, -d-h*h/c, w, -d);
}

void whd(float w_, float h_, float d_) {
  w = w_; 
  h = h_; 
  d = d_;
  c = dist(0, 0, h, d);
}

void cut(float x0, float y0, float x1, float y1) {
  stroke(255, 0, 0);
  strokeWeight(HAIRLINE_WEIGHT);
  cutFoldDefault(x0, y0, x1, y1);
}

void fold(float x0, float y0, float x1, float y1) {
  stroke(0, 0, 255);
  strokeWeight(ETCH_WEIGHT);
  cutFoldDefault(x0, y0, x1, y1);
}

void cutFoldDefault(float x0, float y0, float x1, float y1) {
  line(mapX(x0), mapY(y0), mapX(x1), mapY(y1));
  if (showLabels) {
    fill(255, 0, 0);
    text(""+cutCount, mapX((x0+x1)/2), mapY((y0+y1)/2));
  } 
  ++cutCount;
}

void score(float x0, float y0, float x1, float y1) {
  line(mapX(x0), mapY(y0), mapX(x1), mapY(y1));
}

float mapX(float x) {
  return (x + xShift) * inchesPerUnit * 72;
}

float mapY(float y) {
  return -(y + yShift) * inchesPerUnit * 72;
}
