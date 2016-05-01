import processing.pdf.*;

//parameters
int level = 3;
int  triangleSideInches = 2 ;

int[] rotations;//a rotation is the number of rotations by PI/3
float sizeScalar = 0.2;
float  triangleSideInPixels = triangleSideInches * 72;
float segmentLength;

void setup() {
  size(600, 600);//2'x3'
  background(255);

  segmentLength = triangleSideInPixels * pow(1.0/3, level);
  println(segmentLength);
  buildRotations();

  PGraphics pdf = createGraphics(width, height, PDF,
  "kochSnowflakeTesselation_level"+level+"_"+triangleSideInches+"in.pdf");
  pdf.beginDraw();
  pdf.strokeWeight(0.01);
  float x = - triangleSideInPixels * 2;
  float y = - triangleSideInPixels * 0.28;
  while (y < height) {
    while (x < width) {
      drawKoch(x, y, pdf);
      x += triangleSideInPixels * 2;
    }
    y += triangleSideInPixels / sqrt(3);
    x -= triangleSideInPixels;
    while (x>0) {
      x -= 2 * triangleSideInPixels;
    }
  }
  //  for (int i = 0; i < 4; ++i) {
  //    for (int j = 0; j < 4; ++i) {
  //      drawKoch();
  //    }
  //  }
  //  pdf.endShape();
  pdf.dispose();
  pdf.endDraw();
  exit();
}

void buildRotations() {
  rotations = new int[] { 
    -2, -2, -2
  };
  for (int lvl = 0; lvl < level; ++lvl) {
    int[] newRotations = new int[rotations.length * 4];
    int i = 0;
    for (int rotation : rotations) {
      newRotations[i++] = 1;
      newRotations[i++] = -2;
      newRotations[i++] = 1;
      newRotations[i++] = rotation;
    }
    rotations = newRotations;
  }
}

void drawKoch(float x, float y, PGraphics pdf) {
  pdf.beginShape();
  int totalRotation = 0;
  pdf.vertex(x, y);
  for (int rotation : rotations) {
    x += cos(totalRotation* PI /3) * segmentLength;
    y += sin(totalRotation* PI /3) * segmentLength;
    totalRotation = (totalRotation + rotation) % 6;
    pdf.vertex(x, y);
  }
  pdf.endShape();
}