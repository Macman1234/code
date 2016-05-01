import processing.pdf.*;
float xGridSpace;
int NUMBER_CIRCLES_ACROSS = 8;

void setup() {
  size(3000, 4800);
  initializeNeighborPixelArray();

  background(255);
  noFill();
  xGridSpace = ((float)width) / NUMBER_CIRCLES_ACROSS;
  strokeWeight(xGridSpace * 0.1);
  float yGridSpace = xGridSpace *sqrt(3)/2;
  drawCircle(xGridSpace * 1.5, xGridSpace, yGridSpace);
  drawFrame();

  EdgeCalculator ec = new EdgeCalculator();
  ec.createEdgeOnlyPDF("panelCircleTesselation_"+NUMBER_CIRCLES_ACROSS+"_across.pdf", 72 * 12 );
  ec.sendToDisplay();
}


void drawFrame() {
  //Hmm. Should pattern have a narrow frame, so that when the panel is 
  //inserted into channels, the frame disappears? Or is the frame part of the
  //decoration?
  rectMode(CENTER);
  float innerFrameWeight = width  / 4;
  strokeWeight(innerFrameWeight);
  rect(width/2, height/2, width, height);
  stroke(255);
  rect(width/2, height/2, width + innerFrameWeight, height + innerFrameWeight);
}


void drawCircle(float circleDiameter, float xGridSpace, float yGridSpace) {
  float x, y = 0;
  boolean evenRow = true;
  while (y < height + yGridSpace ) {
    x = evenRow ? -xGridSpace * 2: - xGridSpace * 1.5;
    while (x < width + xGridSpace * 0.5) {
      x += xGridSpace;
      ellipse(x, y, circleDiameter, circleDiameter);
    }
    y += yGridSpace;
    evenRow = !evenRow;
  }
}