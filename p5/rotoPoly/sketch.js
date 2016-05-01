"use strict";

var needsRedraw = true;
var numPoints = 8;
var numLayers = 12;
var innerRadiusAsFractionOfOuter = 0.7;
var numVerticesSlider, numPolysSlider, polySizeSlider;
var polyAngleSlider, sizeSlider, polyInsetSlider, penSlider;
var outerFrameCheckbox, outerFrameSlider, innerFrameCheckbox, innerFrameSlider;

function setup() {
  createCanvas(800, 800);
  var sliderInset = 90;
  numVerticesSlider = makeSlider("num vertices", 3, 50, 6, sliderInset, 20, 1);
  numPolysSlider = makeSlider("num polys", 1, 50, 3, sliderInset, 50, 1);
  polySizeSlider = makeSlider("edge length", 0, 1, 0.5, sliderInset, 80, 0.001);
  polyInsetSlider = makeSlider("poly inset", 0, 1, 0.5, sliderInset, 110, 0.001);
  polyAngleSlider = makeSlider("poly rotation", 0, 1, 0.5, sliderInset, 140, 0.001);
  sizeSlider = makeSlider("size", 0.25, 4, 1, sliderInset, 170, 0.05);
  penSlider = makeSlider("pen", 1, 60, 3, sliderInset, 200, 0.1);
  outerFrameCheckbox = makeCheckbox("show frame1", false, sliderInset, 230);
  outerFrameSlider = makeSlider("frame1 size", 0.1, 1, 0.9, sliderInset, 260, 0.001);
  innerFrameCheckbox = makeCheckbox("show frame2", false, sliderInset, 290);
  innerFrameSlider = makeSlider("frame2 size", 0.1, 1, 0.8, sliderInset, 320, 0.001);
}

function keyTyped() {
  if (key == 's') {
    //big canvas for better resolution of saved file
    createCanvas(2000, 2000);
    drawImageOnly();
    var filename = 'rotoPoly' + Math.round(millis()) + '.png';
    save(filename);
    createCanvas(800, 800);

    needsRedraw = true;
  } else if (key == '1') {
    outerFrameSlider.value(outerFrameSlider.value() - 0.001);
    needsRedraw = true;
  } else if (key == '2') {
    outerFrameSlider.value(outerFrameSlider.value() + 0.001);
    needsRedraw = true;
  } else if (key == '3') {
    innerFrameSlider.value(innerFrameSlider.value() - 0.001);
    needsRedraw = true;
  } else if (key == '4') {
    innerFrameSlider.value(innerFrameSlider.value() + 0.001);
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
  var valueTextOffset = 310;
  textSize(18);
  text(numVerticesSlider.value(), valueTextOffset, 33);
  text(numPolysSlider.value(), valueTextOffset, 63);
  text(polySizeSlider.value(), valueTextOffset, 93);
  text(polyInsetSlider.value(), valueTextOffset, 123);
  text(polyAngleSlider.value(), valueTextOffset, 153);
  text(sizeSlider.value(), valueTextOffset, 183);
  text(penSlider.value(), valueTextOffset, 213);
  text(outerFrameSlider.value(), valueTextOffset, 273);
  text(innerFrameSlider.value(), valueTextOffset, 333);
  textSize(12);
  var msg = "Type 's' to save, 1/2 to tweak frame1, 3/4 to tweak frame2."
  text(msg, (width - textWidth(msg)) / 2, 20);
}

function drawImageOnly() {
  push();
  background(255);
  stroke(0);
  strokeWeight(penSlider.value() * width / 800.0);
  strokeJoin(ROUND);
  noFill();
  translate(width * 0.5, height * 0.5);

  scale(sizeSlider.value(), sizeSlider.value());
  var polyRadiusToVertex = width * 0.25 * polySizeSlider.value();
  for (var polyCtr = 0; polyCtr < numPolysSlider.value(); ++polyCtr) {
    //draw polygons, spaced around the circle
    rotate(TWO_PI / numPolysSlider.value());
    push();
    //polygons can be drawn closer or farther w.r.t. center
    translate(width * 0.5 * polyInsetSlider.value(), 0);
    //allow polygons to be rotated
    beginShape();
    var angle = polyAngleSlider.value() * TWO_PI / numVerticesSlider.value();
    for (var vertexCtr = 0; vertexCtr < numVerticesSlider.value(); ++vertexCtr) {
      vertex(polyRadiusToVertex * cos(angle), polyRadiusToVertex * sin(angle));
      angle += TWO_PI / numVerticesSlider.value();
    }
    endShape(CLOSE);
    pop();
  }

  if (numVerticesSlider.value() % 4 == 2) {
    rotate(PI / numVerticesSlider.value());
  } else if (numVerticesSlider.value() % 4 == 1) {
    rotate(HALF_PI / numVerticesSlider.value());
  } else if (numVerticesSlider.value() % 4 == 3) {
    rotate(-HALF_PI / numVerticesSlider.value());
  }
  drawFrame(innerFrameCheckbox, innerFrameSlider);
  drawFrame(outerFrameCheckbox, outerFrameSlider);
  //now erase outside outerFrame
  // if (outerFrameCheckbox.checked()) {
  //   //create a mask that is white outside the outer frame, black inside
  //   var maskImage = createImage(width, height);
  //   var WHITE = color(255);
  //   var BLACK = color(0);
  //   maskImage.background(WHITE);
  //   maskImage.fill(BLACK);
  //   maskImage.stroke(BLACK);
  //   maskImage.beginShape();
  //   var angle = PI / numVerticesSlider.value();
  //   var radius = pg.width * 0.8 * sizeSlider.value();
  //   for (var vertexCtr = 0; vertexCtr < numVerticesSlider.value(); ++vertexCtr) {
  //     maskImage.vertex(radius * cos(angle), radius * sin(angle));
  //     angle += TWO_PI / numVerticesSlider.value();
  //   }
  //   maskImage.endShape(CLOSE);
  //   maskImage.loadPixels();
  //   println(maskImage.pixels.length);
  //   loadPixels();
  //   println(pixels.length);
  //   for(var pixIndex = 0; pixIndex < pixels.length; ++pixIndex) {
  //     if(pg.pixels[pixIndex] == WHITE) {
  //       pixels[pixIndex] = WHITE;
  //     }
  //   }
  //   updatePixels();
  // }
  pop();
}

function drawFrame(checkbox, sizeSlider) {
  //outer frame
  if (checkbox.checked()) {
    beginShape();
    var angle = PI / numVerticesSlider.value();
    var radius = width * 0.8 * sizeSlider.value();
    for (var vertexCtr = 0; vertexCtr < numVerticesSlider.value(); ++vertexCtr) {
      vertex(radius * cos(angle), radius * sin(angle));
      angle += TWO_PI / numVerticesSlider.value();
    }
    endShape(CLOSE);
  }
}