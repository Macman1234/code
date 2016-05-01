class Circle {
  float x, y, r;
  int colour = color(0);

  Circle(float x_, float y_, float r_) {
    x = x_;
    y = y_;
    r = r_;
  }

  Circle(float x_, float y_, float r_, int clr) {
    this(x_, y_, r_);
    colour = clr;
  }

  void draw() {
    noFill();
    ellipse(x, y, r*2, r*2);
  }

  void drawWithCenter() {
    stroke(colour);
    fill(colour);
    draw();
    ellipse(x, y, 15, 15);
   }

  boolean containsCursor() {
    return dist(mouseX - width/2, height/2 - mouseY, x, y) < r;
  }
  
  float[] intersectionArc(Circle c1) {
    Point[] points = intersection(c1);
    float[] angles = new float[points.length];
    if(points.length > 0) {
    int index = 0;
      for(Point point : points) {
        angles[index++] = atan((point.y - y) / (point.x - x));
      }
    }
    return angles;
  }

  Point[] intersection(Circle c1) {
    //per notebook...
    float alpha = 0.5 * (c1.r * c1.r - r * r + x * x - c1.x * c1.x + y * y - c1.y * c1.y);
    //if y = c1.y (i.e. centers lie on horizontal line)
    if (y - c1.y == 0) {
      //TODO
      return new Point[0];
    } else {
      float delta = alpha / (y - c1.y) - y;
      float gamma = (c1.x - x) / (y - c1.y);
      //now solve quadratic
      float a = 1 + gamma*gamma;
      float b = 2 * delta * gamma - 2 * x;
      float c = x * x + delta * delta - r * r;
      float discriminant = b * b - 4 * a * c;
      if (discriminant < 0) {
        return new Point[0];
      }
      if (discriminant == 0 ) {
        Point[] answer = new Point[1];
        float xCoord = -b/(2*a);
        float yCoord = gamma * xCoord + delta;
        answer[0] = new Point(xCoord, yCoord);
        return answer;
      }
      Point[] answer = new Point[2];
      float xCoord = (-b - sqrt(discriminant))/(2*a);
      float yCoord = gamma * xCoord + delta + y;
      answer[0] = new Point(xCoord, yCoord);
      xCoord = (-b + sqrt(discriminant))/(2*a);
      yCoord = gamma * xCoord + delta + y;
      answer[1] = new Point(xCoord, yCoord);
      return answer;
    }
  }
}