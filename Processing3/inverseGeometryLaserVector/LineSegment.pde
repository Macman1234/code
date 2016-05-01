class LineSegment {
  float x0, y0, x1, y1;

  LineSegment( float x0_, float y0_, float x1_, float y1_) {
    x0 = x0_;
    y0 = y0_;
    x1 = x1_;
    y1 = y1_;
  }

  void draw() {
    line(x0, y0, x1, y1);
  }

  void drawInvertedAndRotated(float scalar) {
    Point a = new Point(x0 , y0 );
    a.invertAndRotate(scalar);
    Point b = new Point(x1 , y1 );
    b.invertAndRotate(scalar);
    
    line(a.x, a.y, b.x, b.y);
  }

  void drawInverted(float scalar) {
    float c0 = 1/ dist(0, 0, x0, y0);
    c0 = c0 * c0 * scalar;
    float c1 = 1/ dist(0, 0, x1, y1);
    c1 = c1 * c1 * scalar;
    line(x0 * c0, y0 * c0, x1 * c1, y1 * c1);
  }
  
  ArrayList<LineSegment> inPieces(int n ) {
    ArrayList<LineSegment> pieces = new ArrayList<LineSegment>();
    for(int i = 0; i < n ; ++i) {
      float xStep = (x1 - x0) / n;
      float yStep = (y1 - y0) / n;
      pieces.add(new LineSegment(x0 + i * xStep, y0 + i * yStep, x0 + (i+1) * xStep, y0 + (i+1) * yStep));
    }
    return pieces;
  }
    
}