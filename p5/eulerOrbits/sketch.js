"use strict";

var gravConstant = 2e2;
var timeStep = 0.05;

var sqrd = function sqrd(x) {
  return x * x;
}

var TwoDVector = class TwoDVector {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  copy() {
    return new TwoDVector(this.x, this.y);
  }

  dist(v) {
    return sqrt(dist2(v));
  }

  dist2(v) {
    return sqrd(this.x - v.x) + sqrd(this.y - v.y);
  }

  minus(v) {
    return new TwoDVector(this.x - v.x, this.y - v.y);
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
    return new TwoDVector(this.x + v.x, this.y + v.y);
  }

  scaleBy(s) {
    return new TwoDVector(this.x * s, this.y * s);
  }
}

var Mass = class Mass {
  constructor(m, x, y, vx, vy) {
    this.mass = m;
    this.p = new TwoDVector(x, y);
    this.v = new TwoDVector(vx, vy);
    this.previousP = this.p.copy();
  }

  moveForwardBy(timeStep, acceleration) {
    this.previousP = this.p.copy();
    var deltaP = this.v.scaleBy(timeStep).plus(acceleration.scaleBy(timeStep * 0.5));
    this.p.incrementBy(deltaP);
    var deltaV = acceleration.scaleBy(timeStep);
    this.v.incrementBy(deltaV);
  }

  forceTowards(m) {
    var force = gravConstant * this.mass * m.mass / this.p.dist2(m.p);
    return m.p.minus(this.p).normalized().scaleBy(force);
  }
};

var MassSystem = class MassSystem {
  constructor() {
    this.masses = [];
    // this.time = 0.0;
  }

  addMass(mass, x, y, vx, vy) {
    var mass = new Mass(mass, x, y, vx, vy);
    this.masses.push(mass);
  }

  moveForwardBy(timeStep) {
    var accelerations = [];
    for (var massIndex in this.masses) {
      var mass = this.masses[massIndex];
      accelerations.push(this.accelerationOnMass(mass));
    }
    for (var massIndex in this.masses) {
      var mass = this.masses[massIndex];
      mass.moveForwardBy(timeStep, accelerations[massIndex]);
    }
  }

  accelerationOnMass(m) {
    var force = new TwoDVector(0, 0);
    for (var massIndex in this.masses) {
      var m_ = this.masses[massIndex];
      if (m_ != m) {
        force.incrementBy(m.forceTowards(m_));
      }
    }
    return force.scaleBy(1.0 / m.mass);
  }
};

var universe = new MassSystem();

function setup() {
  createCanvas(1000, 1000);
  var numMasses = 3;
  var mass_ = 5;
  for (var i = 0; i < numMasses; i++) {
    var angle = i * 2 * PI / numMasses;
    var x = width * 0.3 * cos(angle);
    var y = width * 0.3 * sin(angle);
    var vAngle = angle + PI / 2;
    var speed = 1.5;
    var vx = speed * cos(vAngle);
    var vy = speed * sin(vAngle);
    universe.addMass(mass_, x, y, vx, vy);
  }
  var numMasses = 4;
  for (var i = 0; i < numMasses; i++) {
    var angle = i * 2 * PI / numMasses;
    var x = width * 0.1 * cos(angle);
    var y = width * 0.1 * sin(angle);
    var vAngle = angle + 1;
    var speed = 3.8;
    var vx = speed * cos(vAngle);
    var vy = speed * sin(vAngle);
    universe.addMass(mass_, x, y, vx, vy);
  }

  background(0);
}

function draw() {
  translate(width / 2, height / 2);
  scale(1, -1);
  stroke(255);
  strokeWeight(1);
  for (var i = 0; i < 1; ++i) {
    for (var massIndex in universe.masses) {
      var mass = universe.masses[massIndex];
      var previousP = mass.previousP;
      var p = mass.p;
      line(previousP.x, previousP.y, p.x, p.y);
    }
    universe.moveForwardBy(timeStep);
  }
}