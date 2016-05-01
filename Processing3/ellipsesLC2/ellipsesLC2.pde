float strkWeight, distanceToEllipseCenter, ellipseRotation, ellipseWidth, heightFactor;
int n, vertices;
boolean refresh = true;

void setup() {
  //High resolution of the bitmap version is needed 
  //if our vector-based drawing is to look smooth.
  size(960, 960);
  strkWeight = 5;
  distanceToEllipseCenter = 0.01;
  ellipseWidth = 0.3;
  heightFactor = 0.15;
  vertices = 3;
  n = 10;
  //noLoop();
}

void keyPressed() {
  if (key == 'd') {
    distanceToEllipseCenter -= 0.01;
    if(distanceToEllipseCenter < 0.01) distanceToEllipseCenter = 0.01;
    refresh = true;
  } else if (key == 'D') {
    distanceToEllipseCenter += 0.01;
    refresh = true;
  } else if (key == 'e') {
    ellipseWidth += 0.01;
    refresh = true;
  } else if (key == 'E') {
    ellipseWidth += 0.01;
    refresh = true;
  } else if (key == 'n') {
    n -= 1;
    if (n < 5) n = 5;
    refresh = true;
  } else if (key == 'N') {
    n += 1;
    refresh = true;
  } else if (key == 's') {
    strkWeight -= 0.5;
    if (strkWeight < 0.5) strkWeight = 0.5;
    refresh = true;
  } else if (key == 'S') {
    strkWeight += 0.5;
    refresh = true;
  } else if (key == 'v') {
    vertices -= 1;
    if (vertices < 2) vertices = 2;
    refresh = true;
  } else if (key == 'V') {
    vertices += 1;
    refresh = true;
  }
}

void draw() {
  if (refresh) {
    background(255);
    drawEllipses(); 
    refresh = false;
  }
}


void drawEllipses() {
  float txtHeight = 9;
  fill(0,0,255);
  text("Hit first letter of variable (lower or uppercase) to change values.", 0, txtHeight* 2);
  text("distanceToEllipseCenter ="+distanceToEllipseCenter, 0, txtHeight* 4);
  text("ellipseWidth ="+ellipseWidth, 0, txtHeight * 6);
  text("numEllipses ="+n, 0, txtHeight * 8);
  text("strkWeight ="+strkWeight, 0, txtHeight * 10);
  text("vertices ="+vertices, 0, txtHeight * 12);


  translate(width/2, height/2);
  //scale(1, -1);
  noFill();
  strokeWeight(strkWeight);
  float sizeMultiplier =((float)0.6) / (ellipseWidth + distanceToEllipseCenter);
  ellipseRotation = 0;
  for (int i = 0; i < n; ++i) {
    float phi = vertices * 2 * PI * i / n;
    float x = width * distanceToEllipseCenter * sin(phi) * sizeMultiplier;
    float y = height * distanceToEllipseCenter * cos(phi) * sizeMultiplier;

    ellipse(x, y, ellipseWidth * width * sizeMultiplier, heightFactor * height * sizeMultiplier);
    rotate(2 * PI / n);
  }
}