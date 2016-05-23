"use strict";

var Pentagon = class Pentagon {
  constructor(x, y, pointUp) {
    this.x = x;
    this.y = y;
    this.pointUp = pointUp;
    this.vertices = [];
    this.midPoints = [];
    var previousVertex = null;
    var firstVertex = null;
    var angle = -PI / 2 + (this.pointUp ? 0 : PI / 5);
    for (var sideCtr = 0; sideCtr < 5; ++sideCtr) {
      var x = this.x + DIST_TO_VERTEX * cos(angle);
      var y = this.y + DIST_TO_VERTEX * sin(angle);
      var vertx = new Vector2D(x, y);
      this.vertices.push(vertx);
      if (!previousVertex) {
        firstVertex = vertx;
      } else {
        this.midPoints.push(vertx.midPoint(previousVertex));
      }
      previousVertex = vertx;
      // text(sideCtr, x, y);
      angle -= TWO_PI / 5;
    }
    this.midPoints.push(firstVertex.midPoint(previousVertex));
  }


  distanceToMouse(x, y) {
    return dist(mouseX, mouseY, toScreenX(x), toScreenY(y));
  }


  draw() {
    push();
    noFill();
    stroke(0);
    beginShape();
    //drawing hack to get crisp corners: draw first side twice
    for (var sideCtr = 0; sideCtr <= 6; ++sideCtr) {
      var vertx = this.vertices[sideCtr % 5];
      vertex(toScreenX(vertx.x), toScreenY(vertx.y));
    }
    endShape();

    var hasFocus = this.distanceToMouse(this.x, this.y) < ALTITUDE * screenSideLength() * 1.1;
    if (hasFocus) {
      stroke(255, 0, 0);
      var diam = this.edgeRingDiameter();
      for (var sideCtr = 0; sideCtr < 5; ++sideCtr) {
        var midPoint = this.midPoints[sideCtr];
        ellipse(toScreenX(midPoint.x), toScreenY(midPoint.y), diam, diam);
      }
    }
    pop();
  }

  edgeRingDiameter() {
    return screenSideLength() * 0.2;
  }

  spawnedPentagon() {
    //if there is an edge with the mouse in the ring, 
    //create a new Pentagon on the adjacent edge
    for (var sideCtr = 0; sideCtr < 5; ++sideCtr) {
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