import processing.pdf.*;
float sideLength;
//Good values: (PI/4, 0.17), (PI/3, 0.3), (PI/6, 0.06), (PI/5, 0.15)
float sideInCM = 2.54;//240 on a 12x24 sheet
float levelFraction = 1.0/3;
float rotationAngle = PI / 3;
boolean alternateUpDown = false;
float MAX_SEGMENT_LENGTH = 1;

void setup() {
  //23.5 by 11.5 inches ( 72 * 23.5, 72 * 11.5)
  size(1692, 828, PDF, "tesselationSheet.pdf");
  background(255 );
  strokeWeight(0.072 );

  sideLength = 72 * sideInCM / 2.54; 