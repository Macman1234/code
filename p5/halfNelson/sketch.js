"use strict";

var needsRedraw = true;
var numPoints = 8;
var numLayers = 12;
var innerRadiusAsFractionOfOuter = 0.7;
var numPointsSlider, numLayersSlider, innerRadiusSlider, penSlider, slantSlider;

function setup() {
  createCanvas(800, 800);
  var sliderInset = 90;
  numPointsSlider = makeSlider("num points", 3, 50, 12, sliderInset, 20, 1);
  numLayersSlider = makeSlider("depth", 1, 50, 6, sliderInset, 50, 1);
  innerRadiusSlider = makeSlider("inner radius", 0.5, 0.95, 0.66, sliderInset, 80, 0.01);
  penSlider = makeSlider("pen", 0.1, 1, 0.5, sliderInset, 110, 0.01);
  slantSlider = makeSlider("slant", 0.5, 3, 2.75, sliderInset, 140, 0.01);
}

function keyTyped() {
  if (key == 's') {
    createCanvas(2000, 2000);
    drawImageOnly();
    var filename = 'tunnel' + Math.round(millis()) + '.png';
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

  fill(255, 0, 0);
  noStroke();
  var valueTextOffset = 310;
  text(numPointsSlider.value(), valueTextOffset, 33);
  text(numLayersSlider.value(), valueTextOffset, 63);
  text(innerRadiusSlider.value(), valueTextOffset, 93);
  text(penSlider.value(), valueTextOffset, 123);
  text(slantSlider.value(), valueTextOffset, 153);
  var msg = "Type 's' to save as PNG."
  text(msg, (width - textWidth(msg)) / 2, 20);
}

function drawImageOnly() {
  push();
  stroke(127);
  noFill();
  translate(width * 0.5, height * 0.5);
  rotate(PI / numPointsSlider.value());

  background(255);
  var radius = width * 0.4;
  for (var layerCtr = 0; layerCtr < numLayersSlider.value(); ++layerCtr) {
    drawLayer(radius);
    radius *= innerRadiusSlider.value();
  }
  pop();
  // save('tunnel_' + numPointsSlider.value() + '_' + numLayersSlider.value() + '_' + round(innerRadiusSlider.value() * 100) + '_' + penSlider.value() + '.png');
}

function drawLayer(radius) {
  strokeWeight(radius * 0.1 * penSlider.value());
  drawSlantedLayer(radius, slantSlider.value());
}

function drawSlantedLayer(radius, fractionSlant) {
  var angleBetweenVertices = fractionSlant * TWO_PI / numPointsSlider.value();
  var innerRadius = radius * innerRadiusSlider.value();
  var angle = 0.0;
  for (var pointCtr = 0; pointCtr < numPointsSlider.value(); ++pointCtr) {
    var xAnchor0 = innerRadius * cos(angle + angleBetweenVertices);
    var yAnchor0 = innerRadius * sin(angle + angleBetweenVertices);
    var xCP0 = radius * cos(angle + angleBetweenVertices);
    var yCP0 = radius * sin(angle + angleBetweenVertices);
    angle += TWO_PI / numPointsSlider.value();
    var xCP1 = innerRadius * cos(angle);
    var yCP1 = innerRadius * sin(angle);
    var xAnchor1 = radius * cos(angle);
    var yAnchor1 = radius * sin(angle);
    bezier(xAnchor0, yAnchor0, xCP0, yCP0, xCP1, yCP1, xAnchor1, yAnchor1);
  }
  rotate(angleBetweenVertices);
}

function drawKiteLayer(radius) {
  drawSlantedLayer(radius, 0.5);
}