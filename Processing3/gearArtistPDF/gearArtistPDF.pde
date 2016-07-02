import processing.pdf.*;

int n1 = 1;
int n2 = 2;
float gearSpeed = 0.01;
float axleSeparation;
int numIterationsPerGear = 1000;

float amplitudeMultipler = 0.15;

PGraphics pdf;
int numIterationsPerGearPDF = 1000;
float axleDiameterPDF = 72*0.125;

float MIN_RADIUS_1 = 1e10;
float MIN_RADIUS_2 = 1e10;

void setup() {
  size(960, 720);

  calibrateAxleSeparation();
  printPDF();
}

float radius(float theta) {
  //return height * 0.1 * (1 + 0.3 * (cos(theta * n1) + cos(theta * n1 * 2)));
  //return height * 0.2 * (1 + amplitudeMultipler* (cos(theta * n1) + 2 * cos(theta * n1 * 2)));
  //return height * 0.2 * (1 + amplitudeMultipler * (cos(theta * n1) +  sin(theta * n1 * 2 )+   cos(theta * n1 * 3 )+   sin(theta * n1 * 5 )));
  return height * 0.2 * (1 + amplitudeMultipler * (cos(theta * n1) +  cos(theta * n1 * 3 )+  cos(theta * n1 * 5 )+  0.05 * cos(theta * n1 * 120 )));
  //return height * 0.1 * (1 + 0.8 * cos(theta * n1) ); 
  //return height * 0.1 * (1 + 0.7 * sin(theta * n1) );
}

void printPDF() {
  String filename =  "pdf/gear_"+n1+'_'+n2+'_' + ((int) (1000* radius(1)))+".pdf";
  pdf = createGraphics(width*3/2, height*2, PDF, filename);
  pdf.beginDraw();
  pdf.translate(width/4, height/2);
  pdf.pushMatrix();
  pdf.strokeWeight(0.01);
  drawFirstGearPDF();
  pdf.translate(width/2, 0);
  drawSecondGearPDF();
  pdf.popMatrix();

  drawBase();
  pdf.dispose();
  pdf.endDraw();
}

void calibrateAxleSeparation() {
  float minSeparation = 300;
  float maxSeparation = 2000;
  calibrateAxleSeparationWithBounds(minSeparation, maxSeparation);
  while (axleSeparation / minSeparation < 1.0001) {
    maxSeparation = minSeparation;
    minSeparation *= 0.8;
    calibrateAxleSeparationWithBounds(minSeparation, maxSeparation);
  }
  println(minSeparation, maxSeparation, axleSeparation);
}

void calibrateAxleSeparationWithBounds(float minSeparation, float maxSeparation) {
  float gearOneAngle = 2 * PI;
  //float previousMinSeparation = minSeparation;
  while (maxSeparation - minSeparation > 0.0001) {
    axleSeparation = (maxSeparation + minSeparation) * 0.5;
    if (gearTwoRotation(gearOneAngle) * n2 < gearOneAngle * n1) {
      maxSeparation = axleSeparation;
    } else {
      minSeparation = axleSeparation;
    }
  }
}

void draw() {
  background(255);
  translate((width - axleSeparation) * 0.5, height * 0.5);
  scale(1, -1);
  stroke(127);
  drawFirstGear();
  stroke(0, 0, 255);
  translate(axleSeparation, 0);
  drawSecondGear();
}

float gearOneRotation() {
  float angle = frameCount * gearSpeed;
  //angle = angle - 2 * PI * floor(angle / (2 * PI));
  return angle;
}

float gearTwoRotation(float gearOneAngle) {
  float numStepsForSecondGear = numIterationsPerGear * 5;
  float dTheta = 2 * PI / n1 / numStepsForSecondGear;
  float theta1 = 0;
  float theta2 = 0;
  while (theta1 < gearOneAngle) {
    theta1 += dTheta;
    float r1 = radius(theta1);
    float r2 = axleSeparation - r1;
    theta2 += dTheta * r1 / r2;
  }
  return theta2;
}

