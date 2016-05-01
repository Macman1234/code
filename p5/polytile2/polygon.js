"use strict";

var Polygon = class Polygon {
  constructor(numVertices, x, y, rotation) {
    this.numVertices = numVertices;
    this.x = x;
    this.y = y;
    while (rotation >= TWO_PI / numVertices) {
      rotation -= TWO_PI / numVertices;
    }
    this.rotation = rotation;
    this.vertices = [];
    this.midPoints = [];
    this.altitude = sideLength / 2 / tan(PI / this.numVertices);
    this.distToVertex = sqrt(this.altitude * this.altitude + sideLength * sideLength / 4);

    var previousVertex = null;
    var firstVertex = null;
    var angle = this.rotation + (numVertices % 2 == 0 ? PI / numVertices : 0);
    for (var sideCtr = 0; sideCtr < numVertices; ++sideCtr) {
      var x = this.x + this.distToVertex * cos(angle);
      var y = this.y + this.distToVertex * sin(angle);
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
    return this.distFromMouse(scale_, this.x, this.y) < this.altitude * 1.1;
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

  edgeRingDiameter() {
    return sideLength * 0.3;
  }

  spawnedPolygon(scale_) {
    //if there is an edge with the mouse in the ring, 
    //create a new Polygon on the adjacent edge
    for (var sideCtr = 0; sideCtr < this.numVertices; ++sideCtr) {
      var midPoint = this.midPoints[sideCtr];
      if (this.distFromMouse(scale_, midPoint.x, midPoint.y) < this.edgeRingDiameter() / 2) {
        //cursor in the ring! create a Polygon...
        var thisCenter = new Vector2D(this.x, this.y);
        var vecToPoly = midPoint.minus(thisCenter);
        var rotation = vecToPoly.angle();// + (this.numVertices % 2 == 0) ? HALF_PI/2 : 0;
        var polyCenter = vecToPoly.scaleBy((this.altitude + nextPolygonAlitude()) / this.altitude).plus(thisCenter);
        return new Polygon(nextNumberOfSides(), polyCenter.x, polyCenter.y, rotation);
      }
    }
  }

  distFromMouse(scale_, x, y) {
    return dist((mouseX - width / 2) / scale_, (mouseY - height / 2) / scale_, x, y);
  }
}