boolean needsRedraw = true;
int colorSensitivity = 10;
int blackThreshold = 160;
PixelStack pixelStack = new PixelStack();

void setup() {
  size(696, 973);
  PImage img = loadImage("ringGray.png");
  image(img, 0, 0);
  loadPixels();
  pixelStack.push(pixels);
}

void drawImageOnly() {
  loadPixels();
  int[] editedPixels = pixelStack.top();
  for (int pxlCtr = 0; pxlCtr < pixels.length; ++pxlCtr) {
    pixels[pxlCtr] = editedPixels[pxlCtr];
  }
  updatePixels();
}

void draw() {
  drawImageOnly();
  drawZoomWindow();

  String msg = "+/- sensitivity ("+colorSensitivity+"), u = undo (depth = " + pixelStack.depth()+"), g = gray, b = b/w, 4/8 = 4/8 grays, s = save";
  fill(255, 0, 0);
  noStroke();
  textSize(16);
  text(msg, (width-textWidth(msg))*0.5, 20);
}

void mouseClicked() {
  boolean edited = false;
  int[] editedPixels = pixelStack.topCopy();
  int colorClicked = editedPixels[mouseY * width + mouseX];
  //println("mouseClicked("+mouseX +','+mouseY+")="+colorClicked);
  int newColor = color(255, 255, 255);
  float r = red(colorClicked);
  float g = green(colorClicked);
  float b = blue(colorClicked);
  for (int pxlCtr = 0; pxlCtr < pixels.length; ++pxlCtr) {
    int pxl = pixels[pxlCtr];
    float colorDist = abs(r - red(pxl))+abs(g - green(pxl))+abs(b - blue(pxl));
    if (colorDist < colorSensitivity) {
      editedPixels[pxlCtr] = newColor;
      edited = true;
    }
  }  
  if (edited) {
    pixelStack.push(editedPixels);
    needsRedraw = edited;
  }
}

void keyPressed() {
  needsRedraw = true;
  if (key == 's') {
    drawImageOnly();
    save("edited.png");
  } else if (key =='g') {
    //convert to gray scale
    pixelStack.push(convertToGray());
  } else if (key =='b') {
    //convert to black /white
    int[] grayPxls =  convertToGray();
    for (int pxlCtr = 0; pxlCtr < grayPxls.length; ++pxlCtr) {
      float gray = red(grayPxls[pxlCtr]);
      grayPxls[pxlCtr] = gray < blackThreshold ? color(0) : color(255);
    }
    pixelStack.push(grayPxls);
  } else if (key =='4') {
    pixelStack.push(convertToDiscreteGray(4));
  } else if (key =='8') {
    pixelStack.push(convertToDiscreteGray(8));
  } else if (key == 'u' && pixelStack.depth() > 1) {
    pixelStack.pop();
  } else  if (key == '+') {
    ++colorSensitivity;
  } else if (key == '-' && colorSensitivity > 1) {
    --colorSensitivity;
  }
}

int[] convertToGray() {
  int[] grayPxls =  pixelStack.topCopy();
  for (int pxlCtr = 0; pxlCtr < grayPxls.length; ++pxlCtr) {
    int colr = grayPxls[pxlCtr];
    float gray = (red(colr) + green(colr) + blue(colr))/3;
    grayPxls[pxlCtr] = color(gray, gray, gray);
  }
  return grayPxls;
}

int[] convertToDiscreteGray(int numGrayLevels) {
    float grayBandWidth = 256.0 / numGrayLevels;
    //convert to discretized gray
    int[] grayPxls =  convertToGray();
    for (int pxlCtr = 0; pxlCtr < grayPxls.length; ++pxlCtr) {
      float gray = red(grayPxls[pxlCtr]);
      int grayBand = (int) (gray / grayBandWidth);
      gray = 256.0 / (numGrayLevels - 1) * grayBand ;
      grayPxls[pxlCtr] = color(gray, gray, gray);
    }
  return grayPxls;
}