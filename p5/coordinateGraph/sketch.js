var scale_ = 10;

function setup() {
  createCanvas(400, 400);
  translate(width/2, height/2);
  scale(scale_, -scale_);
  strokeWeight(1.0 / scale_);
}

function changeScale(newScale) {
  scale(newScale / scale_, newScale / scale_);
  scale_ = newScale;
  strokeWeight(1.0 / scale_);
}

function draw() {
  stroke(200);
  //draw x-axis
  line(-width/scale_, 0, width/scale_,0);
  //draw y-axis
  line(0, -height/scale_, 0, height/scale_);
  
  //draw tick marks on x-axis
  // for(i = )
}

function xMin() {
  
}