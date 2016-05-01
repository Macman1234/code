void initializeNeighborPixelArray() {
  //defined clockwise from 12 o'clock
  neighbors = new ArrayList<NeighborPixel>();
  adjacentNeighbors = new ArrayList<NeighborPixel>();
  
  NeighborPixel neighbor = new NeighborPixel(0, -1);
  neighbors.add(neighbor);
  adjacentNeighbors.add(neighbor);
  
  neighbors.add(new NeighborPixel(1, -1));

  neighbor = new NeighborPixel(1, 0);
  neighbors.add(neighbor);
  adjacentNeighbors.add(neighbor);
  
  neighbors.add(new NeighborPixel(1, 1));
  
  neighbor = new NeighborPixel(0, 1);
  neighbors.add(neighbor);
  adjacentNeighbors.add(neighbor);
  
  neighbors.add(new NeighborPixel(-1, 1));

  neighbor = new NeighborPixel(-1, 0);
  neighbors.add(neighbor);
  adjacentNeighbors.add(neighbor);
  
  neighbors.add(new NeighborPixel(-1, -1));
}

class NeighborPixel {
  int dx, dy;

  NeighborPixel(int dx_, int dy_) {
    dx = dx_; 
    dy= dy_;
  }

  int pixel(PGraphics pg, int x, int y) {
    //is it out of the picture? If so, call it white
    if (x + dx < 1 || x + dx >= pg.width ||y + dy < 1 || y + dy >= pg.height) {
      return WHITE;
    }
    int offset = (y + dy) * pg.width + x + dx;
    return pg.pixels[offset];
  }

  boolean isWhite(PGraphics pg, int x, int y) {
    return pixel(pg, x, y) == WHITE;
  }

  boolean isBlack(PGraphics pg, int x, int y) {
    return pixel(pg, x, y) == BLACK;
  }
}