float a = 200;
float b = 100;

void setup() {
  size(640, 480);
}

void draw() {
  background(200);
  line(0, height * 0.5, width, height * 0.5);
  translate(width * 0.4, height * 0.5);
  scale(1, -1);
  fill(255, 127);
  pushMatrix();
  rotate(PI/4);
  drawEllipse();
  popMatrix();

  translate( (a + b) * 0.5, 0);
  rotate(PI * 0.11);
  drawEllipse();
}

void drawEllipse() {
  ellipse(0, 0, 3, 3);
  ellipse(0, 0, a, b);
}