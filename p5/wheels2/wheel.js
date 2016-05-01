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
    //now we have xNew and yNew, but no twisting yet
    var twist = dist(0,0,xNew, yNew) * twistSlider.value() * 0.0001;
    var xTwisted = xNew * cos(twist) - yNew * sin(twist);
    var yTwisted = xNew * sin(twist) + yNew * cos(twist);
    
    if (this.wheelAtPenRadius == null) {
      if (this.initialized) {
        stroke(this.colour);
        if (fixedPenWidth) {
          strokeWeight(maxPenWidth);
        } else {
          strokeWeight(dist(0,0,xTwisted, yTwisted) / width / WIDTH_MULTIPLIER * maxPenWidth);
        }
        line(this.xPrevious, this.yPrevious, xTwisted, yTwisted);
      }
      this.initialized = true;
    } else {
      this.wheelAtPenRadius.drawCenteredAt(xTwisted, yTwisted);
    }

    this.xPrevious = xTwisted;
    this.yPrevious = yTwisted;
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