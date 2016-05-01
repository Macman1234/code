"use strict";

var Mass = class Mass {
  constructor(m, x, y, vx, vy, clr) {
    this.mass = m;
    this.p = new Vector2D(x, y);
    this.vOriginal = new Vector2D(vx, vy);
    this.clr = clr;
  }


  firstMove(timeStep, acceleration) {
    this.previousP = this.p;
    this.p = this.p.plus(this.vOriginal.scaleBy(timeStep)).plus(acceleration.scaleBy(sqrd(timeStep) * 0.5));
    // this.moveForwardBy(timeStep, acceleration);
  }

  moveForwardBy(timeStep, acceleration) {
    var temp = this.p;
    this.p = this.p.scaleBy(2).minus(this.previousP).plus(acceleration.scaleBy(sqrd(timeStep)));
    this.previousP = temp;
    // println(this.p);
  }

  forceTowards(m) {
    var force = gravConstant * this.mass * m.mass / this.p.dist2(m.p);
    return m.p.minus(this.p).normalized().scaleBy(force);
  }
};
