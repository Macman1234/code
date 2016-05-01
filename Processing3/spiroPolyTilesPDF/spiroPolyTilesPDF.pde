float numPolys = 7;
float numSquaresPerSide = 3;
float sideLength;

//UI
float numPolysSlider, numSquaresPerSideSlider;
float needsRedraw = true;

void setup() {
  createCanvas(800, 800);
  numPolysSlider = makeSlider("number of polygons", 3, 16, 3, 150, 20, 1);
  numSquaresPerSideSlider = makeSlider("squares on each edge", 0, 6, 1, 150, 50, 1);
}

void numSides() {
  if (numPolys % 2 == 0) {
    return numPolys;
  }
  return 2 * numPolys;
}

void draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  background(255);
  numPolys = numPolysSlider.value();
  numSquaresPerSide = numSquaresPerSideSlider.value();
  //slider value labels
  fill(0);
  text(numPolys, 280, 33);
  text(numSquaresPerSide, 280, 63);

  strokeWeight(0.5);
  translate(width / 2, height / 2);
  sideLength = PI * width / numSides() * 0.36;
  // rotate(-PI / 2);
  for (float polyCtr = 0; polyCtr < numPolys; ++polyCtr) {
    drawPoly();
    rotate(2 * PI / numPolys);
  }
}

void drawPoly() {
  pushMatrix();;
  for (float sideCtr = 0; sideCtr < numSides(); ++sideCtr) {
    noStroke();
    fill(255, 0, 0);
    ellipse(0, 0, 3, 3);
    drawSideAsPolygons();
    translate(sideLength, 0);
    rotate(2 * PI / numSides());
  }
  popMatrix();;
}

void drawPolyVertex(float polySideLength) {
  fill(200);

  for (float sideCtr = 0; sideCtr < numPolys; ++sideCtr) {
    float vertex_ = new Vector2D(0, 0);
    float delta = new Vector2D(polySideLength, 0);
    beginShape();
    for (float edgeCtr = 0; edgeCtr < numPolys; ++edgeCtr) {
      vertex(vertex_.x, vertex_.y)
      vertex_ = vertex_.plus(delta);
      delta = delta.rotate(2 * PI / numPolys);
    }
    endShape(CLOSE);
  }
}

void drawSideAsPolygons() {
  //side consists of two perpendiculars from numSide-sided
  //center to edge, plus one or more squares 
  //Assume they have side length one, then scale to fit sideLength.

  //Draw the polygon centered at the origin
  stroke(127);
  pushMatrix();;
  float ratioAltitudeToHalfSide = tan(PI / 2 - PI / numPolys);
  float polySideLength = sideLength / (ratioAltitudeToHalfSide + numSquaresPerSide);
  float polyAltitude = ratioAltitudeToHalfSide * polySideLength / 2;
  pushMatrix();;
  //rotate vertex into position
  rotate(-PI / 2 + PI / numSides() * 2);
  translate(-polySideLength / 2, -polyAltitude);
  drawPolyVertex(polySideLength);
  popMatrix();;

  fill(225);
  translate(polyAltitude + polySideLength / 2, 0);
  rectMode(CENTER);
  for (float squareCtr = 0; squareCtr < numSquaresPerSide; ++squareCtr) {
    rect(0, 0, polySideLength, polySideLength);
    translate(polySideLength, 0);
  }
  popMatrix();

}