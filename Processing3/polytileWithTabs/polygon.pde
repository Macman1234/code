class Polygon {
  Vector2D firstVertex;

  //Vertices are expected to be iterated in clockwise order. 
  //For drawing ellipses, stores midpoints of the sides, 
  //  where the previous vertex is the other side
  //And 
  Polygon(float x, float y) {
    Vector2D vertx, previousVertex = null;
    //First vertex is the
    //  first one closest to noon going counterclockwise.
    this.firstVertex = null;
    //calculate midpoints
    float angle = -PI / 2;
    for (int sideCtr = 0; sideCtr < NUMBER_OF_SIDES; ++sideCtr) {
      vertx = new Vector2D(x + DIST_TO_VERTEX * cos(angle), y + DIST_TO_VERTEX * sin(angle));
      if (previousVertex == null) {
        this.firstVertex = vertx;
      }
      previousVertex = vertx;
      angle -= TWO_PI / NUMBER_OF_SIDES;
    }
  }

  void draw() {
    noFill();
    stroke(0);
    strokeWeight(0.072);
    //draw sides
    //extra side is hack to get crisp corners: draw first side twice
    // beginShape();
    //draw sides
    //extra side is hack to get crisp corners: draw first side twice
    translate(toScreenX(firstVertex.x), toScreenY(firstVertex.y));
    //firstSideRotation is rotation needed to draw on segment (0,0) to (1,0)
    float firstSideRotation = - PI * (1 + 1.0 / NUMBER_OF_SIDES);
    rotate(firstSideRotation);
    for (int sideCtr = 0; sideCtr < NUMBER_OF_SIDES + 1; ++sideCtr) {
      pushMatrix();
      for (int halfSideCtr = 0; halfSideCtr < 2; ++halfSideCtr) {
        this.drawHalfSegment();
        translate(screenSideLength(), 0);
        rotate(PI);
      }
      popMatrix();
      // rect(0, 0, 2, 2); //show vertex
      translate(screenSideLength(), 0);
      rotate(-TWO_PI / NUMBER_OF_SIDES);
    }
  }

  void drawHalfSegment() {
    //from 0,0 to screenSideLength() * 0.5, 0
    float segmentLength = screenSideLength() * 0.5;
    float miniPolygonSideLengthFractionOfSideLength = 0.1;
    float miniSideLength = miniPolygonSideLengthFractionOfSideLength * screenSideLength();
    beginShape();
    vertex(0, 0);
    vertex(segmentLength - miniSideLength, 0);
    float distToVertex = DIST_TO_VERTEX / SIDE_LENGTH * miniSideLength ;
    Vector2D tabCenter = new Vector2D(segmentLength - miniSideLength * 0.5, ALTITUDE / SIDE_LENGTH * miniSideLength  );
    float angle = HALF_PI / NUMBER_OF_SIDES;
    for (int sideCtr = 0; sideCtr < NUMBER_OF_SIDES - 1; ++sideCtr) {
      vertex(tabCenter.x - distToVertex * cos(angle), tabCenter.y + distToVertex * sin(angle));
      angle += TWO_PI / NUMBER_OF_SIDES;
    }
    vertex(segmentLength, 0);
    endShape();
  }
}