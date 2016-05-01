import processing.pdf.*;

float lengthScalar;
float A = PI / 3;
float B = 3 * PI / 4;
float C = 7 * PI / 12;
float D = PI / 2;
float E = 5 * PI / 6;
float a = 1;
float b = 0.5;
float c = 1.0 / sqrt(2) / (sqrt(3) - 1);
float d = 0.5;
float e = 0.5;

void setup() {
  size(480, 480, PDF, "pentagonTiling15.pdf");
  background(255);
  strokeWeight(0.1);
  lengthScalar = width / 5;

  translate(width/2, height/2);
  scale(1, -1);
  rotate(PI);
  
  //draw axes
  //stroke(255, 0, 0, 50);
  //line(-width/2, 0, width/2, 0);//x-axis
  //line(0, -height/2, 0, height/2);//y-axis
  
  //start at A on a Yellow "normal" orientation
  stroke(0);

  //pushMatrix();
  drawTileFromAandRotate(PI - (A + E));
  //translate(a * lengthScalar, 0);
  //drawTileFromAandRotate(PI - A);
  //translate(b * lengthScalar, 0);
  //rotate(PI - B);
  //translate(c* lengthScalar, 0);
  //rotate(A + B);
  //scale(1,-1);
  ////translate(b, 0);
  //drawTileFromAandRotate(0);

  //popMatrix();

  //drawOriginAndOrientation();
}

void drawOriginAndOrientation() {
  pushMatrix();
  strokeWeight(3);
  stroke(0, 255, 0);
  line(0, 0, lengthScalar, 0);
  popMatrix();
}

void drawTileFromAandRotate(float rot) {
  //start at A (per http://www.theguardian.com/science/alexs-adventures-in-numberland/2015/aug/10/attack-on-the-pentagon-results-in-discovery-of-new-mathematical-tile)
  draw_b();
  draw_c();
  draw_d();
  draw_e();
  draw_a();
  rotate(rot);
}

void draw_a() {
  drawLineAndRotate(PI - E, a );
}

void draw_b() {
  drawLineAndRotate(PI - A, b );
}

void draw_c() {
  drawLineAndRotate(PI - B, c );
}

void draw_d() {
  drawLineAndRotate(PI - C, d);
}

void draw_e() {
  drawLineAndRotate(PI - D, e );
}

void drawLineAndRotate(float rot, float x) {
  rotate(rot);
  line(0, 0, x * lengthScalar, 0);
  translate(x * lengthScalar, 0);
}

//void translateTo