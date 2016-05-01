"use strict";

var Universe = class Universe {
  constructor() {
    this.masses = [];
    this.initialized = false;
  }

  addMass(mass, x, y, vx, vy, clr) {
    if (this.initialized) {
      throw "Cannot addMass to Universe after initialization.";
    }
    var mass = new Mass(mass, x, y, vx, vy, clr);
    this.masses.push(mass);
  }

  moveForwardBy(timeStep) {
    if (!this.initialized) {
      this.initialize();
    }
    //update positions
    for (var massIndex in this.masses) {
      this.masses[massIndex].updatePosition();
    }
    //compute new accelerations based on updated positions...
    var accelerations = [];
    for (var massIndex in this.masses) {
      accelerations.push(this.accelerationOnMass(this.masses[massIndex]));
    }
    //update velocity (corrected to satisfy CoE)
    for (var massIndex in this.masses) {
      this.masses[massIndex].updateVelocityAndAcceleration(accelerations[massIndex]);
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

  initialize() {
    for (var massIndex in this.masses) {
      var mass = this.masses[massIndex];
      mass.initializeAcceleration(this.accelerationOnMass(mass));
      mass.initializeEnergy();
    }
    this.initialized = true;
  }
};