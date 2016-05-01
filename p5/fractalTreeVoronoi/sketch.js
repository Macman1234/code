"use strict";

var rotationAngle = Math.PI / 8;
var minBranchLength = 10;
var rotationAngleSlider, branchLengthSlider, depthSlider, scaleSlider, tiltSlider, variablePenWidthCheckbox, penWidthSlider;
var needsRedraw = true;

function setup() {
  createCanvas(3000, 3000);
  clear();
  var sliderInset = 105;
  rotationAngleSlider = makeSliderForceRecompute("rotation angle", 0.05, 1, 0.15, sliderInset, 20, 0.01);
  branchLengthSlider = makeSliderForceRecompute("branch length", 0.1, 0.99, 0.9, sliderInset, 50, 0.01);
  scaleSlider = makeSliderForceRecompute("scale", 0.01, 1, 0.25, sliderInset, 80, 0.01);
  depthSlider = makeSliderForceRecompute("depth", 1, 10, 8, sliderInset, 110, 1);
  tiltSlider = makeSliderForceRecompute("tilt", -1, 1, 0, sliderInset, 140, 0.001);
  variablePenWidthCheckbox = makeCheckbox("variable pen", false, sliderInset, 170);
  penWidthSlider = makeSlider("pen width", 1, 25, 3, sliderInset, 200, 1);
  forceRedrawAndRecompute();
}

function keyTyped() {
  if (key == 's') {
    drawImageOnly();
    var filename = 'fractalTreeVoronoi' + Math.round(millis()) + '.png';
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

  fill(255, 0, 0);
  noStroke();
  var labelInset = 320;
  text(rotationAngleSlider.value(), labelInset, 33);
  text(branchLengthSlider.value(), labelInset, 63);
  text(scaleSlider.value(), labelInset, 93);
  text(depthSlider.value(), labelInset, 123);
  text(tiltSlider.value(), labelInset, 153);
  text(penWidthSlider.value(), labelInset, 213);
  var msg = "Type 's' to save as PNG. Click in any cell to remove the cell."
  text(msg, (width - textWidth(msg)) / 2, 20);
}

function drawImageOnly() {
  strokeWeight(penWidthSlider.value());
  needsRedraw = false;

  push();
  background(255);
  stroke(0);
  try {

    //draw Voronoi
    for (var cellIndex in diagram.cells) {
      if (!cellIndexRemoved(cellIndex)) {
        var cell = diagram.cells[cellIndex];
        if (includeInDrawing(cell)) {
          for (var edgeIndex in cell.halfedges) {
            var edge = cell.halfedges[edgeIndex].edge;
            var yMid = 0.5 * (edge.va.y + edge.vb.y);
            if (variablePenWidthCheckbox.checked()) {
              strokeWeight(penWidthSlider.value() * (yMid / height + 0.1));
            }
            line(edge.va.x, edge.va.y, edge.vb.x, edge.vb.y);
          }
        }
      }
    }
  } catch (e) {
    println(e);
  }
}

function cellIndexRemoved(cellIndex) {
  var i = userRemovedCells.length;
  while (i--) {
    if (userRemovedCells[i] == cellIndex) {
      return true;
    }
  }
  return false;
}

function mouseClicked() {
  //see if a cell was clicked in, and remove it.
  try {
    for (var cellIndex in diagram.cells) {
      var cell = diagram.cells[cellIndex];
      if (cellContainsMouse(cell) && !cellIndexRemoved(cellIndex)) {
        userRemovedCells.push(cellIndex);
        needsRedraw = true;
        return;
      }
    }
  } catch (e) {
    println(e);
  }
}

function cellContainsMouse(c) {
  for (var edgeIndex in c.halfedges) {
    var halfEdge = c.halfedges[edgeIndex];
    var x1 = halfEdge.getStartpoint().x - mouseX;
    var x2 = halfEdge.getEndpoint().x - mouseX;
    var y1 = halfEdge.getStartpoint().y - mouseY;
    var y2 = halfEdge.getEndpoint().y - mouseY;
    var crossProduct = x1 * y2 - x2 * y1;
    if (crossProduct > 0) {
      return false;
    }
  }
  return true;
}

function drawTree(x0, y0, x1, y1, depth) {
  if (x1 < 1 || x1 >= width || y1 < 1 || y1 >= height) {
    return;
  }
  if (depth > depthSlider.value()) {
    return;
  }
  sites.push(new Vector2D(x1, y1));
  var delta = new Vector2D(x1 - x0, y1 - y0);
  var rotationAngle = rotationAngleSlider.value();
  for (var branchCtr = 0; branchCtr < 2; ++branchCtr) {
    var angle = rotationAngle + tiltSlider.value();
    var v = delta.rotate(angle);
    v = v.scaleBy(branchLengthSlider.value());
    drawTree(x1, y1, x1 + v.x, y1 + v.y, depth + 1);
    rotationAngle = -rotationAngle;
  }
}

function includeInDrawing(cell) {
  //too far away
  var maxRadius = height * 0.48;
  for (var edgeIndex in cell.halfedges) {
    var edge = cell.halfedges[edgeIndex].edge;
    if (edge.va.x < 1 || edge.va.x > width - 1 || edge.va.y < 1 || edge.va.y > height - 1) {
      return false;
    }
  }
  return true;
}