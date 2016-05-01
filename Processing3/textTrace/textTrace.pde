import processing.pdf.*;

//GLOBALS
ArrayList<NeighborPixel> neighbors;
ArrayList<NeighborPixel> adjacentNeighbors;

String INPUT_TEXT = "kim";
String FONT = "Lucida Handwriting";
//"Brush Script MT";
//"Lucida Handwriting";
//"SignPainter";
//"Mistral";
//"Snell Roundhand";
//"Zapfino";

int MIN_NODES_PER_PATH = 5;
float MAX_ERROR =  0.5;
int WIDTH_IN_INCHES =  6;

int WHITE = color(255);
int BLACK = color(0);
float PIXELS_PER_INCH = 72;

EdgeCalculator edgeCalculator;


void setup() {
  size(6000, 4000);
  initializeNeighborPixelArray();
  edgeCalculator = new EdgeCalculator(INPUT_TEXT);
}

void draw() {
  image(edgeCalculator.pg, 0, 0);
  loadPixels();
  int zoomScale = 10;
  int zoomRadius = zoomScale / 2 + 1;

  //if near edge or off screen, don't zoom, just quit drawing
  if (mouseX < zoomRadius || mouseX > width - zoomRadius) return;
  if (mouseY < zoomRadius || mouseY > height - zoomRadius) return;

  //draw zoom window
  rectMode(CENTER);
  stroke(220, 100);
  for (int dx = -zoomRadius; dx <= zoomRadius; ++dx) {
    for (int dy = -zoomRadius; dy <= zoomRadius; ++dy) {
      int x = mouseX + dx;
      int y = mouseY + dy;
      int pxlIndex = x + y * width;
      if (pxlIndex >= 0 && pxlIndex < pixels.length) { 
        int pxl = pixels[x + y * width];
        fill(pxl);
        rect(mouseX + dx * zoomScale, mouseY + dy * zoomScale, zoomScale, zoomScale);
      }
    }
  }
}