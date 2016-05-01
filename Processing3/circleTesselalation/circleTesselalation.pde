float xGridSpace = 240;
//float circleDiameter = 90;

float yGridSpace = xGridSpace *sqrt(3)/2;

void setup() {
  size(640, 640);
  background(255);

  noFill();
  drawCircle(xGridSpace * 1.4);
  drawCircle(xGridSpace * 1.6);
}

void drawCircle(float circleDiameter) {
  float x, y = 0;
  boolean evenRow = true;
  while (y < height + yGridSpace ) {
    x = evenRow ? -xGridSpace : - xGridSpace * 0.5;
    while (x < width + xGridSpace * 0.5) {
      x += xGridSpace;
      ellipse(x, y, circleDiameter, circleDiameter);
    }
    y += yGridSpace;
    evenRow = !evenRow;
  }
}