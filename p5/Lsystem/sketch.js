//TO DO
// - automatically reposition to center of screen
// - automatically size to fit 
// - sliders for rules (e.g. LR, LLRR, LRLR, LRRL, LLLRRR, LLRLRR, LLRRLR, LLRRRL)
// - sliders for depth, # sides, rotation, amount of twist (dRot)
var depthSlider, symmetrySlider, rotationSlider, scaleSlider, xShiftSlider, yShiftSlider, penSlider;
var rules;
var rule;// = ['L', 'R', 'L']; //Koch
// var rule = ['L', 'L', 'L', 'R', 'R', 'R'];
// var rule = ['L', 'R', 'R', 'L', 'L', 'R'];
// var rule = ['L', 'R', 'R', 'R', 'L', 'L'];
// var rule = ['L', 'R', 'R', 'R', 'L', 'L', 'R', 'L'];
// var rule = ['L', 'R', 'R', 'R', 'L', 'R', 'L', 'L'];
var depth = 3;
var rotationInRadians = Math.PI * 0.;
// var numLsystemsToDraw = 3;
var needsRedraw = true;
// var lineLength;

function setup() {
  createCanvas(900, 900);
  clear();
  rules = [
    ['L', 'R'],
    ['L', 'R', 'L'],
    ['L', 'R', 'L', 'R'],
    ['L', 'R', 'R', 'L'],
    ['L', 'L', 'L', 'R', 'R', 'R'],
    ['L', 'R', 'R', 'L', 'L', 'R'],
    ['L', 'R', 'R', 'R', 'L', 'L', 'R', 'L'],
    ['L', 'R', 'R', 'R', 'L', 'R', 'L', 'L']
  ];
  
  var sliderInset = 90;
  ruleIndexSlider = makeSlider("rule", 0, rules.length - 1, 0, sliderInset, 20, 1);
  depthSlider = makeSlider("depth", 1, 5, 2, sliderInset, 50, 1);
  symmetrySlider = makeSlider("symmetry", 3, 8, 3, sliderInset, 80, 1);
  rotationSlider = makeSlider("rotation", 0, 1, 0.3, sliderInset, 110, 0.001);
  scaleSlider = makeSlider("scale", 0, 1, 0.3, sliderInset, 140, 0.01);
  xShiftSlider = makeSlider("x shift ", 0.1, 0.9, 0.5, sliderInset, 170, 0.01);
  yShiftSlider = makeSlider("y shift", 0.1, 0.9, 0.5, sliderInset, 200, 0.01);
  penSlider = makeSlider("pen", 0.03, 1, 0.1, sliderInset, 230, 0.01);
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
  clear();
  depth = depthSlider.value();
  rule = rules[ruleIndexSlider.value()];
  rotationInRadians = Math.PI * rotationSlider.value();
  strokeWeight(30 * penSlider.value());
  push();
  translate(width * xShiftSlider.value(), height * (1 - yShiftSlider.value()));
  drawLsystem(symmetrySlider.value());
  pop();

  fill(255, 0, 0);
  noStroke();
  var valueTextOffset = 710;
  text(ruleIndexSlider.value(), valueTextOffset, 33);
  text(depthSlider.value(), valueTextOffset, 63);
  text(symmetrySlider.value(), valueTextOffset, 93);
  text(rotationSlider.value(), valueTextOffset, 123);
  text(xShiftSlider.value(), valueTextOffset, 153);
  text(xShiftSlider.value(), valueTextOffset, 183);
  text(yShiftSlider.value(), valueTextOffset, 213);
  text(penSlider.value(), valueTextOffset, 243);
  var msg = "Type 's' to save as PNG."
  text(msg, (width - textWidth(msg)) / 2, 20);

}

function maxDistanceFromOrigin(list) {
  //assume lineLength = 1
  var xPrev = 0;
  var yPrev = 0;
  var x, y;
  var rot = 0;
  var maxDist = 0;
  var dRot = 0; //HALF_PI / list.length * 50;
  for (var listIndex = 0; listIndex <= list.length; ++listIndex) {
    x = xPrev + cos(rot);
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

function drawLsystem(numTimesToDraw) {
  var rotationAfterEachDraw = TWO_PI / numTimesToDraw;
  var list = expandList(rule.slice(), depth);
  var lineLength = width / maxDistanceFromOrigin(list) / 3;

  var dRot = 0; //HALF_PI / list.length * 0.5;
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