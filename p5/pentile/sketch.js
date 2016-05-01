"use strict";

/* Possible improvements
- keystroke to zoom in/out
- option to only show rings where it is possible to add without collision
- redo capability 
*/

var pentagons = [];
var needsRedraw = true;
var sideLength = 40.0;
var numberOfSides = 5;
var altitude, distToVertex;
var nextPointsUp;

function setup() {
  createCanvas(800, 800);

  altitude = sideLength / 2 / tan(TWO_PI / 10);
  distToVertex = sqrt(altitude * altitude + sideLength * sideLength / 4);
  println(distToVertex);
  pentagons.push(new Pentagon(width / 2, height / 2, true));
  nextPointsUp = false;
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

function keyPressed() {
  // '-' => remove last pentagon
  if (keyCode == 189 && pentagons.length > 0) {
    pentagons = pentagons.slice(0, pentagons.length - 1);
    needsRedraw = true;
  }
}

function draw() {
  if (!needsRedraw && mouseX == pmouseX && mouseY == pmouseY) {
    return;
  }
  needsRedraw = false;
  background(255);

  for (var pentagonIndex in pentagons) {
    pentagons[pentagonIndex].draw();
  }
  var msg = "press '-' to remove most recently added pentagon";
  noStroke();
  text(msg, (width - textWidth(msg)) / 2, 15);
}