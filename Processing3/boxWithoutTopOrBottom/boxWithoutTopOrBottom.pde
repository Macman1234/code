  import processing.pdf.*;

//To Do
// - draw sides of box

// - Could add detents at top of slots, and an etched region 
//opposite the slot that would create a notch for the detents.
//But this is probably unnecessary, if we create the slots to be snug.

//Draw the grid pieces
float DPI = 72;
float heightInInches = 2;
float kerfInInches = 0.005;//0.01;
float kerf = kerfInInches * DPI;
float materialThicknessInInches = 7.0 / 32;
float NUDGE = DPI * 0.1;
float lengthInInches = 1;
float widthInInches = 1;
int numFingers = 6;

//computed
float halfKerf = kerf / 2;
int heightInTenths = round(heightInInches * 10);
float ht = heightInInches * DPI;
int lengthInTenths = round(lengthInInches * 10);
int widthInTenths = round(widthInInches * 10);
int kerfInThous = round(kerfInInches * 1000);

void setup() {
  size(1000, 800, PDF, "boxWithoutTopOrBottom_"+heightInTenths +"H_"+lengthInTenths+"L_"+widthInTenths+"W_"+kerfInThous+"K.pdf");
  background(255);
  noFill();
  strokeWeight(1/DPI);

  translate(NUDGE, NUDGE);
  drawLength();
  translate(0, ht + NUDGE + kerf);
  drawLength();
  translate(0, ht + NUDGE + kerf);
  drawWidth();
  translate(0, ht + NUDGE + kerf);
  drawWidth();
  exit();
}

void drawLength() {
  pushMatrix(); 
  float thickness = materialThicknessInInches * DPI;
  for (int halfCtr = 0; halfCtr < 2; ++halfCtr) {  
    float x = 0;
    float y = 0;
    beginShape();
    vertex(x, y);
    x += lengthInInches * DPI + kerf;
    vertex(x, y);
    float heightBetweenFingers = ht / (numFingers * 2 - 1);
    //y += halfKerf;
    for (int fingerCtr = 0; fingerCtr < numFingers -1; ++fingerCtr) {
      y += heightBetweenFingers + kerf;
      vertex(x, y);
      x -= thickness;
      vertex(x, y);
      y += heightBetweenFingers - kerf;
      vertex(x, y);
      x += thickness;
      vertex(x, y);
    }
    y += heightBetweenFingers + kerf;
    vertex(x, y);
    endShape();
    translate(x, y);
    rotate(PI);
  }
  popMatrix();
}

void drawWidth() {
  pushMatrix(); 
  float thickness = materialThicknessInInches * DPI;
  for (int halfCtr = 0; halfCtr < 2; ++halfCtr) {  
    float x = 0;
    float y = 0;
    beginShape();
    x += thickness;
    vertex(x, y);
    x += widthInInches * DPI + kerf -  2 * thickness;
    vertex(x, y);
    float heightBetweenFingers = ht / (numFingers * 2 - 1);
    y = kerf;
    for (int fingerCtr = 0; fingerCtr < numFingers - 1; ++fingerCtr) {
      y += heightBetweenFingers - kerf;
      vertex(x, y);
      x += thickness;
      vertex(x, y);
      y += heightBetweenFingers + kerf;
      vertex(x, y);
      x -= thickness;
      vertex(x, y);
    }
    y += heightBetweenFingers;
    vertex(x, y);
    endShape();
    translate(x + thickness, y);
    rotate(PI);
  }
  popMatrix();
}