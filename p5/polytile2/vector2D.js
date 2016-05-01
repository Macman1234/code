"use strict";

var sqrd = function sqrd(x) {
  return x * x;
}

var Vector2D = class Vector2D {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  angle() {
    //range [0, TWO_PI)
    if (this.x == 0) {
      return this.y > 0 ? HALF_PI : TWO_PI - HALF_PI;
    }
    if (this.y == 0) {
      return this.x > 0 ? 0 : PI;
    }
    if (this.y > 0) {
      return this.x > 0 ? atan(this.y / this.x) : PI - atan(-this.y / this.x);
    }
    return this.x > 0 ? TWO_PI + atan(this.y / this.x) : PI + atan(this.y / this.x);
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
    return sqrt(sqrd(this.x) + sqrd(this.y));
  }

  midPoint(v) {
    return new Vector2D((this.x + v.x) * 0.5, (this.y + v.y) * 0.5);
  }

  easeTowards(v, easing) {
    return new Vector2D(this.x * (1 - easing) + v.x * easing, this.y * (1 - easing) + v.y * easing);
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

  rotate(angle) {
    var cosA = cos(angle);
    var sinA = sin(angle);
    return new Vector2D(this.x * cosA - this.y * sinA, this.x * sinA + this.y * cosA);
  }

  scaleBy(s) {
    return new Vector2D(this.x * s, this.y * s);
  }
}