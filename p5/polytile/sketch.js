"use strict";

/* Possible improvements
- keystroke to zoom in/out
- option to only show rings where it is possible to add without collision
- copy & paste a selection 
*/

var polygons = [];
var needsRedraw = true;
var sideLength = 50.0;
var altitude, distToVertex;

// UI
var scaleSlider, numVerticesSlider, edgeNumbersCheckbox;

function setup() {
  createCanvas(900, 900);

  var sliderInset = 150;
  numVerticesSlider = makeSlider("number of vertices", 3, 15, 5, sliderInset, 20, 2);
  numVerticesSlider.input(numVerticesChanged);
  scaleSlider = makeSlider("scale", 0.5, 2, 1, sliderInset, 50, 0.05);
  edgeNumbersCheckbox = makeCheckbox("show edge numbers", false, sliderInset, 80);

  numVerticesChanged();
}

function numberOfSides() {
  return numVerticesSlider.value();
}

function numVerticesChanged() {
  // sideLength = 40;//200.0 / numberOfSides();
  altitude = sideLength / 2 / tan(PI / numberOfSides());
  distToVertex = sqrt(altitude * altitude + sideLength * sideLength / 4);
  polygons = [];
  println(numberOfSides());
  polygons.push(new Polygon(numberOfSides(), 0, 0, true));
  needsRedraw = true;
}

function mousePressed() {
  //see if clicked on a ring
  for (var polygonIndex in polygons) {
    var polygon = polygons[polygonIndex];
    var newpolygon = polygon.spawnedPolygon(scaleSlider.value());
    if (newpolygon) {
      polygons.push(newpolygon);
      needsRedraw = true;
      return;
    }
  }

  //remove selected polys
  if (polygons.length > 1) {
    var polygonsToKeep = [polygons[0]];
    for (var polygonIndex = 1; polygonIndex < polygons.length; ++polygonIndex) {
      var polygon = polygons[polygonIndex];
      if (!polygon.hasFocus(scaleSlider.value())) {
        polygonsToKeep.push(polygon);
      } else {
        needsRedraw = true;
      }
    }
    polygons = polygonsToKeep;
  }
}

function keyPressed() {
  // '-' => remove last polygon
  if (keyCode == 189 && polygons.length > 1) {
    polygons = polygons.slice(0, polygons.length - 1);
    needsRedraw = true;
  }
}

function draw() {
  if (!needsRedraw && mouseX == pmouseX && mouseY == pmouseY) {
    return;
  }
  needsRedraw = false;
  background(255);
  push();
  translate(width / 2, height / 2);

  var scale_ = scaleSlider.value();
  for (var polygonIndex in polygons) {
    polygons[polygonIndex].draw(scale_);
  }
  if (edgeNumbersCheckbox.checked()) {
    for (var polygonIndex in polygons) {
      polygons[polygonIndex].drawEdgeNumbers(scale_);
    }
  }
  for (var polygonIndex in polygons) {
    polygons[polygonIndex].drawRings(scale_);
  }
  pop();
  var msg = "press '-' to remove most recently added polygon";
  noStroke();
  fill(0);
  text(msg, (width - textWidth(msg)) / 2, 15);

  var labelInset = 280;
  text(numVerticesSlider.value(), labelInset, 33);
  text(scaleSlider.value(), labelInset, 63);

  //all edges
  var edgeNumberTotals = edgeCounts();
  var rowSeparation = 18;
  var yOffset = 120;
  var numSides = numVerticesSlider.value();
  for (var edgeIndex = 0; edgeIndex < numSides; ++edgeIndex) {
    text("Edge " + edgeIndex + "=" + edgeNumberTotals[edgeIndex], 10, yOffset + rowSeparation * edgeIndex);
    text("Edge " + (edgeIndex + numSides) + "=" + edgeNumberTotals[edgeIndex + numSides], 120, yOffset + rowSeparation * edgeIndex);
  }

  //edges in path starting at first polygon
  var edgeNumberTotals = edgeCountsFromFirstPolygon();
  var rowSeparation = 18;
  var numSides = numVerticesSlider.value();
  yOffset = 130 + numSides * rowSeparation;
  text("Edge counts for cycle starting from original polygon", 10, yOffset);
  for (var edgeIndex = 0; edgeIndex < numSides; ++edgeIndex) {
    var y = yOffset + rowSeparation * (edgeIndex + 1);
    text("Edge " + edgeIndex + "=" + edgeNumberTotals[edgeIndex], 10, y);
    text("Edge " + (edgeIndex + numSides) + "=" + edgeNumberTotals[edgeIndex + numSides], 120, y);
  }

}

function edgeCounts() {
  var counts = [];
  var numEdgeNumbers = numVerticesSlider.value() * 2;
  //ack...can't remember how to fill array with zeroes
  for (var edgeIndex = 0; edgeIndex < numEdgeNumbers; ++edgeIndex) {
    counts.push(0);
  }
  for (var polygonIndex in polygons) {
    var polyToCount = polygons[polygonIndex];
    for (var polyToCompareToIndex in polygons) {
      var polyToCompareTo = polygons[polyToCompareToIndex];
      var edgeShared = polyToCount.edgeTouching(polyToCompareTo);
      if (edgeShared > -1) {
        ++counts[edgeShared];
      }
    }
  }
  return counts;
}

function edgeCountsFromFirstPolygon() {
  var counts = [];
  var numEdgeNumbers = numVerticesSlider.value() * 2;
  //ack...can't remember how to fill array with zeroes
  for (var edgeIndex = 0; edgeIndex < numEdgeNumbers; ++edgeIndex) {
    counts.push(0);
  }
  var previousPolygon = polygons[0];
  var polysInCycle = [previousPolygon];
  var foundNextPolygon;
  do {
    foundNextPolygon = false;
    for (var polygonIndex in polygons) {
      if (!foundNextPolygon) {
        var polyToCheck = polygons[polygonIndex];
        if (polysInCycle.indexOf(polyToCheck) < 0) {
          var edgeShared = previousPolygon.edgeTouching(polyToCheck);
          if (edgeShared > -1) {
            ++counts[edgeShared];
            polysInCycle.push(polyToCheck);
            previousPolygon = polyToCheck;
            foundNextPolygon = true;
          }
        }
      }
    }
  } while (foundNextPolygon && previousPolygon != polygons[0]);
  //does the last poly found connect to the first?
  if (polysInCycle.length > 2) {
    var lastEdge = previousPolygon.edgeTouching(polygons[0]);
    if (lastEdge > -1) {
      ++counts[lastEdge];
    }
  }
  return counts;
}