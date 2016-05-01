"use strict";

var numPolys = 7;
var numSquaresPerSide = 3;
var sideLength;
var fcSeq;

//UI
var numPolysSlider, numSquaresPerSideSlider, strokeWeightSlider, fillCheckbox, fillSquaresCheckbox;
var needsRedraw = true;
var saveCommandSequence = false;

function setup() {
  createCanvas(3000, 3000);
  fcSeq = new FunctionCallSequence("test.json");
  numPolysSlider = makeSlider("number of polygons", 3, 16, 3, 150, 20, 1);
  numSquaresPerSideSlider = makeSlider("squares on each edge", 0, 6, 1, 150, 50, 1);
  strokeWeightSlider = makeSlider("stroke weight", 0.5, 25, 0.5, 150, 80, 0.5);
  fillCheckbox = makeCheckbox("fill polygons", false, 150, 110);
  fillSquaresCheckbox = makeCheckbox("fill squares", false, 150, 140);
}

function numSides() {
  if (numPolys % 2 == 0) {
    return numPolys;
  }
  return 2 * numPolys;
}

function keyTyped() {
  if (key == 'f') {
    fcSeq.writeToFile();
  } else if (key == 's') {
    drawImageOnly();
    var filename = 'spiropolys_'+numSides()+'s_'+numSquaresPerSideSlider.value()+'sq_'+strokeWeightSlider.value()+'sw';
    if(fillCheckbox.checked()) {
      filename += '_fillPoly';
    } if(fillSquaresCheckbox.checked()) {
      filename += '_fillSq';
    }
    filename += '.png';
    save(filename);
    needsRedraw = true;
  }
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  drawImageOnly();

  //slider value labels
  fill(0);
  noStroke();
  var xText = 360;

  text(numPolysSlider.value(), xText, 33);
  text(numSquaresPerSideSlider.value(), xText, 63);
  text(strokeWeightSlider.value(), xText, 93);
  var msg = "Type 'f' to log function call sequence on console. Type 's' to save as PNG."
  text(msg, (width - textWidth(msg)) / 2, 20);
}

function drawImageOnly() {
  push();
  clear();
  fcSeq.reset();
  fcSeq.background(255);
  numPolys = numPolysSlider.value();
  numSquaresPerSide = numSquaresPerSideSlider.value();

  // strokeCap(1);
  fcSeq.strokeWeight(strokeWeightSlider.value() * width / 1000);
  fcSeq.translate(width / 2, height / 2);
  sideLength = PI * width / numSides() * 0.36;
  for (var polyCtr = 0; polyCtr < numPolys; ++polyCtr) {
    drawPoly();
    fcSeq.rotate(2 * PI / numPolys);
  }
  pop();
}

function drawPoly() {
  fcSeq.push();
  for (var sideCtr = 0; sideCtr < numSides(); ++sideCtr) {
    drawSideAsPolygons();
    fcSeq.translate(sideLength, 0);
    fcSeq.rotate(2 * PI / numSides());
  }
  fcSeq.pop();
}

function useFill() {
  return fillCheckbox.checked();
}

function drawPolyVertex(polySideLength) {
  if (useFill()) {
    fcSeq.fill(0);
  } else {
    noFill();
  }
  strokeJoin(ROUND);
  for (var sideCtr = 0; sideCtr < numPolys; ++sideCtr) {
    var vertex_ = new Vector2D(0, 0);
    var delta = new Vector2D(polySideLength, 0);
    fcSeq.beginShape();
    for (var edgeCtr = 0; edgeCtr < numPolys; ++edgeCtr) {
      fcSeq.vertex(vertex_.x, vertex_.y)
      vertex_ = vertex_.plus(delta);
      delta = delta.rotate(2 * PI / numPolys);
    }
    fcSeq.endShape(CLOSE);
  }
}

function drawSideAsPolygons() {
  //side consists of two perpendiculars from numSide-sided
  //center to edge, plus one or more squares 
  //Assume they have side length one, then scale to fit sideLength.

  //Draw the polygon centered at the origin
  fcSeq.stroke(0);
  fcSeq.push();
  var ratioAltitudeToHalfSide = tan(PI / 2 - PI / numPolys);
  var polySideLength = sideLength / (ratioAltitudeToHalfSide + numSquaresPerSide);
  var polyAltitude = ratioAltitudeToHalfSide * polySideLength / 2;
  fcSeq.push();
  //rotate vertex into position
  fcSeq.rotate(-PI / 2 + PI / numSides() * 2);
  fcSeq.translate(-polySideLength / 2, -polyAltitude);
  drawPolyVertex(polySideLength);
  fcSeq.pop();

  if (useFill()) {
    fcSeq.fill(225);
  } else {
    noFill();
  }
  fcSeq.translate(polyAltitude + polySideLength / 2, 0);
  // fcSeq.strokeJoin(ROUND);
  var halfSide = polySideLength * 0.5;
  if (fillSquaresCheckbox.checked()) {
    fcSeq.fill(0);
  } else {
    noFill();
  }
  for (var squareCtr = 0; squareCtr < numSquaresPerSide; ++squareCtr) {
    fcSeq.beginShape();
    fcSeq.vertex(-halfSide, -halfSide);
    fcSeq.vertex(halfSide, -halfSide);
    fcSeq.vertex(halfSide, halfSide);
    fcSeq.vertex(-halfSide, halfSide);
    fcSeq.endShape(CLOSE);
    fcSeq.translate(polySideLength, 0);
  }
  fcSeq.pop();

}