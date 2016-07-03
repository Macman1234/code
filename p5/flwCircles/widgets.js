"use strict";

var needsRedraw = true;
var userRemovedCells = [];
var voronoi, bbox, sites, diagram;

function makeCheckbox(name, initialValue, x, y) {
  var label = createP(name);
  label.position(10, y - 17);
  var checkbox = createCheckbox('', initialValue);
  checkbox.position(x, y);
  checkbox.style('width', '200px');
  checkbox.changed(forceRedraw);
  return checkbox;
}

function makeSlider(name, min, max, initialValue, x, y, step) {
  var label = createP(name);
  label.position(10, y - 17);
  var slider = createSlider(min, max, initialValue);
  slider.position(x, y);
  slider.style('width', '200px');
  slider.input(forceRedraw);
  slider.attribute('step', step);
  slider.value(initialValue);
  return slider;
}

function makeSliderForceRecompute(name, min, max, initialValue, x, y, step) {
  var label = createP(name);
  label.position(10, y - 17);
  var slider = createSlider(min, max, initialValue);
  slider.position(x, y);
  slider.style('width', '200px');
  slider.input(forceRedrawAndRecompute);
  slider.attribute('step', step);
  slider.value(initialValue);
  return slider;
}

function forceRedraw() {
  needsRedraw = true;
}

function forceRedrawAndRecompute() {
  forceRedraw();
  userRemovedCells = [];
  voronoi = new Voronoi();
  bbox = {
    xl: 0,
    xr: width,
    yt: 0,
    yb: height
  };
  sites = [];
  var trunkLength = height * 0.5 * scaleSlider.value();
  drawTree(width / 2, height * 0.99, width / 2, height * 0.99 - trunkLength, 0);
  diagram = voronoi.compute(sites, bbox);
}