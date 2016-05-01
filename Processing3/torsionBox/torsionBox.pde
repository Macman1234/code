import processing.pdf.*;

//

//TO Do
// - draw sides of box

// - Could add detents at top of slots, and an etched region 
//opposite the slot that would create a notch for the detents.
//But this is probably unnecessary, if we create the slots to be snug.

//Draw the grid pieces
float DPI = 72;

//inputs
//Ian Kirby suggests 4 inch sides to the cells
float depthInInches = 1.5;
float materialThicknessInInches = 7.0 / 32;
float kerfInInches = 0.005;
float NUDGE = DPI * 0.0625;
float lengthInInches = 23.5;
float widthInInches = 25.25;
int numLengths = 5;
int numWidths = 5;

//computed
float kerf = kerfInInches * DPI;
float depth = depthInInches * DPI + kerf;
int depthIn100ths = round(depthInInches * 100);
float slotDepth = depth / 2;
float thickness = materialThicknessInInches * DPI;
int lengthIn100ths = round(lengthInInches * 100);
int widthIn100ths = round(widthInInches * 100);
int kerfInThous = round(kerfInInches * 1000);

void setup() {
  size(2200, 1400, PDF, "torsionBox_"+depthIn100ths +"D_"+lengthIn100ths+"L_"+widthIn100ths+"W_"+kerfInThous+"K.pdf");
  background(255);
  noFill();
  strokeWeight(1/DPI);

  drawPieces(lengthInInches * DPI, numWidths, numLengths);
  translate(0, (depthInInches  * DPI + kerf + NUDGE) * numLengths);
  drawPieces(widthInInches * DPI, numLengths, numWidths);
}

void drawPieces(float side, int numSlots, int numPieces) {
  //draw lengths
  float x = NUDGE;
  float y = NUDGE;
  float lengthBetweenSlots = (side + kerf - (thickness - kerf) * numSlots) / (numSlots + 1);
  for (int pieceCtr = 0; pieceCtr < numPieces; ++pieceCtr) {
    beginShape();
    for (int slotCtr = 0; slotCtr < numSlots; ++slotCtr) {
      vertex(x, y);
      x+= lengthBetweenSlots;
      vertex(x, y);
      y += slotDepth;
      vertex(x, y);
      x+= thickness - kerf;
      vertex(x, y);
      y -= slotDepth;
    }
    vertex(x, y);
    x+= lengthBetweenSlots;
    vertex(x, y);
    y += depth;
    vertex(x, y);
    x -= side;
    vertex(x, y);
    endShape(CLOSE);
    y += NUDGE;
  }
}