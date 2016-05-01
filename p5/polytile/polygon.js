"use strict";

var Polygon = class Polygon {
  constructor(numVertices, x, y, pointRight) {
    this.numVertices = numVertices;
    this.x = x;
    this.y = y;
    this.pointRight = pointRight;
    this.vertices = [];
    this.midPoints = [];
    var previousVertex = null;
    var firstVertex = null;
    var angle = (this.pointRight ? 0 : PI / this.numVertices);
    for (var sideCtr = 0; sideCtr < numVertices; ++sideCtr) {
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
      angle -= TWO_PI / this.numVertices;
    }
    this.midPoints.push(firstVertex.midPoint(previousVertex));
  }

  draw(scale_) {
    push();
    stroke(0);

    fill(50, 15);
    stroke(0);
    scale(scale_);
    beginShape();
    for (var sideCtr = 0; sideCtr < this.numVertices; ++sideCtr) {
      var vertx = this.vertices[sideCtr]; //.minus(origin);
      vertex(vertx.x, vertx.y);
    }
    endShape(CLOSE);
    pop();
  }

  hasFocus(scale_) {
    return this.distFromMouse(scale_, this.x, this.y) < altitude * 1.1;
  }

  drawRings(scale_) {
    push();
    if (this.hasFocus(scale_)) {
      scale(scale_);
      stroke(255, 0, 0);
      var diam = this.edgeRingDiameter();
      for (var sideCtr = 0; sideCtr < this.numVertices; ++sideCtr) {
        var midPoint = this.midPoints[sideCtr];
        ellipse(midPoint.x, midPoint.y, diam, diam);
      }
    }
    pop();
  }

  drawEdgeNumbers(scale_) {
    push();
    fill(100, 10);
    scale(scale_);
    var txtSize = 10.0;
    textSize(txtSize);
    var edgeNumber = this.pointRight ? 1 : 0;
    var easing = 0.8;
    for (var sideCtr = 0; sideCtr < this.numVertices; ++sideCtr) {
      var lowerLeftOfText = new Vector2D(this.x, this.y).easeTowards(this.midPoints[sideCtr], easing);
      text(edgeNumber, lowerLeftOfText.x - textWidth(edgeNumber) * 0.5, lowerLeftOfText.y + txtSize * 0.5);
      edgeNumber += 2;
    }
    pop();
  }

  edgeRingDiameter() {
    return sideLength * 0.3;
  }

  edgeTouching(otherPoly) {
    //there is a better way to do this...
    var epsilon = 1e-4;
    if (abs(dist(this.x, this.y, otherPoly.x, otherPoly.y) - altitude * 2) > epsilon) {
      return -1;
    }
    //they are touching!
    var edgeNumber = this.pointRight ? 1 : 0;

    for (var sideCtr = 0; sideCtr < this.numVertices; ++sideCtr) {
      var midPoint = this.midPoints[sideCtr];
      var xNew = this.x + 2 * (midPoint.x - this.x);
      var yNew = this.y + 2 * (midPoint.y - this.y);
      if (dist(xNew, yNew, otherPoly.x, otherPoly.y) < epsilon) {
        return edgeNumber;
      }
      edgeNumber += 2;
    }
  }

  spawnedPolygon(scale_) {
    //if there is an edge with the mouse in the ring, 
    //create a new Polygon on the adjacent edge
    for (var sideCtr = 0; sideCtr < this.numVertices; ++sideCtr) {
      var midPoint = this.midPoints[sideCtr];
      if (this.distFromMouse(scale_, midPoint.x, midPoint.y) < this.edgeRingDiameter() / 2) {
        //cursor in the ring! create a Polygon...
        var xNew = this.x + 2 * (midPoint.x - this.x);
        var yNew = this.y + 2 * (midPoint.y - this.y);
        return new Polygon(this.numVertices, xNew, yNew, !this.pointRight);
      }
    }
  }

  distFromMouse(scale_, x, y) {
    return dist((mouseX - width / 2) / scale_, (mouseY - height / 2) / scale_, x, y);
  }
}