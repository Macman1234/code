"use strict";

/* Possible improvements
- keystroke to zoom in/out
- option to only show rings where it is possible to add without collision
- redo capability 

MAJOR CHANGE:
- first pentagon at 0,0. All coordinates in terms of SIDE_LENGTH = 1, 
which is then scaleable.
*/

var pentagons = [];
var needsRedraw = true;
var numberOfSides = 5;
var SIDE_LENGTH, ALTITUDE, DIST_TO_VERTEX;
var SCREEN_WIDTH = 800;
var nextPointsUp;

//UI
var sizeSlider, penSlider;

function setup() {
  createCanvas(800, 800);
  SIDE_LENGTH = 1.0;
  ALTITUDE = SIDE_LENGTH / 2 / tan(TWO_PI / 10);
  DIST_TO_VERTEX = sqrt(ALTITUDE * ALTITUDE + SIDE_LENGTH * SIDE_LENGTH / 4);
  print(SIDE_LENGTH, ALTITUDE, DIST_TO_VERTEX);
  pentagons.push(new Pentagon(0, 0, true));
  nextPointsUp = false;

  //UI
  var sliderInset = 90;
  sizeSlider = makeSlider("size", 10.0, 80.0, 40.0, sliderInset, 20, 1.0);
  penSlider = makeSlider("pen", 1, 20, 2, sliderInset, 50, 0.1);
}

function screenSideLength() {
  return sizeSlider.value() * width / SCREEN_WIDTH;
}

function toScreenX(x) {
  return x * screenSideLength() + width * 0.5;
}

function toScreenY(y) {
  return y * screenSideLength() + height * 0.5;
}

function mousePressed() {
  for (var pentagonIndex in pentagons) {
    var pentagon = pentagons[pentagonIndex];
    var newPentagon = pentagon.spawnedPentagon();
    if (newPentagon) {
      pentagons.push(newPentagon);
      nextPointsUp = !nextPointsUp;
      needsRedraw = true;
      return;
    }
  }
}

function keyTyped() {
  // '-' => remove last pentagon
  if ((key == '-') && pentagons.length > 0) {
    pentagons = pentagons.slice(0, pentagons.length - 1);
    needsRedraw = true;
  } else if (key == 's') {
    createCanvas(2000, 2000);
    drawImageOnly();
    var filename = 'pentile' + Math.round(millis()) + '.png';
    save(filename);
    createCanvas(SCREEN_WIDTH, SCREEN_WIDTH);
    needsRedraw = true;
  }
}

function drawImageOnly() {
  background(255);
  strokeWeight(penSlider.value() * width / SCREEN_WIDTH)
  for (var pentagonIndex in pentagons) {
    pentagons[pentagonIndex].draw();
  }
}

function draw() {
  if (!needsRedraw && mouseX == pmouseX && mouseY == pmouseY) {
    return;
  }
  needsRedraw = false;
  drawImageOnly();
  var msg = "Type '-' to remove most recently added pentagon, 's' to save as PNG.";
  noStroke();
  text(msg, (width - textWidth(msg)) / 2, 15);
}