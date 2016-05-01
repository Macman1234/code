"use strict";
var voronoi, bbox, sites;

function setup() {
  createCanvas(800, 800);
  voronoi = new Voronoi();
  bbox = {
    xl: 0,
    xr: 800,
    yt: 0,
    yb: 800
  }; // xl is x-left, xr is x-right, yt is y-top, and yb is y-bottom
  sites = [];

  // randomizePoints();
  // lissajousPoints();
  spiroPoints();

  // for (var ptCtr = 0; ptCtr < sites.length; ++ptCtr) {
  //   var pt = sites[ptCtr];
  //   ellipse(pt.x, pt.y, 3, 3);
  // }

  noLoop();
}

function randomizePoints() {
  for (var ptCtr = 0; ptCtr < 20; ++ptCtr) {
    var pt = {
      x: random() * width,
      y: random() * height
    };
    sites.push(pt);
  }
}

function lissajousPoints() {
  var numPoints = 500;
  for (var ptCtr = 0; ptCtr < numPoints; ++ptCtr) {
    var angle = 2 * PI * ptCtr / numPoints;
    var pt = {
      x: width * (0.5 + cos(angle * 3) * 0.45),
      y: height * (0.5 + sin(angle * 4) * 0.45)
    };
    sites.push(pt);
  }
}

function spiroPoints() {
  var numPoints = 101;
  var fixedRing = 5;
  var rollingRing = 8;
  var radius = width * 0.4;
  var r1 = radius * fixedRing/(fixedRing + rollingRing);
  var r2 = radius - r1;
  for (var ptCtr = 0; ptCtr < numPoints; ++ptCtr) {
    var angle1 = 2 * fixedRing * rollingRing * PI * ptCtr / numPoints;
    var angle2 = angle1 * fixedRing / rollingRing;
    var pt = {
      x: width/2 + r1 * cos(angle1) + r2 * cos(angle2),
      y: width / 2 + r1 * sin(angle1) + r2 * sin(angle2)
    };

    sites.push(pt);
  }
}

function includeInDrawing(cell) {
  var maxRadius = height * 0.49;
  for (var edgeIndex in cell.halfedges) {
    var edge = cell.halfedges[edgeIndex].edge;
    if (dist(edge.va.x, edge.va.y, width / 2, height / 2) > maxRadius) {
      return false;
    }
    if (dist(edge.vb.x, edge.vb.y, width / 2, height / 2) > maxRadius) {
      return false;
    }
  }
  return true;
}

function draw() {
  var diagram = voronoi.compute(sites, bbox);
  for (var cellIndex in diagram.cells) {
    var cell = diagram.cells[cellIndex];
    // println(cell);
    if (includeInDrawing(cell)) {
      for (var edgeIndex in cell.halfedges) {
        var edge = cell.halfedges[edgeIndex].edge;
        line(edge.va.x, edge.va.y, edge.vb.x, edge.vb.y);
      }
    }
  }
}