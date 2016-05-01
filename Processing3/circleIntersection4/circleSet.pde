/*
TODO: For each circle, need to skip over every other intersection. Where
 an intersection needs to be skipped over, we need to know the other circle
 to find where rings should start and stop. 
 */

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

  ArrayList<CircleIntersectionList> circleIntersections() {
    ArrayList<CircleIntersectionList> circleIntersections_ = new ArrayList<CircleIntersectionList>();
    for (Circle c : circles) {
      circleIntersections_.add(new CircleIntersectionList(c, circles));
    } 
    return circleIntersections_;
  }

  void drawRings() { 
    //V2: create new class CircleIntersections, instance being a circle with its associated
    //intersections. Instances knows whether first intersection is on top or bottom.
    //This keeps us from polluting Circle class with too much functionality

    ArrayList<CircleIntersectionList> circleIntersections = circleIntersections();
    for (CircleIntersectionList circleIntersectionList : circleIntersections) {
      circleIntersectionList.drawRing();
    }
  }

   void drawAlternatingArcsBetweenIntersections() {
   ArrayList<CircleIntersectionList> circleIntersections = circleIntersections();
    for (CircleIntersectionList circleIntersectionList : circleIntersections) {
      circleIntersectionList.drawAlternatingArcsBetweenIntersections();
    }
   }


  void drawIntersectionPoints() {
    ArrayList<Point> points = circleSet.intersectionPoints();
    for (Point point : points) {
      point.draw();
    }
  }

  //  ArrayList<Intersection> sortedIntersections(Circle c) {
  //    //yech. Need these in order using angles, probably need a new class.
  //    ArrayList<Intersection> intersections_ = new ArrayList<Intersection>();
  //    for (Circle cOther : circles) {
  //      if (cOther != c) {
  //        intersections_.addAll(c.intersections(cOther));
  //      }
  //    }
  //    return c.sortedByIncreasingAngleFromCenter(intersections_);
  //  }

  ArrayList<Point> intersectionPoints() {
    ArrayList<Point> points = new ArrayList<Point>();
    //ArrayList<ArrayList<Point>> circleIntersections = new ArrayList<ArrayList<Point>>();
    for (int firstCircleIndex = 0; firstCircleIndex < circles.size(); ++firstCircleIndex) {
      for (int secondCircleIndex = firstCircleIndex+1; secondCircleIndex < circles.size(); ++secondCircleIndex) {
        Circle c0 = circles.get(firstCircleIndex);
        Circle c1 = circles.get(secondCircleIndex);
        points.addAll(c0.intersectionPoints(c1));
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