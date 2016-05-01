class Intersection {
  Circle c1, c2;
  Point point;
  //float angleFromCenterofC1;
  Circle topCircle = null;

  Intersection(Circle c1_, Circle c2_, float x, float y) {
    c1 = c1_; 
    c2 = c2_; 
    point = new Point(x, y);
    //angleFromCenterofC1 = atan2(y - c1.y, x - c1.x);
  }
  
  boolean involvesCircle(Circle c) {
    return c == c1 || c == c2;
  }
  
  float angle() {
    return atan2(point.y - c1.y, point.x - c1.x);
  }
}