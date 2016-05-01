var numRows = 8;

function setup() {
  createCanvas(700, 700);
}

function draw() {
  translate(width * 0.5, height * 0.5);
  var spacing = width / (numRows + 1);
  for (var row = -numRows / 2; row <= numRows / 2; ++row) {
    for (var col = -numRows / 2; col <= numRows / 2; ++col) {
      var diameter = 0.8 * width / numRows / sqrt(1 + abs(row) + abs(col));
      ellipse(col * spacing, row * spacing, diameter, diameter);
    }
  }
}