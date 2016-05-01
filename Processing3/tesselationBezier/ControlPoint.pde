class ControlPoint {
  float x, y;
  float diameter = width/40;
  color c = color(255, 0, 0);
  boolean drag = false;
  ControlPoint next;

  ControlPoint(float x_, float y_, ControlPoint nextControlPoint) {
    next = nextControlPoint;
    x = x_; 
    y = y_;
  }

  boolean dragIfSelected() {
    drag  = (dist(x, y, mouseX - xOffset, mouseY - yOffset)<diameter);
    return drag;
  }

  void displayLine() {
    //draw line between points
    if (next != null) {
      stroke(255, 0, 0, 100);
      strokeWeight(diameter * 0.2);
      line(x, y, next.x, next.y);
    }
  }

  void displayPoint() {
    if (drag) {
      x = max(0, min(mouseX, width)) - xOffset;
      y = max(0, min(mouseY, height)) - yOffset;
    }
    //draw anchor/control point
    stroke(0);
    strokeWeight(2);
    fill(240);
    ellipse(x, y, diameter, diameter);
  }

  void releaseDrag() {
    drag = false;
  }
}