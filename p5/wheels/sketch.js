var wheel;
var deltaTime = Math.PI / 1440;
var time;
var stepsPerFrame = 50;
var MAX_PEN_WIDTH = 2.5;
var fixedPenWidth = true;
var needsRedraw = true;

var canvas, overlapSlider, lobeSlider;

function setup() {
  canvas = createCanvas(640, 640);

  var t = createP("Overlap");
  t.position(10, 3);
  overlapSlider = createSlider(1, 50, 2);
  overlapSlider.position(70, 20);
  overlapSlider.style('width', '80px');
  overlapSlider.input(forceRedraw);

  t = createP("Lobes");
  t.position(10, 33);
  lobeSlider = createSlider(1, 50, 3);
  lobeSlider.position(70, 50);
  lobeSlider.style('width', '80px');
  lobeSlider.input(forceRedraw);
}

function forceRedraw() {
  needsRedraw = true;
}

function draw() {
  if(!needsRedraw) {
    return;
  }
  needsRedraw = false;
  background(255);
  push();
  translate(width / 2, height / 2);
  scale(1, -1);
  var overlap = overlapSlider.value();
  var lobes = lobeSlider.value();
  var wheelBaseRadius = width * 0.46/ (1 + overlap/(overlap + lobes));
  wheel = new Wheel(wheelBaseRadius, overlap, color(0));
  wheel.setSubwheel(new Wheel(wheelBaseRadius / (overlap + lobes) * overlap, overlap + lobes, color(0)));
  for (time = 0; time < 2 * PI + deltaTime; time += deltaTime) {
    wheel.drawCenteredAt(0, 0);
  }
  pop();
  
  //slider value labels
  text("" + overlap, 155, 33);
  text("" + lobes, 155, 63);

}