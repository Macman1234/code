"use strict";

var numPolys;

//UI
var numPolysSlider;
var needsRedraw = true;

function setup() {
  createCanvas(640, 640);
  numPolysSlider = makeSlider("number of polygons", 3, 20, 3, 150, 20, 1);
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;

  background(255);
  numPolys = numPolysSlider.value();
  text(numPolys, 280, 33);
  translate(width / 2, height / 2);
  rotate(-PI / 2);
  for (var polyCtr = 0; polyCtr < numPolys; ++polyCtr) {
    drawPoly();
    rotate(2 * PI / numPolys);
  }
}

function numSides() {
  return numPolys % 2 == 0 ? numPolys : numPolys * 2;
}

function drawPoly() {
  var sideLength = PI * width / numSides() * 0.4;
  push();
  for (var sideCtr = 0; sideCtr < numSides(); ++sideCtr) {
    // noStroke();
    // fill(255, 0, 0);
    // ellipse(0, 0, 3, 3);
    line(0, 0, sideLength, 0);
    translate(sideLength, 0);
    rotate(2 * PI / numSides());
  }
  pop();
}