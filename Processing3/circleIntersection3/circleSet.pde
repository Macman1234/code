class CircleSet {
  ArrayList<Circle> circles = new ArrayList<Circle>();

  void addCircle(Circle c) {
    circles.add(c);
  }

  void drawCircles() {
    for (Circle c : circles) {
      c.drawWithCenter();
    }
  }

  void drawCircleAlternatingArcsBetweenIntersections() {
    noFill();
    for (Circle c : circles) {
      float[] arcs = intersectionArcs(c);
      for (int arcIndex = 0; arcIndex < arcs.length; arcIndex += 2) {
        float diam = c.diameter();
        arc(c.x, c.y, diam, diam, arcs[arcIndex], arcs[arcIndex + 1]);
      }
    }
  }

  void drawIntersectionPoints() {
    ArrayList<Point> points = circleSet.intersectionPoints();
    for (Point point : points) {
      point.draw();
    }
  }

  float[] intersectionArcs(Circle c) {
    ArrayList<Point> points = intersections(c);
    float[] angles = new float[points.size()];
    int index = 0;
    for (Point point : points) {
      angles[index++] = atan2(point.y - c.y, point.x - c.x);
    }
    angles = sort(angles);
    return angles;
  }
 
  ArrayList<Point> intersections(Circle c) {
    ArrayList<Point> points = new ArrayList<Point>();
    for (Circle cOther : circles) {
      if (c != cOther) {
        points.addAll(c.intersections(cOther));
      }
    }
    return points;
  }

  ArrayList<Point> intersectionPoints() {
    ArrayList<Point> points = new ArrayList<Point>();
    //ArrayList<ArrayList<Point>> circleIntersections = new ArrayList<ArrayList<Point>>();
    for (int firstCircleIndex = 0; firstCircleIndex < circles.size(); ++firstCircleIndex) {
      for (int secondCircleIndex = firstCircleIndex+1; secondCircleIndex < circles.size(); ++secondCircleIndex) {
        Circle c0 = circles.get(firstCircleIndex);
        Circle c1 = circles.get(secondCircleIndex);
        points.addAll(c0.intersections(c1));
      }
    }
    return points;
  }

  Circle circleWithCenterClosestTo(float x, float y) {
    //grab the circle whose center is closed to mouse cursor
    Circle closestCircle = null;
    float closestDistance = 1e8;
    for (Circle c : circles) {
      float d = dist(c.x, c.y, x, y);
      if (d < closestDistance) {
        closestDistance = d;
        closestCircle = c;
      }
    }
    return closestCircle;
  }


  void moveCircleWithCenterClosestTo(float x, float y) {
    //grab the circle whose center is closed to mouse cursor
    Circle closestCircle = circleWithCenterClosestTo(x, y);
    if (closestCircle != null) {
      closestCircle.x = x;
      closestCircle.y = y;
    }
  }
}