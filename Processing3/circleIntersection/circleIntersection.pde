Circle c0, c1;

void setup() {
  size(640, 480);
  c0 = new Circle(40, -20, 80);
  c1 = new Circle(0, 0, 120);
}

void draw() {
  if (mousePressed && c0.containsCursor()) {
    c0.x = mouseX - width/2;
    c0.y = height/2 - mouseY;
  }

  background(255);
  translate(width/2, height/2);
  scale(1, -1);

  c0.draw();
  c1.draw();

  Point[] intersections = c0.intersection(c1);
  if (intersections.length > 0) {
    for (Point point : intersections) {
      point.draw();
    }
  }

  float[] arcs = c0.intersectionArc(c1);
  if (arcs.length > 0) {
    for (float arc : arcs) {
      print(""+arc+"  ");
    }
    println();
  }
}