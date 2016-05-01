function setup() {
  createCanvas(1024, 1024);

  translate(width / 2, height / 2);
  textFont("Baskerville Old Face");
  var sizeScaler = 1.5;

var opacity = 100;
  drawText("F", sizeScaler * width / 6, 32, color(128, 0, 128, opacity));
  drawText("R", sizeScaler * width / 9, 24, color(96, 0, 96, opacity));
  drawText("E", sizeScaler * width / 12, 20, color(64, 0, 64, opacity));
  drawText("Y", sizeScaler * width / 15, 16, color(32, 0, 32, opacity));
  drawText("A", sizeScaler * width / 18, 12, color(16, 0, 16, opacity));
}

function drawText(someText, txtHeight, numLetters, fillColor) {
  textSize(txtHeight);
  fill(fillColor);
  textStyle(ITALIC);
  var txtWidth = textWidth(someText);

  for (var i = 0; i < numLetters; ++i) {
    text(someText, -txtWidth / 2, -txtHeight *0.9);
    rotate(2 * PI / numLetters);
  }

}
