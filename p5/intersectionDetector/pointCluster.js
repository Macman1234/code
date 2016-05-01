"use strict";

class PointCluster {

  constructor(x, y) {
    this.x_ = x;
    this.y_ = y;
    this.numPoints = 1;
  }

  add(x, y) {
    this.x_ += x;
    this.y_ += y;
    ++this.numPoints;
  }

  x() {
    return 1.0 * this.x_ / this.numPoints;
  }

  y() {
    return 1.0 * this.y_ / this.numPoints;
  }

  distanceTo(x, y) {
    return dist(x, y, this.x(), this.y());
  }

}