/*
This sketch introduces the CircleSet. It is responsible for
 knowing where all the intersections are.
 */

CircleSet circleSet = new CircleSet();

void setup() {
  size(640, 480);
  float alpha = 255;
  circleSet.addCircle(new Circle(40, -20, 80, color(255, 0, 0, alpha)));
  circleSet.addCircle(new Circle(0, 0, 120, color(0, 255, 0, alpha)));
  circleSet.addCircle(new Circle(0, 30, 60, color(0, 0, 255, alpha)));
  
  //arc(50, 55, 50, 50, -HALF_PI, PI/4);

}

void draw() {
 background(255);
 fill(0, 0, 255);
 String msg = "click near center of circle to drag";
 text(msg, (width - textWidth(msg))/2, height - 30);
 translate(width/2, height/2);
 scale(1, -1);

 //grab the circle whose center is closest to mouse cursor, and move to cursor
 if (mousePressed) {
   circleSet.moveCircleWithCenterClosestTo(mouseX - width/2, height/2 - mouseY);
 }

 //circleSet.drawCircles();
 circleSet.drawCircleAlternatingArcsBetweenIntersections();

 circleSet.drawIntersectionPoints();
}