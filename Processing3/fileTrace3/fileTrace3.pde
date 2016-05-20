import processing.pdf.*;

//User inputs
String INPUT_FILE_NAME = "inverseGeomClock";
String FILE_EXTENSION = "png";
int FATTEN_BY_PIXELS = 0;//spreads out the edge for effect, or to allow etching/cutting the original on an enlarged background
int WIDTH_IN_INCHES =  6;

//GLOBALS
ArrayList<NeighborPixel> neighbors;
ArrayList<NeighborPixel> adjacentNeighbors;

float PIXELS_PER_INCH = 72;
int MIN_NODES_PER_PATH = 1;
int WHITE = color(255);
int BLACK = color(0);
EdgeCalculator edgeCalculator;

void setup() {
  size(4000,4000);
  initializeNeighborPixelArray();
  edgeCalculator = new EdgeCalculator(INPUT_FILE_NAME + '.' + FILE_EXTENSION);
  exit();//the window uses too much mem, so force it to close
}

//void draw() {
//  image(edgeCalculator.img, 0, 0);
//  loadPixels();
//  int zoomScale = 10;
//  int zoomRadius = zoomScale / 2 + 1;

//  //if near edge or off screen, don't zoom, just quit drawing
//  if (mouseX < zoomRadius || mouseX > width - zoomRadius) return;
//  if (mouseY < zoomRadius || mouseY > height - zoomRadius) return;

//  //draw zoom window
//  rectMode(CENTER);
//  stroke(220, 100);
//  for (int dx = -zoomRadius; dx <= zoomRadius; ++dx) {
//    for (int dy = -zoomRadius; dy <= zoomRadius; ++dy) {
//      int x = mouseX + dx;
//      int y = mouseY + dy;
//      int pxlIndex = x + y * width;
//      if (pxlIndex >= 0 && pxlIndex < pixels.length) { 
//        int pxl = pixels[x + y * width];
//        fill(pxl);
//        rect(mouseX + dx * zoomScale, mouseY + dy * zoomScale, zoomScale, zoomScale);
//      }
//    }
//  }
//}