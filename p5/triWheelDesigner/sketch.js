var needsRedraw = true;

function setup() {
  createCanvas(1200, 1200);
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;

  drawWheelOnly();

  var msg = "Type 's' to save.";
  noStroke();
  fill(0);
  text(msg, (width - textWidth(msg)) * 0.5, 20);
}

function drawWheelOnly() {
  clear();
  push();
  translate(width * 0.5, height * sqrt(3) / 3);

  var arcRadius = width * 0.9;

  var innerRadiusFraction = 0.8;

  for (var wheelCtr = 0; wheelCtr < 3; ++wheelCtr) {
    drawTriWheel(arcRadius, color(0));
    drawTriWheel(arcRadius * innerRadiusFraction, color(255));
    rotate(PI / 3);
    arcRadius *= sqrt(3) - 1;
  }
  // drawTriWheel(arcRadius, color(100));
  // drawTriWheel(innerArcRadius, color(255));


  pop();
}

function hexSpokeWheel() {
  drawTriWheel(arcRadius, color(0));
  drawTriWheel(innerArcRadius, color(255));
  // drawTriSpoke(innerArcRadius * 0.45, 0.5 * (arcRadius - innerArcRadius));
  drawHexSpoke(innerArcRadius * 0.45, 0.3 * (arcRadius - innerArcRadius));
}

function keyTyped() {
  if (key == 's') {
    drawWheelOnly();
    save('triWheel.jpg');
    needsRedraw = true;
  }
}

function drawTriWheel(radius, fillColor) {
  var diameter = radius * 2;
  fill(fillColor);
  for (var vrtxCtr = 0; vrtxCtr < 3; ++vrtxCtr) {
    arc(0, -radius / sqrt(3), diameter, diameter, PI / 3, TWO_PI / 3);
    rotate(TWO_PI / 3);
  }
}

function drawTriSpoke(radius, strokeWt) {
  push();
  rotate(PI / 3);
  var diameter = radius * 2;
  stroke(0);
  strokeWeight(strokeWt);

  for (var vrtxCtr = 0; vrtxCtr < 3; ++vrtxCtr) {
    line(0, 0, 0, -radius);
    rotate(TWO_PI / 3);
  }
  pop();
}

function drawHexSpoke(radius, strokeWt) {
  push();
  rotate(PI / 3);
  var diameter = radius * 2;
  stroke(0);
  strokeWeight(strokeWt);

  for (var vrtxCtr = 0; vrtxCtr < 3; ++vrtxCtr) {
    line(0, radius * 1.25, 0, -radius);
    rotate(TWO_PI / 3);
  }
  pop();
}