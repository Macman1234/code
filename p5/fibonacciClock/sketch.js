"use strict";

var needsRedraw = true;
var phi = (1 + Math.sqrt(5)) / 2;
var dThetaSlider, scaleSlider, penWidthSlider;

//Voronoi
var voronoi, bbox, sites;

function setup() {
  createCanvas(1000, 1000);
  var goldenAngle = 2 * PI * (1 - 1 / phi);
  var sliderInset = 70;
  dThetaSlider = makeSlider("angle", 0.5, 6.28, goldenAngle, sliderInset, 20, 0.001);
  scaleSlider = makeSlider("scale", 3, 50, 10, sliderInset, 50, 1);
  penWidthSlider = makeSlider("pen size", 1, 20, 0.5, sliderInset, 80, 0.5);
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  strokeWeight(penWidthSlider.value());
  needsRedraw = false;
  voronoi = new Voronoi();
  bbox = {
    xl: 0,
    xr: width,
    yt: 0,
    yb: height
  };
  sites = [];

  push();
  background(255);
  // translate(width / 2, height / 2);
  // scale(1, -1);
  stroke(0);

  var dTheta = dThetaSlider.value();
  var theta = dTheta / 2;
  var x, y;
  var r;
  fill(0);
  var radiusScale = scaleSlider.value();
  var diameter = 1.5 * sqrt(radiusScale);
  //draw points
  while ((r = sqrt(theta) * radiusScale) < width * 0.48) {
    var pt = {
      x: width / 2 + r * cos(theta),
      y: height / 2 + r * sin(theta)
    };
    sites.push(pt);
    // ellipse(pt.x, pt.y, diameter, diameter);
    theta += dTheta;
  }

  //draw Voronoi
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
  pop();
  var diam = width / 6.5;
  ellipse(width/2, height/2,diam, diam);
  save('fibonacciClock.png');

  noFill();
  strokeWeight(1);
  text(dTheta, 290, 33);
  text(radiusScale, 290, 63);
}


function includeInDrawing(cell) {
  var maxRadius = height * 0.48;
  for (var edgeIndex in cell.halfedges) {
    var edge = cell.halfedges[edgeIndex].edge;
    // println(edge);
    if (dist(edge.va.x, edge.va.y, width / 2, height / 2) > maxRadius) {
      return false;
    }
    if (dist(edge.vb.x, edge.vb.y, width / 2, height / 2) > maxRadius) {
      return false;
    }
  }
  return true;
}