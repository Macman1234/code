//TO DO
// - automatically reposition to center of screen
// - automatically size to fit 
// - sliders for rules (e.g. LR, LLRR, LRLR, LRRL, LLLRRR, LLRLRR, LLRRLR, LLRRRL)
// - sliders for depth, # sides, rotation, amount of twist (dRot)

// var rule = ['L', 'R', 'L']; Koch
var rule = ['L', 'L', 'L', 'R', 'R', 'R'];
// var rule = ['L', 'R', 'R', 'L', 'L', 'R'];
// var rule = ['L', 'R', 'R', 'R', 'L', 'L'];
// var rule = ['L', 'R', 'R', 'R', 'L', 'L', 'R', 'L'];
// var rule = ['L', 'R', 'R', 'R', 'L', 'R', 'L', 'L'];
var depth = 2;
var rotationInRadians = Math.PI * 0.3;
var numLsystemsToDraw = 3;
var needsRedraw = true;
// var lineLength;

function setup() {
  createCanvas(900, 900);
  clear();
}

function expandListOneLevel(list) {
  var newList = [];
  newList = newList.concat(rule);
  for (var listIndex = 0; listIndex < list.length; ++listIndex) {
    newList.push(list[listIndex]);
    newList = newList.concat(rule);
  }
  return newList;
}

function expandList(list, depthRemaining) {
  if (depthRemaining < 2) {
    return list;
  }
  return expandList(expandListOneLevel(list), depthRemaining - 1);
}

function draw() {
  if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  strokeWeight(0.5);
  translate(width * 0.4, height * 0.5);
  drawLsystem(numLsystemsToDraw, TWO_PI / numLsystemsToDraw);
}

function maxDistanceFromOrigin(list) {
  //assume lineLength = 1
  var xPrev = 0;
  var yPrev = 0;
  var x, y;
  var rot = 0;
  var maxDist = 0;
  var dRot = HALF_PI / list.length;
  for (var listIndex = 0; listIndex <= list.length; ++listIndex) {
    x = xPrev +  cos(rot);
    y = yPrev + sin(rot);
    maxDist = max(maxDist, dist(0, 0, x, y));
    xPrev = x;
    yPrev = y;
    if (listIndex < list.length) {
      var turnLeft = list[listIndex] == 'L';
      rot += (turnLeft ? -rotationInRadians : rotationInRadians) + dRot;
    }
  }
  return maxDist;
}

function drawLsystem(numTimesToDraw, rotationAfterEachDraw) {
  var list = expandList(rule.slice(), depth);
  var lineLength = width / maxDistanceFromOrigin(list) /3;

  var dRot = 0;//HALF_PI / list.length * 0.5;
  for (var drawCtr = 0; drawCtr < numTimesToDraw; ++drawCtr) {
    var xPrev = 0;
    var yPrev = 0;
    var x, y;
    var rot = 0;
    for (var listIndex = 0; listIndex <= list.length; ++listIndex) {
      x = xPrev + lineLength * cos(rot);
      y = yPrev + lineLength * sin(rot);
      line(xPrev, yPrev, x, y);
      xPrev = x;
      yPrev = y;
      if (listIndex < list.length) {
        var turnLeft = list[listIndex] == 'L';
        rot += (turnLeft ? -rotationInRadians : rotationInRadians) + dRot;
      }
    }
    translate(x, y);
    rotate(rotationAfterEachDraw);
  }
}


// function drawOneLsystemWithTranslations() {
//   var list = expandList(rule.slice(), depth);
//   var dRot = HALF_PI / list.length;
//   // println(list);
//   for (var listIndex = 0; listIndex < list.length; ++listIndex) {
//     line(0, 0, x, y);
//     translate(lineLength, 0);
//     var turnLeft = list[listIndex] == 'L';
//     rotate((turnLeft ? -rotationInRadians : rotationInRadians) + dRot);
//   }
//   line(0, 0, lineLength, 0);

// }