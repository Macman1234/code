int numTeeth = 64;

void setup() {
  size(640, 640);
  background(255);

  translate(width * 0.5, height * 0.5);

  rectangular();
}

void rectangular() {
  for (int i = 0; i < numTeeth; ++i) {
    float pitchRadius = 0.4 * width;
    float angle = 2 * PI / numTeeth;
    float toothHeight = pitchRadius * angle * 0.1;
    float x0 = cos(angle/2) * (pitchRadius - toothHeight);
    float y0 = sin(angle/2) * (pitchRadius - toothHeight);
    float x1 = cos(angle/2) * (pitchRadius + toothHeight);
    float y1 = sin(angle/2) * (pitchRadius + toothHeight);
    line(x0, y0, x1, y1);   
    line(x1, y1, pitchRadius + toothHeight, 0);   
    line(pitchRadius + toothHeight, 0, pitchRadius - toothHeight, 0);   
    line(pitchRadius - toothHeight, 0, x0, -y0);   
    rotate(angle);
  }
}

void sawtooth() {
  for (int i = 0; i < numTeeth; ++i) {
    float pitchRadius = 0.3 * width;
    float angle = 2 * PI / numTeeth;
    float x = cos(angle/2) * pitchRadius;
    float y = sin(angle/2) * pitchRadius;
    float toothHeight = pitchRadius * angle;
    line(x, y, pitchRadius + toothHeight, 0);   
    line(pitchRadius + toothHeight, 0, x, -y);
    rotate(angle);
  }
}