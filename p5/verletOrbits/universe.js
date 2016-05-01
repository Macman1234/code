"use strict";

var Universe = class Universe {
  constructor() {
    this.masses = [];
    this.firstStepComplete = false;
  }

  addMass(mass, x, y, vx, vy, clr) {
    var mass = new Mass(mass, x, y, vx, vy, clr);
    this.masses.push(mass);
  }

  moveForwardBy(timeStep) {
    //compute all accelerations based on current positions...
    var accelerations = [];
    for (var massIndex in this.masses) {
      var mass = this.masses[massIndex];
      accelerations.push(this.accelerationOnMass(mass));
    }
    //then apply the accelerations
    if (!this.firstStepComplete) {
      for (var massIndex in this.masses) {
        var mass = this.masses[massIndex];
        mass.firstMove(timeStep, accelerations[massIndex]);
      }
      this.firstStepComplete = true;
    } else {
      for (var massIndex in this.masses) {
        var mass = this.masses[massIndex];
        mass.moveForwardBy(timeStep, accelerations[massIndex]);
      }
    }
  }

  accelerationOnMass(m) {
    var force = new Vector2D(0, 0);
    for (var massIndex in this.masses) {
      var m_ = this.masses[massIndex];
      if (m_ != m) {
        force.incrementBy(m.forceTowards(m_));
      }
    }
    return force.scaleBy(1.0 / m.mass);
  }
};