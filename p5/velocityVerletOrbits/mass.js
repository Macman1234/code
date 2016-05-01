"use strict";

var Mass = class Mass {
  constructor(m, x, y, vx, vy, clr) {
    this.mass = m;
    this.p = new Vector2D(x, y);
    this.previousP = this.p; //needed for drawing
    this.v = new Vector2D(vx, vy);
    this.clr = clr;
  }

  updatePosition() {
    this.previousP = this.p;
    this.p = this.p.plus(this.v.scaleBy(timeStep)).plus(this.a.scaleBy(sqrd(timeStep) * 0.5));
  }

  updateVelocityAndAcceleration(nextAcceleration) {
    this.v = this.v.plus(nextAcceleration.plus(this.a).scaleBy(timeStep * 0.5));
    this.a = nextAcceleration;
  }
  
  forceTowards(m) {
    var force = gravConstant * this.mass * m.mass / this.p.dist2(m.p);
    return m.p.minus(this.p).normalized().scaleBy(force);
  }

  initializeAcceleration(startingAcceleration) {
    this.a = startingAcceleration;
  }
};