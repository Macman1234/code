"use strict";

var needsRedraw = true;
var numPoints = 8;
var numLayers = 12;
var innerRadiusAsFractionOfOuter = 0.7;
var numPointsSlider, numLayersSlider, innerRadiusSlider;
var penSlider, slantSlider, curvatureSlider, roundedEndsCheckbox;

function setup() {
  createCanvas(800, 800);
  var sliderInset = 90;
  numPointsSlider = makeSlider("num points", 3, 50, 24, sliderInset, 20, 1);
  numLayersSlider = makeSlider("depth", 1, 50, 5, sliderInset, 50, 1);
  innerRadiusSlider = makeSlider("inner radius", 0.5, 0.95, 0.8, sliderInset, 80, 0.01);
  penSlider = makeSlider("pen", 0.1, 1, 0.5, sliderInset, 110, 0.01);
  curvatureSlider = makeSlider("curvature", -2, 2, 0.3, sliderInset, 140, 0.01);
  roundedEndsCheckbox = makeCheckbox("round ends", false, sliderInset, 170);
}

function keyTyped() {
  if (key == 's') {
    createCanvas(2000, 2000);
    drawImageOnly();
    var filename = 'gn' + Math.round(millis()) + '.png';
    save(filename);
    createCanvas(800, 800);
    needsRedraw = true;
  }
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  drawImageOnly();

  fill(127);
  noStroke();
  var valueTextOffset = 310;
  text(numPointsSlider.value(), valueTextOffset, 33);
  text(numLayersSlider.value(), valueTextOffset, 63);
  text(innerRadiusSlider.value(), valueTextOffset, 93);
  text(penSlider.value(), valueTextOffset, 123);
  text(curvatureSlider.value(), valueTextOffset, 153);
  var msg = "Type 's' to save as PNG."
  text(msg, (width - textWidth(msg)) / 2, 20);
}

function drawImageOnly() {
  push();
  stroke(0);
  noFill();
  translate(width * 0.5, height * 0.5);
  rotate(PI / numPointsSlider.value());

  background(255);
  strokeCap(roundedEndsCheckbox.checked() ? ROUND : SQUARE);
  var radius = width * 0.4;
  for (var layerCtr = 0; layerCtr < numLayersSlider.value(); ++layerCtr) {
    drawLayer(radius);
    radius *= innerRadiusSlider.value();
  }
  pop();
  // save('tunnel_' + numPointsSlider.value() + '_' + numLayersSlider.value() + '_' + round(innerRadiusSlider.value() * 100) + '_' + penSlider.value() + '.png');
}

function drawLayer(radius) {
  strokeWeight(width * 0.02 * penSlider.value());
  // var angleBetweenVertices = fractionSlant * TWO_PI / numPointsSlider.value();
  var innerRadius = radius * innerRadiusSlider.value();
  var angle = 0.0;
  var bezScale = curvatureSlider.value();
  for (var pointCtr = 0; pointCtr < numPointsSlider.value(); ++pointCtr) {
    var xAnchor0 = innerRadius * cos(angle);
    var yAnchor0 = innerRadius * sin(angle);
    var cpRadius = bezScale * radius + (1 - bezScale) * innerRadius;
    var xCP0 = cpRadius * cos(angle);
    var yCP0 = cpRadius * sin(angle);
    angle += PI / numPointsSlider.value();
    cpRadius = bezScale * innerRadius + (1 - bezScale) * radius;
    var xCP1 = cpRadius * cos(angle);
    var yCP1 = cpRadius * sin(angle);
    var xAnchor1 = radius * cos(angle);
    var yAnchor1 = radius * sin(angle);
    bezier(xAnchor0, yAnchor0, xCP0, yCP0, xCP1, yCP1, xAnchor1, yAnchor1);
    angle += PI / numPointsSlider.value();
    var xAnchor0 = innerRadius * cos(angle);
    var yAnchor0 = innerRadius * sin(angle);
    cpRadius = bezScale * radius + (1 - bezScale) * innerRadius;
    xCP0 = cpRadius * cos(angle);
    yCP0 = cpRadius * sin(angle);
    bezier(xAnchor1, yAnchor1, xCP1, yCP1, xCP0, yCP0, xAnchor0, yAnchor0);
  }
  rotate(PI / numPointsSlider.value());
}

function drawKiteLayer(radius) {
  drawSlantedLayer(radius, 0.5);
}