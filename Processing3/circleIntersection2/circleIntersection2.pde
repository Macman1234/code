ArrayList<Circle> circles = new ArrayList<Circle>();

void setup() {
  size(640, 480);
  circles.add(new Circle(40, -20, 80, color(255, 0, 0)));
  circles.add(new Circle(0, 0, 120, color(0, 255, 0)));
  circles.add(new Circle(0, 30, 60, color(0, 0, 255)));
}

void draw() {
  background(255);
  String msg = "click near center of circle to drag";
  text(msg, (width - textWidth(msg))/2, height - 30);
  translate(width/2, height/2);
  scale(1, -1);

  //grab the circle whose center is closed to mouse cursor
  if (mousePressed) {
    Circle closestCircle = null;
    float closestDistance = 1e8;
    float mouseXTranslated = mouseX - width/2;
    float mouseYTranslated = height/2 - mouseY;
    for (Circle c : circles) {
      float d = dist(c.x, c.y, mouseXTranslated, mouseYTranslated);
      if (d < closestDistance) {
        closestDistance = d;
        closestCircle = c;
      }
    }
    closestCircle.x = mouseXTranslated;
    closestCircle.y = mouseYTranslated;
  }

  for (Circle c : circles) {
    c.drawWithCenter();
  }

  //ArrayList<Intersection> intersections = new ArrayList<Intersection>();
  for (int firstCircleIndex = 0; firstCircleIndex < circles.size(); ++firstCircleIndex) {
    for (int secondCircleIndex = firstCircleIndex+1; secondCircleIndex < circles.size(); ++secondCircleIndex) {
      Circle c0 = circles.get(firstCircleIndex);
      Circle c1 = circles.get(secondCircleIndex);
      Point[] intersections = c0.intersection(c1);
      if (intersections.length > 0) {
        for (Point point : intersections) {
          point.draw();
        }
      }

      //float[] arcs = c0.intersectionArc(c1);
      //if (arcs.length > 0) {
      //  for (float arc : arcs) {
      //    print(""+arc+"  ");
      //  }
      //  println();
      //}
    }
  }
}