void drawFirstGear() {
  pushMatrix();
  rotate(-gearOneRotation());
  line(0, 0, radius(0), 0);
  drawAxle();  
  float dTheta = 2 * PI / n1 / numIterationsPerGear;
  float x = radius(0);
  float y = 0;
  for (int i = 0; i < numIterationsPerGear * n1; ++i) {
    float theta = dTheta * (i + 1);
    float r = radius(theta);
    float newX = r * cos(theta);
    float newY = r * sin(theta);
    line(x, y, newX, newY);
    x = newX;
    y = newY;
  }
  popMatrix();
}

void drawFirstGearPDF() {
  pdf.pushMatrix();
  pdf.rotate(-gearOneRotation());
  pdf.line(0, 0, radius(0), 0);
  drawAxlePDF();  
  float dTheta = 2 * PI / n1 / numIterationsPerGearPDF;
  float x = radius(0);
  float y = 0;
  for (int i = 0; i < numIterationsPerGearPDF * n1; ++i) {
    float theta = dTheta * (i + 1);
    float r = radius(theta);
    MIN_RADIUS_1 = min(r, MIN_RADIUS_1);
    float newX = r * cos(theta);
    float newY = r * sin(theta);
    pdf.line(x, y, newX, newY);
    x = newX;
    y = newY;
  }
  pdf.popMatrix();
}

void drawAxle() {
  float axleDiameter = width * 0.01;
  ellipse(0, 0, axleDiameter, axleDiameter);
}

void drawAxlePDF() {
  pdf.ellipse(0, 0, axleDiameterPDF, axleDiameterPDF);
}

void drawSecondGear() {
  pushMatrix();
  rotate(gearTwoRotation(gearOneRotation()));
  float x = radius(0) - axleSeparation;
  line(0, 0, x, 0);
  drawAxle();
  float numStepsForSecondGear = numIterationsPerGear * 10;
  float dTheta = 2 * PI / n1 / numStepsForSecondGear;
  float y = 0;
  float theta2 = 0;
  for (int i = 0; i < numStepsForSecondGear * n2; ++i) {
    float theta1 = dTheta * (i + 1);
    float r1 = radius(theta1);
    float r2 = axleSeparation - r1;
    MIN_RADIUS_2 = min(r2, MIN_RADIUS_2);
    theta2 += dTheta * r1 / r2;
    float newX = - r2 * cos(theta2);
    float newY = r2 * sin(theta2);
    line(x, y, newX, newY);
    x = newX;
    y = newY;
  }
  popMatrix();
}

void drawSecondGearPDF() {
  pdf.pushMatrix();
  pdf.rotate(gearTwoRotation(gearOneRotation()));
  float x = radius(0) - axleSeparation;
  pdf.line(0, 0, x, 0);
  drawAxlePDF();
  float numStepsForSecondGear = numIterationsPerGear * 10;
  float dTheta = 2 * PI / n1 / numStepsForSecondGear;
  float y = 0;
  float theta2 = 0;
  for (int i = 0; i < numStepsForSecondGear * n2; ++i) {
    float theta1 = dTheta * (i + 1);
    float r1 = radius(theta1);
    float r2 = axleSeparation - r1;
    theta2 += dTheta * r1 / r2;
    float newX = - r2 * cos(theta2);
    float newY = r2 * sin(theta2);
    pdf.line(x, y, newX, newY);
    x = newX;
    y = newY;
  }
  pdf.popMatrix();
}

void drawBase() {
  pdf.pushMatrix();
  pdf.translate(0, axleSeparation );
  pdf.noFill();
  drawAxlePDF();
   float diameter = min(MIN_RADIUS_1, MIN_RADIUS_2);
  pdf.arc(0, 0, diameter, diameter, HALF_PI, 3 * HALF_PI);//arc for 1st gear
  pdf.line(0, diameter/2, axleSeparation,diameter/2);
  pdf.line(0, -diameter/2, axleSeparation,-diameter/2);
  pdf.translate(axleSeparation, 0);
  drawAxlePDF();
  pdf.arc(0, 0, diameter, diameter, -HALF_PI, HALF_PI);//arc for 2nd gear
  pdf.popMatrix();
}