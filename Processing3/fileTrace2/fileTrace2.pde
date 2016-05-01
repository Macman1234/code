import processing.pdf.*;

//GLOBALS
ArrayList<NeighborPixel> neighbors;
ArrayList<NeighborPixel> adjacentNeighbors;

int WHITE = color(255);
int BLACK = color(0);
float PIXELS_PER_INCH = 72;
int MIN_NODES_PER_PATH = 1;
EdgeCalculator edgeCalculator;

String INPUT_FILE_NAME = "giveThanks";
String FILE_EXTENSION = "jpg";
float[] widthsInInches =  new float[] {
  12 // 23.04167 from OmniGraffle
};

void setup() {
  size(3039, 3186);
  initializeNeighborPixelArray();
  edgeCalculator = new EdgeCalculator(INPUT_FILE_NAME + '.' + FILE_EXTENSION);

  for (float w : widthsInInches) {
    int wholePart = (int) w;
    String wString = ""+wholePart + '_' + nf( round(100 * (w - wholePart)), 2);
    edgeCalculator.createEdgeOnlyPDF(INPUT_FILE_NAME+'/'+INPUT_FILE_NAME+'_'+wString+"in.pdf", 72 * w );
  }
}

void draw() {
  image(edgeCalculator.img, 0, 0);
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