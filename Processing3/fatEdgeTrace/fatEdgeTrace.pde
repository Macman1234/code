boolean needsRedraw = true;
int edgeDepth = 10;
int BLACK, WHITE;

void setup() {
  size(1200, 700);
  BLACK = color(0);
  WHITE = color(255);
}

void draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  clear();
  background(255);
  fill(BLACK);
  //ellipse(width / 2, height / 2, width * 0.8, height * 0.8);
  textSize(height * 0.6);
  text("Freya", 0, height* 0.8);
  fatEdgeTrace();
}

void fatEdgeTrace() {
  int blackPixelCount = 0;
  loadPixels();
  println(pixels.length);
  int[] newPixels = new int[pixels.length];
  arrayCopy(pixels, newPixels);

  for (int row = 0; row < height; ++row) {
    for (int col = 0; col < width; ++col) {
      int pixelIndex = row * width + col;
      //If this pixel is black, and all of its neighbors
      // in a disk of radius edgeDepth are also black, 
      //then flip to white
      //println(pixelIndex + '->'+pixels[pixelIndex]);
      if (pixels[pixelIndex] == BLACK) {
        ++blackPixelCount;
        boolean flipToWHITE = true;
        for (int dy = -edgeDepth + 1; dy <= edgeDepth; ++dy) {
          if (row + dy >= 0 && row + dy < height) {
            int dxWidth = round(sqrt(edgeDepth * edgeDepth - dy * dy));
            for (int dx = -dxWidth; dx <= dxWidth; ++dx) {
              if (col + dx >= 0 && row + dy < width) {
                if (pixels[(row + dy) * width + col + dx] == WHITE) {
                  flipToWHITE = false;
                  // break;
                }
              }
            }
          }
        }
        if (flipToWHITE) {
          newPixels[pixelIndex] = WHITE;
        }
      }
    }
  }
  arrayCopy(newPixels, pixels);
  updatePixels();
  println(blackPixelCount);
}