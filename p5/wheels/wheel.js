"use strict";


var Wheel = class Wheel {
  constructor(penRadius, angularRate, colour) {
    this.penRadius = penRadius;
    this.angularRate = angularRate;
    this.colour = colour;
    this.time = 0;
    this.xPrevious = this.x(0);
    this.yPrevious = this.y(0);
    this.wheelAtPenRadius = null;
    this.initialized = false;
  }

  drawCenteredAt(xCenter, yCenter) {
    var angle = time * this.angularRate;
    var xNew = xCenter + this.x(angle);
    var yNew = yCenter + this.y(angle);
    if (this.wheelAtPenRadius == null) {
      if (this.initialized) {
        stroke(this.colour);
        if (fixedPenWidth) {
          strokeWeight(MAX_PEN_WIDTH);
        } else {
          strokeWeight(sqrt(sqrt(xNew * xNew + yNew * yNew) / width) * MAX_PEN_WIDTH);
        }
        line(this.xPrevious, this.yPrevious, xNew, yNew);
      }
      this.initialized = true;
    } else {
      this.wheelAtPenRadius.drawCenteredAt(xNew, yNew);
    }

    this.xPrevious = xNew;
    this.yPrevious = yNew;
  }

  setSubwheel(wheelAtPenRadius) {
    if (this.wheelAtPenRadius == null) {
      this.wheelAtPenRadius = wheelAtPenRadius;
    } else {
      this.wheelAtPenRadius.setSubwheel(wheelAtPenRadius);
    }
  }

  x(angle) {
    return sin(angle) * this.penRadius;
  }

  y(angle) {
    return cos(angle) * this.penRadius;
  }
};