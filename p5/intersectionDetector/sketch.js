// "use strict";
var needsRedraw = true;
var penWidthSlider;
var vorWidth = 960;
var vorHeight = 960;
var sourceStrokeColor = 127;

function setup() {
  createCanvas(960, 960);
  var sliderInset = 120;
  penWidthSlider = makeSlider("pen size", 1, 40, 0.5, sliderInset, 20, 0.5);
  showSourceCheckbox = makeCheckbox("show source", true, sliderInset, 50);
  showVoronoiCheckbox = makeCheckbox("show voronoi", true, sliderInset, 80);
  numCirclesSlider = makeSlider("# circles", 2, 18, 3, sliderInset, 110, 1);
}


function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  background(255);

  noFill();
  stroke(sourceStrokeColor);
  strokeWeight(2);
  blendMode(MULTIPLY); //intersections will be darker


  push();
  translate(width / 2, height / 2);
  var numCircles = numCirclesSlider.value();
  var diam = width * 0.25;
  for (var circleCtr = 0; circleCtr < numCircles; ++circleCtr) {
    ellipse(diam , 0, diam, diam);
    rotate(TWO_PI / numCircles);
  }
  pop();

  var pts = intersectionPoints();
  drawClusterPoints(pts);
  if (!showSourceCheckbox.checked()) {
    clear();
  }
  if (showVoronoiCheckbox.checked()) {
    drawVoronoi(pts);
  }
}

function drawClusterPoints(pointClusters) {
  fill(0, 255, 0);
  var ptSize = 10;
  for (var pointIndex = 0; pointIndex < pointClusters.length; ++pointIndex) {
    var pc = pointClusters[pointIndex];
    ellipse(pc.x(), pc.y(), ptSize, ptSize);
  }
}

function drawVoronoi(pointClusters) {
  noSmooth();
  strokeWeight(1); //penWidthSlider.value() * width / vorWidth);
  needsRedraw = false;
  voronoi = new Voronoi();
  bbox = {
    xl: 0,
    xr: vorWidth,
    yt: 0,
    yb: vorHeight
  };
  sites = [];

  push();
  background(255);
  stroke(0);

  //populate Voronoi from pointClusters
  for (var pointIndex = 0; pointIndex < pointClusters.length; ++pointIndex) {
    var pointCluster = pointClusters[pointIndex];
    var pt = {
      x: pointCluster.x(),
      y: pointCluster.y()
    };
    sites.push(pt);
  }

  //draw Voronoi
  var diagram = voronoi.compute(sites, bbox);
  for (var cellIndex in diagram.cells) {
    var cell = diagram.cells[cellIndex];
    // println(cell);
    if (includeInDrawing(cell)) {
      for (var edgeIndex in cell.halfedges) {
        var edge = cell.halfedges[edgeIndex].edge;
        line(edge.va.x * width / vorWidth, edge.va.y * height / vorHeight, edge.vb.x * width / vorWidth, edge.vb.y * height / vorHeight);
      }
    }
  }
  pop();
}

function includeInDrawing(cell) {
  var maxRadius = vorHeight * 0.48;
  for (var edgeIndex in cell.halfedges) {
    var edge = cell.halfedges[edgeIndex].edge;
    // println(edge);
    if (dist(edge.va.x, edge.va.y, vorWidth / 2, vorHeight / 2) > maxRadius) {
      return false;
    }
    if (dist(edge.vb.x, edge.vb.y, vorWidth / 2, vorHeight / 2) > maxRadius) {
      return false;
    }
  }
  return true;
}

function intersectionPoints() {
  var allPointClusters = [];
  loadPixels();
  var d = pixelDensity();
  var openPointClusters = [];
  for (var y = 0; y < height; ++y) {
    var nextOpenPointClusters = [];

    for (var x = 0; x < width; ++x) {
      //check the red value: should be 255 for white, 127 for grey, <127 for intersection
      var pixelOffset = 4 * (y * width * d + x) * d;
      var pixel = pixels[pixelOffset];
      var isIntersection = false;
      for(var cIdx = 0; cIdx < 3; ++cIdx) {
        isIntersection = isIntersection || (pixels[pixelOffset + cIdx] < sourceStrokeColor);
      }
      if (isIntersection) {
        setRGBA(x, y, 255, 0, 0, 255);
        // found an intersection pixel, add it to an adjacent cluster from row above..
        // println("(x,y) = " + x + ',' + y + ')');
        var foundCluster = nextOpenPointClusters[x - 1];
        if (!foundCluster) {
          //look for cluster on row above
          for (var dx = -14; dx < 15; ++dx) {
            foundCluster = openPointClusters[x + dx];
            if (foundCluster) {
              break;
            }
          }
        }
        if (foundCluster) {
          foundCluster.add(x, y);
          nextOpenPointClusters[x] = foundCluster;
        } else {
          //nothing found...create a new PointCluster
          var newCluster = new PointCluster(x, y);
          nextOpenPointClusters[x] = newCluster;
          allPointClusters.push(newCluster);
        }
      }
    }
    openPointClusters = nextOpenPointClusters;
  }
  updatePixels();
  return allPointClusters;
}

function setRGBA(x, y, r, g, b, a) {
  var d = pixelDensity();
  for (var i = 0; i < d; i++) {
    for (var j = 0; j < d; j++) {
      // loop over
      var idx = 4 * ((y * d + j) * width * d + (x * d + i));
      pixels[idx] = r;
      pixels[idx + 1] = g;
      pixels[idx + 2] = b;
      pixels[idx + 3] = a;
    }
  }
}