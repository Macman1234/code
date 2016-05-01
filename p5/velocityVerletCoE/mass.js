"use strict";

var Mass = class Mass {
  constructor(m, x, y, vx, vy, clr) {
    this.mass = m;
    this.p = new Vector2D(x, y);
    this.previousP = this.p; //needed for drawing
    this.v = new Vector2D(vx, vy);
    this.clr = clr;
    this.testCounter = 0;
  }

  updatePosition() {
    this.previousP = this.p;
    this.p = this.p.plus(this.v.scaleBy(timeStep)).plus(this.a.scaleBy(sqrd(timeStep) * 0.5));
  }

  updateVelocityAndAcceleration(nextAcceleration) {
    this.v = this.v.plus(nextAcceleration.plus(this.a).scaleBy(timeStep * 0.5));
    //correct KineticEnergy to satisfy CoE
    // var newKE = this.totalEnergy - this.potentialEnergy();
    // var correctSpeed = sqrt(2 * newKE / this.mass);
    // this.v = this.v.scaleBy(correctSpeed / this.v.length);
    this.a = nextAcceleration;

    // correctVelocityForCoE() {
    //correct KineticEnergy to satisfy CoE
    // var newKE = this.totalEnergy - this.potentialEnergy();
    // var correctSpeed = sqrt(2 * newKE / this.mass);
    // var speedCorrectionFactor = correctSpeed / this.v.length;
    // // println(speedCorrectionFactor);
    // this.v = this.v.scaleBy(speedCorrectionFactor);
  
    // if (this.testCounter < 50) {
    //   ++this.testCounter;
    //   println("oldV=" + this.v.length + " newV=" + this.v.scaleBy(speedCorrectionFactor).length);
    // }
}

  forceTowards(m) {
    var force = gravConstant * this.mass * m.mass / this.p.dist2(m.p);
    return m.p.minus(this.p).normalized().scaleBy(force);
  }

  initializeAcceleration(startingAcceleration) {
    this.a = startingAcceleration;
  }

  initializeEnergy() {
    this.totalEnergy = this.potentialEnergy() + this.mass * sqrd(this.v.length) * 0.5;
  }

  potentialEnergy() {
    var u = 0;
    for (var massIndex in universe.masses) {
      var m = universe.masses[massIndex];
      if (m != this) {
        u -= m.mass / this.p.dist(m.p);
      }
    }
    return u * gravConstant * this.mass;
  }

};