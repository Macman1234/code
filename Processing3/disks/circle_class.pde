class Disk {
  float x, y, radius;
  boolean isBlack;

  Disk(float x_, float y_, float r_, boolean isBlack_) {
    x = x_; 
    y = y_; 
    radius = r_;
    isBlack = isBlack_;
  }

  Disk(float x_, float y_, float r_) {
    x = x_; 
    y = y_; 
    radius = r_;
    isBlack = random(1) < 0.4;
  }

  void draw() {
    fill(isBlack ? BLACK : WHITE);
    noStroke();
    ellipse(x, y, radius * 2, radius * 2);
  }
}