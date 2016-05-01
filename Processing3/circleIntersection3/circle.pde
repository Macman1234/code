class Circle {
  float x, y, r;
  int colour = color(0);
  ArrayList<Intersection> intersections = new  ArrayList<Intersection>();

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
    ellipse(x, y, r*2, r*2);
  }

  void drawWithCenter() {
    stroke(colour);
    noFill();
    //fill(colour);
    ellipse(x, y, r*2, r*2);
    ellipse(x, y, 5, 5);
  }

  boolean containsCursor() {
    return dist(mouseX - width/2, height/2 - mouseY, x, y) < r;
  }

  //float[] intersectionArc(Circle c1) {
  //  Point[] points = intersection(c1);
  //  float[] angles = new float[points.length];
  //  if (points.length > 0) {
  //    int index = 0;
  //    for (Point point : points) {
  //      angles[index++] = atan((point.y - y) / (point.x - x));
  //    }
  //  }
  //  return angles;
  //}

  ArrayList<Point> intersections(Circle c1) {
    //TODO: does not handle circles with centers on horizontal line
    ArrayList<Point> points = new ArrayList<Point>();
    //per notebook...
    if (y - c1.y != 0) {
      float alpha = 0.5 * (c1.r * c1.r - r * r + x * x - c1.x * c1.x + y * y - c1.y * c1.y);
      float delta = alpha / (y - c1.y) - y;
      float gamma = (c1.x - x) / (y - c1.y);
      //now solve quadratic
      float a = 1 + gamma*gamma;
      float b = 2 * delta * gamma - 2 * x;
      float c = x * x + delta * delta - r * r;
      float discriminant = b * b - 4 * a * c;
      if (discriminant > 0) {
        float xCoord = (-b - sqrt(discriminant))/(2*a);
        float yCoord = gamma * xCoord + delta + y;
        points.add(new Point(xCoord, yCoord));
        xCoord = (-b + sqrt(discriminant))/(2*a);
        yCoord = gamma * xCoord + delta + y;
        points.add(new Point(xCoord, yCoord));
      }
    }
    return points;
  }
}