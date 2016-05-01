"use strict";

/* Possible improvements
- keystroke to zoom in/out
- option to only show rings where it is possible to add without collision
- copy & paste a selection 
*/

var polygons = [];
var needsRedraw = true;
var sideLength = 50.0;

// UI
var baseVerticesSlider, scaleSlider, numVerticesSlider;

function setup() {
  createCanvas(900, 900);
  clear();

  var sliderInset = 150;
  baseVerticesSlider = makeSlider("starting # of vertices", 3, 15, 5, sliderInset, 20, 1);
  baseVerticesSlider.input(baseVerticesChanged);
  numVerticesSlider = makeSlider("next # of vertices", 3, 15, 4, sliderInset, 50, 1);
  scaleSlider = makeSlider("scale", 0.5, 2, 1, sliderInset, 80, 0.05);

  baseVerticesChanged();
}

function baseVerticesChanged() {
  polygons = [];
  polygons.push(new Polygon(baseVerticesSlider.value(), 0, 0, 0));
}

function nextNumberOfSides() {
  return numVerticesSlider.value();
}

function nextPolygonAlitude() {
  return sideLength / 2 / tan(PI / nextNumberOfSides());
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
  for (var polygonIndex in polygons) {
    polygons[polygonIndex].drawRings(scale_);
  }
  pop();
  var msg = "Click edges to add polygons. Press '-' to remove most recently added polygon.";
  noStroke();
  fill(0);
  text(msg, (width - textWidth(msg)) / 2, 15);

  var labelInset = 340;
  text(baseVerticesSlider.value(), labelInset, 33);
  text(numVerticesSlider.value(), labelInset, 63);
  text(scaleSlider.value(), labelInset, 93);

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