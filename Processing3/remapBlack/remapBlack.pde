String INPUT_FILE_NAME = "heidi_phosphate";
String FILE_EXTENSION = "png";

String BACKGROUND_FILE_NAME = "background.jpg";

int BLACK = color(0);

void setup() {
  size(2129, 816);
  PImage img = loadImage("input/"+INPUT_FILE_NAME+"."+FILE_EXTENSION);
  img.loadPixels();
  PImage bgImg = loadImage(BACKGROUND_FILE_NAME);
  bgImg.loadPixels();
  for (int y = 0; y < height; ++y) {
    for (int x = 0; x < width; ++x) {
      int pixelIndex = y * width + x;
      if (img.pixels[pixelIndex] == BLACK) {
        int bgX = x % bgImg.width;
        int bgY = y % bgImg.height;
        int bgPixelIndex = bgY * bgImg.width + bgX;
        img.pixels[pixelIndex] = bgImg.pixels[bgPixelIndex];
      }
    }
  }
  image(img, 0, 0);
  save("output/"+INPUT_FILE_NAME+"_bg.jpg");
}