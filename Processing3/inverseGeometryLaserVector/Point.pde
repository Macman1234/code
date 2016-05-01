class Point {
  float x, y;

  Point(float x_, float y_) { 
    x = x_;
    y = y_;
  }

  void invertAndRotate(float scalar) {
    float c0 = 1/ dist(0, 0, x, y);
    c0 = c0 * c0 * scalar;
    x *= c0;
    y *= c0;
    float angle = dist(0, 0, x, y) * 0.005;
    float xNew = x * cos(angle) - y * sin(angle);
    float yNew = x * sin(angle) + y * cos(angle);
    x = xNew;
    y=yNew;
  }
}