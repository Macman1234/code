var depthSlider, numCirclePerRingSlider, scaleSlider, penSlider, varyStrokeCheckbox;
var needsRedraw = true;

function setup() {
  createCanvas(800, 800);

  var sliderInset = 90;
  depthSlider = makeSlider("depth", 3, 12, 1, sliderInset, 20, 1);
  numCirclePerRingSlider = makeSlider("# circles", 12, 50, 3, sliderInset, 50, 1);
  scaleSlider = makeSlider("scale", 0.1, 0.99, 0.627, sliderInset, 80, 0.001);
  penSlider = makeSlider("pen", 1, 100, 10, sliderInset, 110, 1);
  varyStrokeCheckbox = makeCheckbox("vary stroke", false, sliderInset, 140);
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  drawImageOnly();

  //draw label values
  fill(255, 0, 0);
  noStroke();
  var valueTextOffset = 300;
  text(depthSlider.value(), valueTextOffset, 33);
  text(numCirclePerRingSlider.value(), valueTextOffset, 63);
  text(scaleSlider.value(), valueTextOffset, 93);
  text(penSlider.value(), valueTextOffset, 123);
  var msg = "Type 's' to save as PNG."
  text(msg, (width - textWidth(msg)) / 2, 20);
}

function initialSize() {
  return width * 0.45;
}

function drawImageOnly() {
  push();
  background(255);
  translate(width * 0.5, height * 0.5);
  noFill();
  stroke(0);
  var size = initialSize();
  setStrokeWeight(size);
  ellipse(0, 0, size * 2, size * 2);
  var innerCircleRadius;
  for (var depth = 0; depth < depthSlider.value(); ++depth) {
    innerCircleRadius = drawLayer(size);
    rotate(PI / numCirclePerRingSlider.value());
    size *= scaleSlider.value();
  }
  ellipse(0, 0, innerCircleRadius * 2, innerCircleRadius * 2);
  pop();
}

function setStrokeWeight(size) {
  strokeWeight(penSlider.value() * size / 800);
}

function drawLayer(size) {
  var numCirclesPerRing = numCirclePerRingSlider.value();
  var circRadius = 1.0;
  var polyVertexDistFromCenter = circRadius / sin(PI / numCirclesPerRing);
  var scaleToScreenFactor = size / (polyVertexDistFromCenter + circRadius);
  circRadius *= scaleToScreenFactor;
  var strokeSize = varyStrokeCheckbox.checked() ? size : initialSize();
  setStrokeWeight(strokeSize);
  polyVertexDistFromCenter *= scaleToScreenFactor;
  var diameter = circRadius * 2;
  for (var circCtr = 0; circCtr < numCirclesPerRing; ++circCtr) {
    ellipse(polyVertexDistFromCenter, 0, diameter, diameter);
    rotate(2 * PI / numCirclesPerRing);
  }
  return polyVertexDistFromCenter - circRadius;
}


function keyTyped() {
  if (key == 's') {
    createCanvas(2000, 2000);
    drawImageOnly();
    var filename = 'flwCircles_d' + depthSlider.value() + '_n' + numCirclePerRingSlider.value() + '_s' + scaleSlider.value() + '_p' + penSlider.value() + '.png';
    save(filename);
    createCanvas(800, 800);
    needsRedraw = true;
  }
}