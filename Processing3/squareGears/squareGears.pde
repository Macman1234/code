void setup() {
  size(640,480);
  
  translate(width * 0.25, height * 0.5);
  scale(1, -1);
  fill(255, 127);
  float squareEdge = width * 0.3;
  pushMatrix();
  rotate(PI/4);
  drawSquare(squareEdge);
  popMatrix();

  translate(squareEdge * 0.5 * (1 + sqrt(2)), 0);
  rotate(PI/4 * 0);
  drawSquare(squareEdge);
}

void drawSquare(float squareEdge) {
  rectMode(CENTER);
  rect(0,0,squareEdge, squareEdge);
}