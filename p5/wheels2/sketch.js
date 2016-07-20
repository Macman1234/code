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

  var sliderInset = 130;
  overlapSlider = makeSlider("Overlap", 1, 50, 2, sliderInset, 20, 1);
  lobeSlider = makeSlider("Lobes", 1, 50, 3, sliderInset, 50, 1);
  radiusSlider = makeSlider("Radius", 0.5, 5, 1, sliderInset, 80, 0.1);
  insideScaleSlider = makeSlider("inside scale", 0.3, 3, 1, sliderInset, 110, 0.01);
  outsideScaleSlider = makeSlider("outside scale", 0.3, 3, 1, sliderInset, 140, 0.01);

  insideCheckbox = makeCheckbox("inside", false, sliderInset, 200);
  outsideCheckbox = makeCheckbox("outside", true, sliderInset, 230);
  fixedPenWidthCheckbox = makeCheckbox("fixed width pen", false, sliderInset, 260);
  maxPenWidthSlider = makeSlider("pen width scale", 1, 30, 15, sliderInset, 290, 0.5);
  twistSlider = makeSlider("twist", 0, 100, 0, sliderInset, 320, 1);
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  drawImageOnly();

  //slider value labels
  var overlap = overlapSlider.value();
  var lobes = lobeSlider.value();
  var cf = gcf(overlap, lobes);
  var labelInset = 335;
  noStroke();
  fill(0,100,255);
  textSize(14);
  text("" + overlap + " (" + overlap / cf + ')', labelInset, 33);
  text("" + lobes + " (" + lobes / cf + ')', labelInset, 63);
  text("" + radiusSlider.value(), labelInset, 93);
  text("" + insideScaleSlider.value(), labelInset, 123);
  text("" + outsideScaleSlider.value(), labelInset, 153);
  var msg = "Type 's' to save as PNG."
  text(msg, (width - textWidth(msg)) / 2, 20);
}

function drawImageOnly() {
  background(255);
  push();
  translate(width / 2, height / 2);
  scale(1, -1);
  var overlap = overlapSlider.value();
  var lobes = lobeSlider.value();
  var radius = radiusSlider.value();
  fixedPenWidth = fixedPenWidthCheckbox.checked();
  maxPenWidth = maxPenWidthSlider.value();
  var colour = color(0);
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

}

function keyTyped() {
  if (key == 's') {
    createCanvas(2000, 2000);
    drawImageOnly();
    var filename = 'wheels' + Math.round(millis()) + '.png';
    save(filename);
    createCanvas(800, 800);
    needsRedraw = true;
  }
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