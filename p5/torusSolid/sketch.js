var numberOfLayers = 16;
var layerToEmphasize = numberOfLayers / 2;
var zExtrema;

function setup() {
  createCanvas(640, 480);
  zExtrema = extremaZ();
}

function draw() {
  background(255);
  fill(127);
  translate(width / 2, height / 2);
  var msg = "layer " + layerToEmphasize;
  var txtSize = 12;
  textSize(txtSize);
  text(msg, -textWidth(msg) / 2, txtSize / 2);
  msg = "Use up/down arrows to change layer.";
  text(msg, -textWidth(msg) / 2, height / 2 - txtSize / 2);


  scale(1, -1);
  strokeWeight(1);

  var numStepsAroundCircle = 360;
  var dz = (zExtrema[1] - zExtrema[0]) / numberOfLayers;
  var zStart = zExtrema[0] + dz / 2;
  var dt = 2 * PI / numStepsAroundCircle;
  var drawVertex = function(t, u) {
    var r = r0(t, u);
    vertex(r * cos(t), r * sin(t));
  };
  for (var zLayer = 0; zLayer < numberOfLayers; ++zLayer) {
    var z = zStart + dz * zLayer;
    var clr = zLayer == layerToEmphasize ? color(0, 0, 255) : color(0, 0, 255, 15);
    fill(clr);
    noStroke(); //stroke(clr);
    var u1 = u(0, z);
    for (var t = 0; t <= 2 * PI - dt; t += dt) {
      var u2 = u(t + dt, z);
      beginShape();
      for (i = 0; i < u1.length; ++i) {
        drawVertex(t, u1[i]);
      }
      for (i = u2.length - 1; i >= 0; --i) {
        drawVertex(t + dt, u2[i]);
      }
      endShape(CLOSE);
      u1 = u2;
    }
  }
}

function keyPressed() {
  if (keyCode === UP_ARROW && layerToEmphasize < numberOfLayers - 1) {
    ++layerToEmphasize;
  } else if (keyCode === DOWN_ARROW && layerToEmphasize > 0) {
    --layerToEmphasize;
  }
}

function rMajor() {
  return width / 4;
}

function rMinor() {
  return width / 12;
}

function r0(t, u) {
  return rMajor() + rMinor() * cos(u);
}

function z(t, u) {
  return rMinor() * sin(u);
}

function u(t, z) {
  //return a sorted array of roots, othere should be an even number.
  //This could be generalized:
  //Fastest/best way may be to do binary search, then pass collection
  //of found roots, so that we can divide out already found roots.

  //When we can, however, we will solve for the roots explicitly 
  //until this is impossible.
  var u1 = asin(z / rMinor());
  var u2;
  if (u1 < 0) {
    u2 = u1 + 2 * PI;
    u1 = PI - u1;
  } else {
    u2 = PI - u1;
  }
  return new Array(u1, u2);
}

function extremaZ() {
  var numStepsOnT = 360;
  var numStepsOnU = 360;
  var zMax = -1e9;
  var zMin = 1e9;
  var dt = 2 * PI / numStepsOnT;
  var du = 2 * PI / numStepsOnU;
  for (var t = 0; t < 2 * PI; t += dt) {
    for (var u = 0; u < 2 * PI; u += du) {
      var zTemp = z(t, u);
      if (zTemp > zMax) {
        zMax = zTemp;
      } else if (zTemp < zMin) {
        zMin = zTemp;
      }
    }
  }
  return new Array(zMin, zMax);
}