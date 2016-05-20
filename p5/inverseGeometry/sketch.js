var needsRedraw = true;

function setup() {
  createCanvas(800, 800);
  numRotationsSlider = makeSlider("number of rotations", 0, 5, 1, 150, 20, 1);
  penWidthSlider = makeSlider("pen width", 0.3, 2, .5, 150, 50, 0.01);
  twistSlider = makeSlider("twist", 0, 100, 10, 150, 80, 1);
  densitySlider = makeSlider("density", 1, 12, 2, 150, 110, 1);
  centerRadiusSlider = makeSlider("center radius", 0.1, 0.5, 0.25, 150, 140, 0.01);
  ringThicknessSlider = makeSlider("ring thickness", 0, 100, 10, 150, 170, 1);
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  drawImageOnly();

  noStroke();
  var labelInset = 280;
  fill(127);
  text(numRotationsSlider.value(), labelInset, 33);
  text(penWidthSlider.value(), labelInset, 63);
  text(twistSlider.value(), labelInset, 93);
  text(densitySlider.value(), labelInset, 123);
  text(centerRadiusSlider.value(), labelInset, 153);
  text(ringThicknessSlider.value(), labelInset, 183);
  var msg = "Type 's' to save as PNG."
  text(msg, (width - textWidth(msg)) / 2, 20);

}

function drawImageOnly() {
  background(255);
  push();
  translate(width * 0.5, height * 0.5);

  drawHorizontalLines();
  for (var rotCtr = 0; rotCtr < numRotationsSlider.value(); ++rotCtr) {
    rotate(PI / (numRotationsSlider.value() + 1));
    drawHorizontalLines();
  }
  //draw disk at center
  fill(0);
  noStroke();
  var centerDiameter = centerRadiusSlider.value() * width;
  ellipse(0,0,centerDiameter, centerDiameter);
  fill(255);
  centerDiameter *= (100.0 - ringThicknessSlider.value()) * 0.0101;
  ellipse(0,0,centerDiameter, centerDiameter);
  pop();
  
}


function keyTyped() {
  if (key == 's') {
    createCanvas(2000, 2000);
    drawImageOnly();
    var filename = 'inverseGeometry' + Math.round(millis()) + '.png';
    save(filename);
    createCanvas(800, 800);
    needsRedraw = true;
  }
}

function drawHorizontalLines() {
  var gridWidth = width * 3;
  var squareLength = gridWidth / squaresPerSide();
  var squaresToDrop = densitySlider.value();
  var closestPreinversionX = squaresToDrop * squareLength;
  var furthestPoint = invertAndRotatePoint(closestPreinversionX, 0, 1);
  var scalar = 1.0 / dist(0, 0, furthestPoint.x, furthestPoint.y) * 0.45 * width;
  // var yStart = -gridWidth * 0.5;
  var numStepsPerSquare = int(squareLength / maxSepLength()) + 1;
  var stepLength = squareLength / numStepsPerSquare;


  var squaresPerHalf = int(squaresPerSide() /2);
  for (var row = - squaresPerHalf; row <= squaresPerHalf; ++row) {
    for (var col = - squaresPerHalf; col <= squaresPerHalf; ++col) {
      var isTooCloseToOrigin =  abs(row) < squaresToDrop
                            && ( abs(col) < squaresToDrop || col == - squaresToDrop ) ;
      if (!isTooCloseToOrigin) {
        var x = col * squareLength;
        var y = - row * squareLength;
        var prevPoint = invertAndRotatePoint(x, y, scalar);
        for (var stepCtr = 0; stepCtr < numStepsPerSquare; stepCtr++) {
          x += stepLength;
          var pointB = invertAndRotatePoint(x, y, scalar);
          if (dist(prevPoint.x, prevPoint.y, pointB.x, pointB.y) > 1) {
            var sw = dist(0, 0, prevPoint.x, prevPoint.y) * 0.1 * penWidthSlider.value();
            strokeWeight(sw);
            line(prevPoint.x, prevPoint.y, pointB.x, pointB.y);
            prevPoint = pointB;
          }
        }
      }
    }
  }
}


function maxSepLength() {
  return 3;
}

function squaresPerSide() {
  return densitySlider.value() * 7;
}

function invertAndRotatePoint(x, y, scalar) {
  var c0 = 1 / dist(0, 0, x, y);
  c0 = c0 * c0 * scalar;
  x *= c0;
  y *= c0;
  var angle = dist(0, 0, x, y) * twistSlider.value() * 0.08 / width;
  var xNew = x * cos(angle) - y * sin(angle);
  var yNew = x * sin(angle) + y * cos(angle);
  return {
    'x': xNew,
    'y': yNew
  };
}