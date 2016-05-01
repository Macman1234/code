class Intersection {
  Circle c1, c2;
  Point p;
  Circle topCircle = null;

  Intersection(Circle c1_, Circle c2_, Point p_) {
    c1 = c1_; 
    c2 = c2_; 
    p = p_;
  }
  
  boolean involvesCircle(Circle c) {
    return c == c1 || c == c2;
  }
}