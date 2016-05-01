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

  int pixel(int[] pxls, int x, int y) {
    if (isOutOfPicture(x, y)) {
      return WHITE;
    }
    int offset = (y + dy) * width + x + dx;
    return pxls[offset];
  }

  boolean isWhite(int[] pxls, int x, int y) {
    return pixel(pxls, x, y) == WHITE;
  }

  boolean isBlack(int[] pxls, int x, int y) {
    return pixel(pxls, x, y) == BLACK;
  }

  boolean isOutOfPicture(int x, int y) {
    return x + dx < 1 || x + dx >= width ||y + dy < 1 || y + dy >= height;
  }
}