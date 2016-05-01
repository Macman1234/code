class CircleIntersectionList {
  Circle circle;
  ArrayList<Circle> circles;
  ArrayList<Intersection> intersections;
  int firstIntersectionIsOnTop = -1;//0 if false, 1 if true

  CircleIntersectionList(Circle c, ArrayList<Circle> circles_) {
    circle = c;
    circles = circles_;

    //get intersections with other circles, 
    intersections = new  ArrayList<Intersection>();
    for (Circle cOther : circles) {
      if (cOther != circle) {
        intersections.addAll(circle.intersections(cOther));
      }
    }

    float[] sortedAngles = new float[intersections.size()];
    int index = 0;
    for (Intersection intersection : intersections) {
      sortedAngles[index++] = intersection.angle();
    }
    sortedAngles = sort(sortedAngles);
    ArrayList<Intersection> sortedIntersections = new ArrayList<Intersection>();
    for (float angle : sortedAngles) {
      for (Intersection intersection : intersections) {
        if (angle == intersection.angle()) {
          sortedIntersections.add(intersection);
          break;
        }
      }
    }
    intersections = sortedIntersections;
  }

  boolean firstIntersectionOnTop() {
    if (firstIntersectionIsOnTop == -1) {
    }
    return firstIntersectionIsOnTop == 1;
  }

  void drawRing() {
    strokeWeight(1); 
    int arcIndex = firstIntersectionOnTop() ? 0 : 1;
    for (; arcIndex < ) {
      Intersection intersection = intersections.get(arcIndex++);
      Circle circle = intersection.circle;
      float diam = circle.diameter();
      arc(circle.x, circle.y, diam, diam, arcs[arcIndex], arcs[arcIndex + 1]);
    }
  }

  void drawAlternatingArcsBetweenIntersections() {
    noFill();
    strokeWeight(5); 
    float[] arcs = intersectionArcs();
    float diam = circle.diameter();
    for (int arcIndex = 0; arcIndex < arcs.length; arcIndex += 2) {
      arc(circle.x, circle.y, diam, diam, arcs[arcIndex], arcs[arcIndex + 1]);
    }
  }

  float[] intersectionArcs() {
    float[] angles = new float[intersections.size()];
    int index = 0;
    for (Intersection intersection : intersections) {
      angles[index++] = intersection.angle();
    }
    return angles;
  }

  //ArrayList<Point> intersectionPoints() {
  //  ArrayList<Point> points = new ArrayList<Point>();
  //  for (Intersection intersection : intersections) {
  //    points.add(intersection.point);
  //  }
  //  return points;
  //}
}