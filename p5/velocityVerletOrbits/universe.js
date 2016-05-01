"use strict";

var Universe = class Universe {
  constructor() {
    this.masses = [];
    this.initializedAccelerations = false;
  }

  addMass(mass, x, y, vx, vy, clr) {
    if (this.initializedAccelerations) {
      throw "Cannot addMass to Universe after initialization.";
    }
    var mass = new Mass(mass, x, y, vx, vy, clr);
    this.masses.push(mass);
  }

  moveForwardBy(timeStep) {
    if (!this.initializedAccelerations) {
      this.initializeAccelerations();
    }
   //advance the position
    for (var massIndex in this.masses) {
      var mass = this.masses[massIndex];
      mass.updatePosition();
    }
   //compute all accelerations based on current positions...
    var accelerations = [];
    for (var massIndex in this.masses) {
      var mass = this.masses[massIndex];
      accelerations.push(this.accelerationOnMass(mass));
    }
    //then apply the accelerations
    for (var massIndex in this.masses) {
      var mass = this.masses[massIndex];
      mass.updateVelocityAndAcceleration(accelerations[massIndex]);
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

  initializeAccelerations() {
    for (var massIndex in this.masses) {
      var mass = this.masses[massIndex];
      mass.initializeAcceleration(this.accelerationOnMass(mass));
    }
    this.initializedAccelerations = true;
  }
};