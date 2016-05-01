"use strict";

/* rectangular box with slanted sides*/

var MM_PER_INCH = 25.4;
var boxTopLength = 12 * MM_PER_INCH;
var boxBottomLength = 9 * MM_PER_INCH;
var boxHeight = 8 * MM_PER_INCH;
var fingersPerEdge = 12;
var floorHeight = 6.0;
var materialDepth = 3.0;
var fcs;

function setup() {
  createCanvas(800, 800);
  // resizeCanvas(640, 480);
  fcs = new FunctionCallSequence("box.json");
  clear();
  drawOneTime();
}

function drawOneTime() {
  //offset from corner a little
  fcs.background(255);
  fcs.strokeWeight(0.5);
  var offset = 5;
  fcs.translate(offset, offset);
  fcs.push();
  drawSideA();
  fcs.pop();
  fcs.translate(boxTopLength + offset*2, 0)
  drawSideA();

  fcs.writeToFile();
}

function drawSideA() {
  //start with top of box, then right vertical, bottom, left vertical
  fcs.line(0, 0, boxTopLength, 0);
  fcs.translate(boxTopLength, 0);
  var insetBottomFromTop = 0.5 * (boxTopLength - boxBottomLength);
  var edgeLength = dist(0, 0, boxHeight, insetBottomFromTop);
  var dAngleFromRightAngle = asin(insetBottomFromTop / edgeLength);
  fcs.rotate(PI / 2 + dAngleFromRightAngle);
  drawEdge(edgeLength, fingersPerEdge);
  fcs.rotate(PI / 2 - dAngleFromRightAngle);
  fcs.line(0, 0, boxBottomLength, 0);
  fcs.translate(boxBottomLength, 0);
  fcs.rotate(PI / 2 - dAngleFromRightAngle);
  drawEdge(edgeLength, fingersPerEdge);
}

function drawEdge(len, numFingers) {
  var fingerWidth = 0.5 * len / numFingers;
  for (var fingerCtr = 0; fingerCtr < numFingers; ++fingerCtr) {
    fcs.line(0, 0, fingerWidth, 0);
    fcs.line(fingerWidth, 0, fingerWidth, -materialDepth);
    fcs.line(fingerWidth, -materialDepth, fingerWidth * 2, -materialDepth);
    fcs.line(fingerWidth * 2, -materialDepth, fingerWidth * 2, 0);
    fcs.translate(fingerWidth * 2, 0);
  }
}