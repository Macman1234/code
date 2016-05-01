"use strict";

var gravConstant, timeStep;
var universe = new Universe();
var strokeWeightFunction;
var linesPerFrame = 25;
var fade = false;

function setup() {
  createCanvas(800, 800);
  // polygonVerticesSetup(9);
  threeBodySetup();
  background(0);
}

function fixedStrokeWeight(p) {
  strokeWeight(3);
}

function variableStrokeWeight(p) {
  strokeWeight(p.length * width * 0.00005);
}

function draw() {
  if (fade) {
    fill(0, 10);
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

function threeBodySetup() {
  gravConstant = 5e2;
  timeStep = 0.03;
  strokeWeightFunction = fixedStrokeWeight;

  var sizeScalar = 0.6;
  var alpha = 255;
  universe.addMass(1, -width * 0.25 * sizeScalar, width * 0.25 * sizeScalar, 1, -1, color(255, 0, 0, alpha));
  universe.addMass(2, width * 0.125 * sizeScalar, width * 0.25 * sizeScalar, 1, -1, color(0, 255, 0, alpha));
  universe.addMass(3, -width * 0.125 / 3 * sizeScalar, -width * 0.25 * sizeScalar, -1, 1, color(255, alpha));
}

function polygonVerticesSetup(numMasses) {
  gravConstant = 1e2;
  timeStep = 0.01;
  strokeWeightFunction = fixedStrokeWeight;

  var radiusMultiplier = 0.3;
  var mass_ = 5;
  for (var i = 0; i < numMasses; i++) {
    var angle = i * 2 * PI / numMasses;
    var x = width * radiusMultiplier * cos(angle);
    var y = width * radiusMultiplier * sin(angle);
    var vAngle = angle + PI / 2;
    var speed = 1.5;
    var vx = speed * cos(vAngle);
    var vy = speed * sin(vAngle);
    universe.addMass(mass_, x, y, vx, vy, color(0, 255, 0));
  }
}

function polygonVerticesSetup2(numMasses) {
  gravConstant = 5e2;
  timeStep = 0.02;

  var radiusMultiplier = 0.3;
  var mass_ = 5;
  for (var i = 0; i < numMasses; i++) {
    var angle = i * 2 * PI / numMasses;
    var x = width * radiusMultiplier * cos(angle);
    var y = width * radiusMultiplier * sin(angle);
    var vAngle = angle + PI / 2;
    var speed = 1.5;
    var vx = speed * cos(vAngle);
    var vy = speed * sin(vAngle);
    universe.addMass(mass_, x, y, vx, vy);
  }
  var numMasses = 3;
  var radiusMultiplier = 0.2;
  for (var i = 0; i < numMasses; i++) {
    var angle = i * 2 * PI / numMasses;
    var x = width * radiusMultiplier * cos(angle);
    var y = width * radiusMultiplier * sin(angle);
    var vAngle = angle + 1;
    var speed = 3.6;
    var vx = speed * cos(vAngle);
    var vy = speed * sin(vAngle);
    universe.addMass(mass_, x, y, vx, vy);
  }
}