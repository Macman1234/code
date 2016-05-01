"use strict";

var gravConstant, timeStep;
var universe = new Universe();
var strokeWeightFunction;
var linesPerFrame = 50;
var fade = true;
var paused = false;

function setup() {
  createCanvas(800, 800);
  // polygonVerticesSetup(3, 0.4, PI /2, 1);
  // polygonVerticesSetup(4, 0.2, PI /2, -1.1);
  // threeBodyChaosSetup();
  threeBodyStableSetup();
  background(0);
}

function keyPressed() {
  if(key == ' ') {
    paused = !paused;
  }
}

function fixedStrokeWeight(p) {
  strokeWeight(1);
}

function variableStrokeWeight(p) {
  strokeWeight(p.length * width * 0.00005);
}

function draw() {
  if(paused) {
    return;
  }
  if (fade) {
    fill(0, 1.5);
    rect(0, 0, width, height);
  }
  translate(width / 2, height / 2);
  scale(1, -1);
  for (var i = 0; i < linesPerFrame; ++i) {
    for (var massIndex in universe.masses) {
      var mass = universe.masses[massIndex];
      stroke(mass.clr);
      var previousP = mass.previousP;
      var p = mass.p;
      strokeWeightFunction(p);
      line(previousP.x, previousP.y, p.x, p.y);
    }
    universe.moveForwardBy(timeStep);
  }
}

function threeBodyChaosSetup() {
  gravConstant = 5e2;
  timeStep = 0.03;
  strokeWeightFunction = fixedStrokeWeight;

  var sizeScalar = 0.6;
  var alpha = 255;
  universe.addMass(1, -width * 0.25 * sizeScalar, width * 0.25 * sizeScalar, 1, -1, color(255, 0, 0, alpha));
  universe.addMass(2, width * 0.125 * sizeScalar, width * 0.25 * sizeScalar, 1, -1, color(0, 255, 0, alpha));
  universe.addMass(3, -width * 0.125 / 3 * sizeScalar, -width * 0.25 * sizeScalar, -1, 1, color(255, alpha));
}

function threeBodyStableSetup() {
  gravConstant = 5e2;
  timeStep = 0.03;
  strokeWeightFunction = fixedStrokeWeight;

  var sizeScalar = 0.8;
  var alpha = 255;
  universe.addMass(10, 0, 0 , -0.4, 0, color(255, 0, 0, alpha));
  universe.addMass(1, 0, height * 0.5 * sizeScalar, 4, 0, color(0, 255, 0, alpha));
  universe.addMass(0.001, 0, height * 0.53 * sizeScalar, -1, 0, color(255, alpha));
}

function polygonVerticesSetup(numMasses, radiusMultiplier, angleFromCenter, speed) {
  gravConstant = 1e2;
  timeStep = 0.05;
  strokeWeightFunction = fixedStrokeWeight;

  var mass_ = 5;
  for (var i = 0; i < numMasses; i++) {
    var angle = i * 2 * PI / numMasses;
    var x = width * radiusMultiplier * cos(angle);
    var y = width * radiusMultiplier * sin(angle);
    var vAngle = angle + angleFromCenter;
    var vx = speed * cos(vAngle);
    var vy = speed * sin(vAngle);
    universe.addMass(mass_, x, y, vx, vy, color(0, 255, 0));
  }
}
