import processing.pdf.*;

//Draw a batten for clamping
float DPI = 72;
float depthInInches = 1.5;
int depthInTenths = round(depthInInches * 10);
int lengthInInches = 24;
int numBattens = 1;
float arcInDegrees = 1.5;

void setup() {
  size(1800, 600, PDF, "battens_"+depthInTenths +"D_"+lengthInInches+"L_"+numBattens+"x.pdf");
  background(255);
  float depth = depthInInches * DPI;
  translate(width/2, (height - depth * numBattens)/2);
  //scale(1, -1);
  noFill();
  strokeWeight(1/DPI);
  float arcInRadians = arcInDegrees * PI / 180;
  float radius = lengthInInches * DPI / arcInRadians;
  float diameter = radius * 2;
  float halfArc = arcInRadians / 2;
  float yEndArc = radius * ( 1 - cos(halfArc));
  float xEndArc = radius * sin(halfArc);
  for(int battenCtr = 0; battenCtr < numBattens; ++battenCtr) {
  arc(0, -radius, diameter, diameter, HALF_PI - halfArc, HALF_PI + halfArc);
  translate(0, depth);
  line(-xEndArc, -yEndArc, -xEndArc, -yEndArc - depth);
  line(xEndArc, -yEndArc, xEndArc, -yEndArc - depth);
  }
   arc(0, -radius, diameter, diameter, HALF_PI - halfArc, HALF_PI + halfArc);
 exit();
}