"use strict";

var sqrd = function sqrd(x) {
  return x * x;
}

var Vector2D = class Vector2D {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  copy() {
    return new Vector2D(this.x, this.y);
  }

  dist(v) {
    return sqrt(dist2(v));
  }

  dist2(v) {
    return sqrd(this.x - v.x) + sqrd(this.y - v.y);
  }

  get length() {
    return sqrt(sqrd(this.x)+sqrd(this.y));
  }

  minus(v) {
    return new Vector2D(this.x - v.x, this.y - v.y);
  }

  incrementBy(v) {
    this.x += v.x;
    this.y += v.y;
  }


  normalized() {
    var length = sqrt(sqrd(this.x) + sqrd(this.y));
    if (length == 0) {
      return this;
    }
    return this.scaleBy(1.0 / length);
  }

  plus(v) {
    return new Vector2D(this.x + v.x, this.y + v.y);
  }

  scaleBy(s) {
    return new Vector2D(this.x * s, this.y * s);
  }
}