var depthSlider, numCirclePerRingSlider, scaleSlider, penSlider, varyStrokeCheckbox;
var needsRedraw = true;

function setup() {
  createCanvas(800, 800);
  clear();

  var sliderInset = 90;
  depthSlider = makeSlider("depth", 1, 12, 1, sliderInset, 20, 1);
  numCirclePerRingSlider = makeSlider("# circles", 3, 50, 3, sliderInset, 50, 1);
  scaleSlider = makeSlider("scale", 0.1, 0.99, 0.7, sliderInset, 80, 0.001);
  penSlider = makeSlider("pen", 1, 100, 20, sliderInset, 110, 1);
  varyStrokeCheckbox = makeCheckbox("vary stroke", false, sliderInset, 140);
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  clear();
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
  return width * 0.4;
}

function drawImageOnly() {
  push();
  translate(width * 0.5, height * 0.5);
  var size = initialSize();
  for (var depth = 0; depth < depthSlider.value(); ++depth) {
    drawLayer(size);
    rotate(PI / numCirclePerRingSlider.value());
    size *= scaleSlider.value();
  }
  pop();
}

function drawLayer(size) {
  noFill();
  stroke(0);
  var numCirclesPerRing = numCirclePerRingSlider.value();
  var circRadius = 1.0;
  var polyVertexDistFromCenter = circRadius / sin(PI / numCirclesPerRing);
  var scaleToScreenFactor = size / (polyVertexDistFromCenter + circRadius);
  circRadius *= scaleToScreenFactor;
  var strokeSize = varyStrokeCheckbox.checked() ? size : initialSize();
  strokeWeight(penSlider.value() * strokeSize / width);
  polyVertexDistFromCenter *= scaleToScreenFactor;
  var diameter = circRadius * 2;
  for (var circCtr = 0; circCtr < numCirclesPerRing; ++circCtr) {
    ellipse(polyVertexDistFromCenter, 0, diameter, diameter);
    rotate(2 * PI / numCirclesPerRing);
  }
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