"use strict";

var wheel;
var deltaTime = Math.PI / 1440;
var time;
var stepsPerFrame = 50;
var maxPenWidth = 30;
var fixedPenWidth = false;
var needsRedraw = true;
var WIDTH_MULTIPLIER = 0.44;

var overlapSlider, lobeSlider, radiusSlider;
var outsideScaleSlider, insideScaleSlider, maxPenWidthSlider;
var twistSlider;
var outsideCheckbox, insideCheckbox, fixedPenWidthCheckbox;

function setup() {
  createCanvas(800, 800);

  overlapSlider = makeSlider("Overlap", 1, 50, 2, 70, 20, 1);
  lobeSlider = makeSlider("Lobes", 1, 50, 3, 70, 50, 1);
  radiusSlider = makeSlider("Radius", 0.5, 5, 1, 70, 80, 0.1);
  insideScaleSlider = makeSlider("inside scale", 0.3, 3, 1, 100, 110, 0.01);
  outsideScaleSlider = makeSlider("outside scale", 0.3, 3, 1, 100, 140, 0.01);

  insideCheckbox = makeCheckbox("inside", false, 70, 200);
  outsideCheckbox = makeCheckbox("outside", true, 70, 230);
  fixedPenWidthCheckbox = makeCheckbox("fixed width pen", false, 120, 260);
  maxPenWidthSlider = makeSlider("pen width scale", 1, 30, 15, 130, 290, 0.5);
  twistSlider = makeSlider("twist", 0, 100, 0, 130, 320, 1);
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  background(255);
  push();
  translate(width / 2, height / 2);
  scale(1, -1);
  var overlap = overlapSlider.value();
  var lobes = lobeSlider.value();
  var radius = radiusSlider.value();
  fixedPenWidth = fixedPenWidthCheckbox.checked();
  maxPenWidth = maxPenWidthSlider.value();
  var colour = color(127);
  var wheelBaseRadius;
  if (outsideCheckbox.checked()) {
    wheelBaseRadius = width * WIDTH_MULTIPLIER / (1 + radius * overlap / (overlap + lobes)) * outsideScaleSlider.value();
    wheel = new Wheel(wheelBaseRadius, overlap, colour);
    wheel.setSubwheel(new Wheel(radius * wheelBaseRadius / (overlap + lobes) * overlap, overlap + lobes, colour));
    for (time = 0; time < 2 * PI + deltaTime; time += deltaTime) {
      wheel.drawCenteredAt(0, 0);
    }
  }
  if (insideCheckbox.checked()) {
    wheelBaseRadius = width * WIDTH_MULTIPLIER / (1 + overlap / abs(lobes - overlap)) / radius * insideScaleSlider.value();
    wheel = new Wheel(wheelBaseRadius, overlap, colour);
    wheel.setSubwheel(new Wheel(radius * wheelBaseRadius / (overlap - lobes) * overlap, overlap - lobes, colour));

    for (time = 0; time < 2 * PI + deltaTime; time += deltaTime) {
      wheel.drawCenteredAt(0, 0);
    }
  }
  pop();

  //slider value labels
  var cf = gcf(overlap, lobes);
  text("" + overlap +" ("+ overlap / cf + ')', 155, 33);
  text("" + lobes + " (" + lobes / cf + ')', 155, 63);
  text("" + radius, 155, 93);
  text("" + insideScaleSlider.value(), 185, 123);
  text("" + outsideScaleSlider.value(), 185, 153);

}

function gcf(a, b) {
  if (a < b) {
    return gcf(b, a);
  }
  if (a == b) {
    return a;
  }
  return gcf(b, a - b);
}