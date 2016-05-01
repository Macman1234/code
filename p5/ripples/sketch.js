"use strict";

var dRadius;
var backgroundGreyLevel = 255;
var needsRedraw = true;

//UI
var numberStonesSlider, ripplesBetweenCentersSlider, distanceBetweenCentersSlider, penSizeSlider, frameThicknessSlider;

function setup() {
  createCanvas(720, 880);

  var widgetOffset = 180;
  numberStonesSlider = makeSlider("# stones", 2, 10, 3, widgetOffset, 20, 1);
  ripplesBetweenCentersSlider = makeSlider("# ripples between centers", 1, 20, 6, widgetOffset, 50, 1);
  distanceBetweenCentersSlider = makeSlider("distance between centers", 0.1, 1, 0.5, widgetOffset, 80, 0.02);
  penSizeSlider = makeSlider("pen size", 0.1, 1, .55, widgetOffset, 110, 0.05);
  frameThicknessSlider = makeSlider("frameThickness", 0.1, 1, .55, widgetOffset, 140, 0.05);

}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  drawImageOnly();

  //add labels
  noStroke();
  fill(255, 0, 0);
  var labelOffset = 400;
  text("" + numberStonesSlider.value(), labelOffset, 33);
  text("" + ripplesBetweenCentersSlider.value(), labelOffset, 63);
  text("" + distanceBetweenCentersSlider.value(), labelOffset, 93);
  text("" + penSizeSlider.value(), labelOffset, 123);
  text("" + frameThicknessSlider.value(), labelOffset, 153);
  var msg = "Type 's' to save as PNG.";
  text(msg, (width - textWidth(msg)) / 2, 20);

}

function drawImageOnly() {
  push();
  dRadius = width * 0.2 * distanceBetweenCentersSlider.value();
  background(backgroundGreyLevel);

  translate(width / 2, height - width / 2);
  scale(1, -1);
  strokeWeight(width * 0.03 * penSizeSlider.value());

  var ripplesBetweenCenters = ripplesBetweenCentersSlider.value();
  // var yShift = dRadius * numberOfRadiusesPerSide * 0.5 / sqrt(3) * 1.5;

  var numCenters = numberStonesSlider.value();
  var distBetweenCenters = dRadius * (ripplesBetweenCenters + 1);
  var radiusOfCircleOfCenters = distBetweenCenters / 2 / sin(PI / numCenters);
  var angle = HALF_PI;
  for (var centerCtr = 0; centerCtr < numCenters; ++centerCtr) {
    var x = radiusOfCircleOfCenters * cos(angle);
    var y = radiusOfCircleOfCenters * sin(angle);
    drawEllipsesAbout(x, y);
    angle += TWO_PI / numCenters;
  }

  //draw centers (TESTING ONLY)
  // fill(255, 255, 0);
  // noStroke();
  // for (var centerCtr = 0; centerCtr < numCenters; ++centerCtr) {
  //   var x = radiusOfCircleOfCenters * cos(angle);
  //   var y = radiusOfCircleOfCenters * sin(angle);
  //   ellipse(x, y, 10, 10);
  //   angle += TWO_PI / numCenters;
  // }

  drawFrame();
  pop();
  //clear stuff above drawing
  noStroke();
  rect(0, 0, width, height - width);
}

function drawFrame() {
  //black frame
  noFill();
  stroke(0);
  rectMode(CENTER);
  strokeWeight(width * frameThicknessSlider.value() * 0.2);
  rect(0, 0, width, width);
  //white clipping frame 
  stroke(backgroundGreyLevel);
  strokeWeight(dRadius * frameThicknessSlider.value() * 0.4);
  rect(0, 0, width, width);
}

function drawEllipsesAbout(x, y) {
  noFill();
  stroke(255 - backgroundGreyLevel);
  for (var radius = dRadius; radius < dist(0, 0, width, width); radius += dRadius) {
    var diameter = radius * 2;
    ellipse(x, y, diameter, diameter);
  }
}

function keyTyped() {
  if (key == 's') {
    createCanvas(2000, 2000);
    drawImageOnly();
    var filename = 'ripples' + timeStampText() + '.png';
    save(filename);
    createCanvas(720, 880);
    needsRedraw = true;
  }
}