var NUDGE = 5;
var numRows = 8;
var needsRedraw = true;

function setup() {
  createCanvas(600, 600);
}

function draw() {
  if(!needsRedraw) {
    return;
  }
  needsRedraw = false;
  background(255);
  translate(NUDGE, NUDGE);
  strokeWeight(0.072);
  var sideLength = (width - NUDGE * 2) * 1.0 / numRows;
  for (var row = 0; row < numRows; ++row) {
    for (var col = 0; col < numRows; ++col) {
      var x0 = col * sideLength;
      var y0 = row * sideLength;
      //draw left
      if (col == 0) {
        //make it straight
        line(x0, y0, x0, y0 + sideLength);
      } else {
        wavy(x0, y0, x0, y0 + sideLength);
      }
      //draw top
      if (row == 0) {
        //make it straight
        line(x0, y0, x0 + sideLength, y0);
      } else {
        wavy(x0, y0, x0 + sideLength, y0);
      }
      //draw right
      if (col == numRows - 1) {
        line(x0 + sideLength, y0, x0 + sideLength, y0 + sideLength);
      }
      //draw bottom
      if (row == numRows - 1) {
        line(x0, y0 + sideLength, x0 + sideLength, y0 + sideLength);
      }
    }
  }

}

function noyz() {
  return 0.1 * (random() - 0.5);
}

function wavy(x0, y0, x1, y1) {
  //assume this vector points right, or down
  push();
  translate(x0, y0);
  var side = dist(x0, y0, x1, y1);
  if (abs(x0 - x1) < 1e-3) {
    //reorient so that we can assume going left to right
    rotate(HALF_PI);
  }
  
  var direction = random() < 0.5 ? -1 : 1;
  var neckSize = 0.08;
  var headSize = 0.15;
  noFill();
  beginShape();
  curveVertex(-side * 0.3, 0);
  curveVertex(0, 0);
  curveVertex(side * (0.5 - neckSize + noyz()), direction * side * noyz());
  curveVertex(side * (0.5- headSize + noyz()), direction * side * (0.2 + noyz()));
  curveVertex(side * (0.5 + headSize + noyz()), direction * side * (0.2 + noyz()));
  curveVertex(side * (0.5 + neckSize + noyz()), direction * side * noyz());
  curveVertex(side, 0);
  curveVertex(side * 1.3, 0);
  endShape();
  pop();
}