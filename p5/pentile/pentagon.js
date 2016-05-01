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
      var x = this.x + distToVertex * cos(angle);
      var y = this.y + distToVertex * sin(angle);
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

  draw() {
    push();
    stroke(0);
    var hasFocus = dist(mouseX, mouseY, this.x, this.y) < altitude * 1.1;
    // strokeWeight(hasFocus ? 3 : 1);

    noFill();
    stroke(0);
    beginShape();
    for (var sideCtr = 0; sideCtr < 5; ++sideCtr) {
      var vertx = this.vertices[sideCtr];
      vertex(vertx.x, vertx.y);
      // text(sideCtr, vertx.x, vertx.y);
    }
    endShape(CLOSE);

    if (hasFocus) {
      stroke(255, 0, 0);
      var diam = this.edgeRingDiameter();
      for (var sideCtr = 0; sideCtr < 5; ++sideCtr) {
        var midPoint = this.midPoints[sideCtr];
        ellipse(midPoint.x, midPoint.y, diam, diam);
      }
    }
    pop();
    // noStroke();
    // fill(255, 0, 0);
    // ellipse(this.x, this.y, 5, 5);
  }

  edgeRingDiameter() {
    return sideLength * 0.2;
  }

  spawnedPentagon() {
    //if there is an edge with the mouse in the ring, 
    //create a new Pentagon on the adjacent edge
    for (var sideCtr = 0; sideCtr < 5; ++sideCtr) {
      var midPoint = this.midPoints[sideCtr];
      if (dist(mouseX, mouseY, midPoint.x, midPoint.y) < this.edgeRingDiameter() / 2) {
        //cursor in the ring! create a Pentagon...
        var xNew = this.x + 2 * (midPoint.x - this.x);
        var yNew = this.y + 2 * (midPoint.y - this.y);
        return new Pentagon(xNew, yNew, !this.pointUp);
      }
    }
  }
}