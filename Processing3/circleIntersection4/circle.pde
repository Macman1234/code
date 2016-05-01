class Circle {
  float x, y, r;
  int colour = color(0);
  //ArrayList<Intersection> intersections = new  ArrayList<Intersection>();
  //int firstIntersectionIsOnTop = -1;//0 if false, 1 if true

  Circle(float x_, float y_, float r_) {
    x = x_;
    y = y_;
    r = r_;
  }

  Circle(float x_, float y_, float r_, int clr) {
    this(x_, y_, r_);
    colour = clr;
  }

  float diameter() {
    return r * 2;
  }

  void draw() {
    noFill();
    strokeWeight(1); 
    ellipse(x, y, r*2, r*2);
  }

  void drawWithCenter() {
    stroke(colour);
    noFill();
    //fill(colour);
    strokeWeight(1); 
    ellipse(x, y, r*2, r*2);
    ellipse(x, y, 5, 5);
  }

  ArrayList<Point> intersectionPoints(Circle otherC) {
    //TODO: does not handle circles with centers on horizontal line
    ArrayList<Point> points = new ArrayList<Point>();
    ArrayList<Intersection> intersections_ = intersections(otherC);
    for (Intersection intersection : intersections_) {
      points.add(intersection.point);
    }
    return points;
  }

  ArrayList<Intersection> intersections(Circle otherC) {
    //TODO: does not handle circles with centers on horizontal line
    ArrayList<Intersection> intersections_ = new ArrayList<Intersection>();
    //per notebook...
    if (y - otherC.y != 0) {
      float alpha = 0.5 * (otherC.r * otherC.r - r * r + x * x - otherC.x * otherC.x + y * y - otherC.y * otherC.y);
      float delta = alpha / (y - otherC.y) - y;
      float gamma = (otherC.x - x) / (y - otherC.y);
      //now solve quadratic
      float a = 1 + gamma*gamma;
      float b = 2 * delta * gamma - 2 * x;
      float c = x * x + delta * delta - r * r;
      float discriminant = b * b - 4 * a * c;
      if (discriminant > 0) {
        float xCoord = (-b - sqrt(discriminant))/(2*a);
        float yCoord = gamma * xCoord + delta + y;
        intersections_.add(new Intersection(this, otherC, xCoord, yCoord));
        xCoord = (-b + sqrt(discriminant))/(2*a);
        yCoord = gamma * xCoord + delta + y;
        intersections_.add(new Intersection(this, otherC, xCoord, yCoord));
      }
    }
    return intersections_;
  }

}