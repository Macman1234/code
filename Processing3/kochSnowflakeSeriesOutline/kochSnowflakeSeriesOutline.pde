import processing.pdf.*;

int[] rotations;//a rotation is the number of rotations by PI/3
int SERIES_DEPTH = 15;
float MIN_SEGMENT_LENGTH = 0.25;
PGraphics pdf;

void setup() {
  size(960, 960);
  background(255);
  pdf = createGraphics(width, height, PDF, "kochSnowflakeSeriesOutline.pdf");
  pdf.beginDraw();
  pdf.noFill();
  pdf.rectMode(CORNERS);
  pdf.strokeWeight(0.072);
  //This magic box must match the box used by kochSnowflakeSeriesOEtch.
  //It is used for aligning the images for mergin in the laser software.
  pdf.rect(width * 0.42, height * 0.47, width * 0.94, height * 0.84);

  float sizeScalar = 0.85;
  for (int seriesIndex = 0; seriesIndex < SERIES_DEPTH; ++seriesIndex) {
    if (seriesIndex==0) { 
      drawTopLevelSnowflake(sizeScalar);
    } else {
      drawSnowflake(sizeScalar);
    }
    pdf.translate(width * 0.5, height * 0.5);
    pdf.rotate(TWO_PI/12);
    pdf.translate(-width * 0.5, -height * 0.5);
    sizeScalar *= sqrt(3)/3;
  }

  pdf.dispose();
  pdf.endDraw();
  exit();
}

void drawTopLevelSnowflake(float sizeScalar) {
  float sideLength = width * sizeScalar;
  //draw approximately the same level of detail at each level
  int level = (int) (log(MIN_SEGMENT_LENGTH/sideLength)/log(1.0/3));
  float segmentLength= sideLength * pow(1.0/3, level);
  buildRotations(level);
  float x = x0(sizeScalar);
  float y = y0(sizeScalar);
  pdf.beginShape();
  int totalRotation = 0;
  for (int rotationCtr =  0; rotationCtr <= rotations.length * 5/12; ++rotationCtr) {
    float angle = totalRotation * PI / 3;
    if (rotationCtr >=  rotations.length / 4 ) {
      pdf.vertex(x, y);
    }
    x += cos(angle) * segmentLength;
    y += sin(angle) * segmentLength;
    totalRotation += rotations[rotationCtr];
  }
  pdf.endShape();
}

float x0(float sizeScalar) {
  return width * (1.0 - sizeScalar)/2;
}

float y0(float sizeScalar) {
  return height * 0.5 * (1 + sizeScalar / sqrt(3));
}

void drawSnowflake(float sizeScalar) {
  float sideLength = width * sizeScalar;
  //draw approximately the same level of detail at each level
  int level = (int) (log(MIN_SEGMENT_LENGTH/sideLength)/log(1.0/3));
  float segmentLength= sideLength * pow(1.0/3, level);
  if (segmentLength < MIN_SEGMENT_LENGTH) { 
    return;
  }
  buildRotations(level);
  float x = x0(sizeScalar);
  float y = y0(sizeScalar);
  pdf.beginShape();
  boolean penLifted = false;
  int totalRotation = 0;
  for (int rotationCtr =  0; rotationCtr < rotations.length; ++rotationCtr) {
    float angle = totalRotation * PI / 3;
    if (rotationCtr >=  rotations.length * 1/4  && rotationCtr <=  rotations.length / 3 ) {
      pdf.vertex(x, y);
    } 
    if (!penLifted && rotationCtr  > rotations.length / 3) {
      penLifted = true;
      pdf.endShape();
      pdf.beginShape();
    }
    if (rotationCtr >=  rotations.length * 5/12  && rotationCtr <=  rotations.length / 2) {
      pdf.vertex(x, y);
    }
    x += cos(angle) * segmentLength;
    y += sin(angle) * segmentLength;
    totalRotation += rotations[rotationCtr];
  }
  pdf.endShape();
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