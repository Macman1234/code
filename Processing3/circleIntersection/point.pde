class Point {
 float x, y;
 
  Point(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  void draw() {
    noFill();
    ellipse(x, y, 10, 10);
  }
}