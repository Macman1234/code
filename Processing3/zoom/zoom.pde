void setup() {
  size(320, 200);
}

void draw() {
  drawImageToZoom();
  drawZoomWindow();
}

void drawZoomWindow() {
  loadPixels();
  int zoomScale = 8;
  int zoomRadius = zoomScale / 2 + 1;

  //if near edge or off screen, don't zoom, just quit drawing
  if (mouseX < zoomRadius || mouseX > width - zoomRadius) return;
  if (mouseY < zoomRadius || mouseY > height - zoomRadius) return;

  //draw zoom window
  rectMode(CENTER);
  strokeWeight(1);
  stroke(200);
  for (int dx = -zoomRadius; dx <= zoomRadius; ++dx) {
    for (int dy = -zoomRadius; dy <= zoomRadius; ++dy) {
      int x = mouseX + dx;
      int y = mouseY + dy;
      int pxlIndex = x + y * width;
      if (pxlIndex >= 0 && pxlIndex < pixels.length) { 
        int pxl = pixels[pxlIndex];
        fill(pxl);
        rect(mouseX + dx * zoomScale, mouseY + dy * zoomScale, zoomScale, zoomScale);
      }
    }
  }
}

void drawImageToZoom() {
  background(255);
  strokeWeight(width * 0.1);
  noFill();
  stroke(255, 0, 0, 127);
  ellipse(width * 0.4, height * 0.4, width/2, height/2);
  stroke(0, 255, 0, 127);
  ellipse(width * 0.6, height* 0.6, width/2, height/2);
}