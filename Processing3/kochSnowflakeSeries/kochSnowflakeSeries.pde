import processing.pdf.*;

int[] rotations;//a rotation is the number of rotations by PI/3
int SERIES_DEPTH = 12;
float MIN_SEGMENT_LENGTH = 0.5;
PGraphics pdf;

void setup() {
  size(960, 960);
  background(255);
  pdf = createGraphics(width, height, PDF, "kochSnowflakeSeries.pdf");
  pdf.beginDraw();
  pdf.strokeWeight(0.072);

  float sizeScalar = 0.85;
  for (int seriesIndex = 0; seriesIndex < SERIES_DEPTH; ++seriesIndex) {
    drawSnowflake(sizeScalar);
    pdf.translate(width/2, height/2);
    pdf.rotate(TWO_PI/12);
    pdf.translate(-width/2, -height/2);
    sizeScalar *= sqrt(3)/3;
  }

  pdf.dispose();
  pdf.endDraw();
  exit();
}

void drawSnowflake(float sizeScalar) {
  float sideLength = width * sizeScalar;
  //draw approximately the same level of detail at each level
  int level = (int) (log(MIN_SEGMENT_LENGTH/sideLength)/log(1.0/3));
  float segmentLength= sideLength * pow(1.0/3, level);
  buildRotations(level);
  float x = width * (1 - sizeScalar)/2;
  float y = height * (0.5 + sizeScalar * 0.285);
  pdf.beginShape();
  pdf.vertex(x, y);
  int totalRotation = 0;
  if (segmentLength >= MIN_SEGMENT_LENGTH) {
    for (int rotation : rotations) {
      float angle = totalRotation * PI / 3;// + 2 * PI / rotations.length * segmentCtr++;
      x += cos(angle) * segmentLength;
      y += sin(angle) * segmentLength;
      totalRotation += rotation;
      pdf.vertex(x, y);
    }
    pdf.endShape();
  }
}

void buildRotations(int level) {
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