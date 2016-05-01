import processing.pdf.*;

String FILENAME = "amf";
boolean FILL_SQUARES = false;
int WIDTH_PHOTO_ACTUAL = 3264;
int HEIGHT_PHOTO_ACTUAL = 2448;

String INPUT_FILE = FILENAME + ".jpg";
String OUTPUT_FILE = FILENAME + (FILL_SQUARES ? "_filled" : "_stroked") + ".pdf";
//String INPUT_FILE = "Max.jpg";
//int WIDTH_PHOTO_ACTUAL = 2359;
//int HEIGHT_PHOTO_ACTUAL = 3732;
int PIXELS_PER_DOT_INPUT = 24;
int PIXELS_PER_DOT_OUTPUT = 10;
float MAX_AREA_FRACTION_CUT  = 0.8;

int WIDTH_PHOTO = WIDTH_PHOTO_ACTUAL / PIXELS_PER_DOT_INPUT * PIXELS_PER_DOT_INPUT;
int HEIGHT_PHOTO = HEIGHT_PHOTO_ACTUAL / PIXELS_PER_DOT_INPUT * PIXELS_PER_DOT_INPUT;

void setup() {
  //make the dimensions equal to the dimensions of the photo 
  //divided by PIXELS_PER_DOT_INPUT (round up)
  //multiplied by PIXELS_PER_DOT_OUTPUT
  size(1360, 1020, PDF, OUTPUT_FILE);
  //size(240, 380);
  background(255);

  PImage photo = loadImage(INPUT_FILE);
  photo.loadPixels();
  rectMode(CENTER);
  if (!FILL_SQUARES) {
    noFill();
    strokeWeight(0.072);
    stroke(0);
  } else {
    fill(0);
    noStroke();
  }
  //loop over all pixels in the photo
  for (int y = 0; y < HEIGHT_PHOTO; y += PIXELS_PER_DOT_INPUT) {
    for (int x = 0; x < WIDTH_PHOTO; x += PIXELS_PER_DOT_INPUT) {
      float totalGreyLevel = 0;
      for (int dy = 0; dy < PIXELS_PER_DOT_INPUT; ++dy) {
        for (int dx = 0; dx < PIXELS_PER_DOT_INPUT; ++dx) {
          int pixelIndex = x + dx + (y + dy) * WIDTH_PHOTO_ACTUAL;
          int pixel = photo.pixels[pixelIndex];
          totalGreyLevel += red(pixel) + green(pixel) + blue(pixel);
        }
      }
      float fractionAreatoFill = 1.0 - totalGreyLevel / (PIXELS_PER_DOT_INPUT * PIXELS_PER_DOT_INPUT) / 3 / 255;
      fractionAreatoFill *= MAX_AREA_FRACTION_CUT;
      float squareSideLength = sqrt(fractionAreatoFill) * PIXELS_PER_DOT_OUTPUT;
      float dotX = (0.5 + x / PIXELS_PER_DOT_INPUT) * PIXELS_PER_DOT_OUTPUT;
      float dotY = (0.5 + y / PIXELS_PER_DOT_INPUT) * PIXELS_PER_DOT_OUTPUT;
      rect(dotX, dotY, squareSideLength, squareSideLength);
    }
  }
  println("Done!");
}