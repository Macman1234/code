"use strict";

var gravConstant, timeStep;
var universe = new Universe();
var strokeWeightFunction;
var linesPerFrame = 50;
var fade = false;
var paused = false;

function setup() {
  createCanvas(800, 800);
  polygonVerticesSetup(12);
  // threeBodySetup();
  background(0);
}

function keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
}


function fixedStrokeWeight(p) {
  strokeWeight(3);
}

function variableStrokeWeight(p) {
  strokeWeight(p.length * width * 0.00005);
}

function draw() {
  if (paused) {
    return;
  }
  if (fade) {
    fill(0, 10);
    rect(0, 0, width, height);
  }
  translate(width / 2, height / 2);
  scale(1, -1);
  // println(frameCount);
  for (var i = 0; i < linesPerFrame; ++i) {
    universe.moveForwardBy(timeStep);
    for (var massIndex in universe.masses) {
      var mass = universe.masses[massIndex];
      stroke(mass.clr);
      var previousP = mass.previousP;
      var p = mass.p;
      strokeWeightFunction(p);
      line(previousP.x, previousP.y, p.x, p.y);
    }
  }
}

function threeBodySetup() {
  gravConstant = 5e2;
  timeStep = 0.02;
  strokeWeightFunction = fixedStrokeWeight;

  var sizeScalar = 0.6;
  var alpha = 255;
  universe.addMass(1, -width * 0.25 * sizeScalar, width * 0.25 * sizeScalar, 1, -1, color(255, 0, 0, alpha));
  universe.addMass(2, width * 0.125 * sizeScalar, width * 0.25 * sizeScalar, 1, -1, color(0, 255, 0, alpha));
  universe.addMass(3, -width * 0.125 / 3 * sizeScalar, -width * 0.25 * sizeScalar, -1, 1, color(255, alpha));
}

function polygonVerticesSetup(numMasses) {
  gravConstant = 1000;
  timeStep = 0.01;
  strokeWeightFunction = fixedStrokeWeight;

  var radiusMultiplier = 0.3;
  var mass_ = 1;
  for (var i = 0; i < numMasses; i++) {
    var angle = i * 2 * PI / numMasses;
    var x = width * radiusMultiplier * cos(angle);
    var y = width * radiusMultiplier * sin(angle);
    var vAngle = angle + PI / 2;
    var speed = 3;
    var vx = speed * cos(vAngle);
    var vy = speed * sin(vAngle);
    universe.addMass(mass_, x, y, vx, vy, color(0, 255, 0));
  }
}