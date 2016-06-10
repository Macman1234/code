"use strict";

var Pentagon = class Pentagon {
  //Vertices are expected to be iterated in clockwise order. 
  //For drawing ellipses, stores midpoints of the sides, 
  //  where the previous vertex is the other side
  //And 
  constructor(x, y, pointUp) {
    this.x = x;
    this.y = y;
    this.pointUp = pointUp;
    this.midPoints = [];
    var vertx, previousVertex = null;
    //First vertex is the
    //  first one closest to noon going counterclockwise.
    this.firstVertex = null;
    //firstSideRotation is rotation needed to draw on segment (0,0) to (1,0)
    //calculate midpoints
    var angle = -PI / 2 + (this.pointUp ? 0 : PI / NUMBER_OF_SIDES);
    for (var sideCtr = 0; sideCtr < NUMBER_OF_SIDES; ++sideCtr) {
      var x = this.x + DIST_TO_VERTEX * cos(angle);
      var y = this.y + DIST_TO_VERTEX * sin(angle);
      vertx = new Vector2D(x, y);
      if (!previousVertex) {
        this.firstVertex = vertx;
      } else {
        this.midPoints.push(vertx.midPoint(previousVertex));
      }
      previousVertex = vertx;
      angle -= TWO_PI / NUMBER_OF_SIDES;
    }
    this.midPoints.push(this.firstVertex.midPoint(previousVertex));
  }


  distanceToMouse(x, y) {
    return dist(mouseX, mouseY, toScreenX(x), toScreenY(y));
  }

  draw() {
    this.drawTabbedPentagon();
  }

  drawHalfSegment() {
    //from 0,0 to screenSideLength() * 0.5, 0
    var segmentLength = screenSideLength() * 0.5;
    var miniPolygonSideLengthFractionOfSideLength = 0.1;
    var miniSideLength = miniPolygonSideLengthFractionOfSideLength * screenSideLength();
    beginShape();
    vertex(0, 0);
    vertex(segmentLength - miniSideLength, 0);
    var distToVertex = DIST_TO_VERTEX / SIDE_LENGTH * miniSideLength;
    var tabCenter = new Vector2D(segmentLength - miniSideLength * 0.5, ALTITUDE / SIDE_LENGTH * miniSideLength);
    var angle = HALF_PI / NUMBER_OF_SIDES;
    for (var sideCtr = 0; sideCtr < NUMBER_OF_SIDES - 1; ++sideCtr) {
      vertex(tabCenter.x - distToVertex * cos(angle), tabCenter.y + distToVertex * sin(angle));
      angle += TWO_PI / NUMBER_OF_SIDES;
    }
    vertex(segmentLength, 0);
    endShape();
  }


  drawTabbedPentagon() {
    push();
    noFill();
    stroke(0);
    var miniSideLength = SIDE_LENGTH * 0.4;
    strokeWeight(penSlider.value() * width / SCREEN_WIDTH);
    strokeCap(ROUND);
    //draw sides
    //extra side is hack to get crisp corners: draw first side twice
    // beginShape();
    //draw sides
    //extra side is hack to get crisp corners: draw first side twice
    push();
    translate(toScreenX(this.firstVertex.x), toScreenY(this.firstVertex.y));
    // rectMode(CENTER);
    // rect(0, 0, 5, 5);
    var firstSideRotation = -PI - (!this.pointUp ? 0 : PI / NUMBER_OF_SIDES);
    rotate(firstSideRotation);
    for (var sideCtr = 0; sideCtr < NUMBER_OF_SIDES + 1; ++sideCtr) {
      push();
      for (var halfSideCtr = 0; halfSideCtr < 2; ++halfSideCtr) {
        this.drawHalfSegment();
        translate(screenSideLength(), 0);
        rotate(PI);
      }
      pop();
      // rect(0, 0, 2, 2); //show vertex
      translate(screenSideLength(), 0);
      rotate(-TWO_PI / NUMBER_OF_SIDES);
    }
    pop();

    //draw handles
    if (!drawingForSave) {
      var hasFocus = this.distanceToMouse(this.x, this.y) < ALTITUDE * screenSideLength() * 1.1;
      if (hasFocus) {
        strokeWeight(2)
        stroke(255, 0, 0);
        var diam = this.edgeRingDiameter();
        for (var sideCtr = 0; sideCtr < NUMBER_OF_SIDES; ++sideCtr) {
          var midPoint = this.midPoints[sideCtr];
          ellipse(toScreenX(midPoint.x), toScreenY(midPoint.y), diam, diam);
        }
      }
      pop();
    }
  }


  edgeRingDiameter() {
    return screenSideLength() * 0.2;
  }

  spawnedPentagon() {
    //if there is an edge with the mouse in the ring, 
    //create a new Pentagon on the adjacent edge
    for (var sideCtr = 0; sideCtr < NUMBER_OF_SIDES; ++sideCtr) {
      var midPoint = this.midPoints[sideCtr];
      if (this.distanceToMouse(midPoint.x, midPoint.y) < this.edgeRingDiameter() / 2) {
        //cursor in the ring! create a Pentagon...
        var xNew = this.x + 2 * (midPoint.x - this.x);
        var yNew = this.y + 2 * (midPoint.y - this.y);
        return new Pentagon(xNew, yNew, !this.pointUp);
      }
    }
  }
}