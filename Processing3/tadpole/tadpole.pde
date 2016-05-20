void setup() {
  size(600, 600);

  background(255);
  translate(width/2, height/2);
  strokeCap(ROUND);
  //strokeJoin(ROUND);
  float sw = 5;
  int numSides = 1000;
  float r = width * 0.3;
  float prevAngle = 0;
  for (float angle = 0; angle < TWO_PI; angle += TWO_PI /  numSides) {
    if (angle > 0) {
      strokeWeight(sw);
      line(r * cos(prevAngle), r * sin(prevAngle), r * cos(angle), r * sin(angle));
    }
    prevAngle = angle;
    sw *= pow(40, 1.0 / numSides);
  }
}