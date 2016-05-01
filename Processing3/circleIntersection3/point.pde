class Point {
 float x, y;
 
  Point(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  void draw() {
    noFill();
    stroke(0);
    ellipse(x, y, 10, 10);
  }
}