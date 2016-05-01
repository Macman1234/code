int izzyNumber = 0;
int uniqueCombinations = 0;
int polySides = 3;
void setup() {
  size(320, 320);
  frameRate(2);
  background(0);
}

void draw() {
  if (izzyNumber > 63) return;
  background(0);
  translate(width/2, height * 0.6);
  strokeWeight(1.5);
  stroke(255);
  fill(255);
  int izzyCopy = izzyNumber;
  for (int i = 0; i < 6; ++i ) {
    if (izzyCopy % 2 == 1) {
      triangle(0, 0, sin(i * PI /polySides) * width, -cos(i * PI /polySides) * width
        , sin((i+1) * PI /polySides) * width, -cos((i+1) * PI /polySides) * width);
    }
    izzyCopy = (int) (izzyCopy / 2);
  }
  int edgeWith = 180;
  float outerTriSideLength = width + edgeWith*2/sqrt(3);
  strokeWeight(edgeWith);
  stroke(100);
  noFill();
  triangle(0, -outerTriSideLength /  sqrt(3)
    , outerTriSideLength / 2, outerTriSideLength / sqrt(3) / 2
    , - outerTriSideLength / 2, outerTriSideLength /  sqrt(3) / 2);

  textSize(32);
  fill(128);

  //is this izzy new?
  int testNumber = izzyNumber;
  boolean isNew = true;
  for (int i = 0; i < 3; ++i) {
    //rotateByTwoBits
    testNumber = ((int)(testNumber / 4))  + ((testNumber % 4) * 16);
    if (testNumber < izzyNumber) {
      isNew = false;
    }
  }
  if (isNew) {
    ++uniqueCombinations;
    String izzyString = "" + uniqueCombinations;
    text(izzyString, -textWidth(izzyString)/2, height*0.1);
  }

  ++izzyNumber;
} 