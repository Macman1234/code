"use strict";

/* Upcoming features?
..optional ring around edge
..find points of intersection, and stop drawing at last intersection before edge
..variable pen width
..optional center hole with ring
*/

var maxPenWidth = 30;
var fixedPenWidth = false;
var maxPenWidth = 30;
var needsRedraw = true;
var WIDTH_MULTIPLIER = 0.44;

var canvas, baseSlider, cwSpiralSlider, ccwSpiralSlider, maxPenWidthSlider;
var fixedPenWidthCheckbox;

function setup() {
  createCanvas(960, 960);

  baseSlider = makeSlider("base", 0.05, 2, 0.306, 90, 20, 0.001);
  cwSpiralSlider = makeSlider("CW spirals", 1, 21, 5, 90, 50, 1);
  ccwSpiralSlider = makeSlider("CCW spirals", 1, 21, 8, 90, 80, 1);
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  push();
  needsRedraw = false;
  background(255);
  translate(width / 2, height / 2);
  scale(1, -1);
  stroke(127);

  spiral(cwSpiralSlider.value());
  scale(-1, 1);
  spiral(ccwSpiralSlider.value());
  var d = width / 8;
  // fill(255);
  // ellipse(0, 0, d, d);
  noFill();
  stroke(255);
  strokeWeight(width);
  ellipse(0, 0, width * 1.99, width * 1.99);
  pop();

  //slider value labels
  var x = 305;
  text("" + baseSlider.value(), x, 33);
  text("" + cwSpiralSlider.value(), x, 63);
  text("" + ccwSpiralSlider.value(), x, 93);

}

function spiral(numArms) {
  for (var i = 0; i < numArms; ++i) {
    spiralArm();
    rotate(2 * PI / numArms);
  }
}

function radiusExponential(theta) {
  return exp(baseSlider.value() * theta);
}

function radiusQuadratic(theta) {
  return sqrt(theta) * 80;
}

function spiralArm() {
  var base = baseSlider.value();
  var theta = 0;//-PI;
  var dTheta = PI / 360;
  // var rMultiplier = pow(base, dtheta);
  var x, y, xPrev, yPrev;
  var r;
  var radius = radiusExponential;
  while ((r = radius(theta)) < width) {
    x = r * cos(theta);
    y = r * sin(theta);
    if (xPrev != null) {
      strokeWeight(dist(0, 0, x, y) / width * 20);
      // strokeWeight(2);
      line(xPrev, yPrev, x, y);
    }
    xPrev = x;
    yPrev = y;
    theta += dTheta;
  }
}