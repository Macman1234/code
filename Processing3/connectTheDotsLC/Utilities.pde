ArrayList<NeighborPixel> neighbors;
int WHITE = color(255);
int BLACK = color(0);
float PIXELS_PER_INCH = 72;
float maxError = .5;

class EdgeCalculator { 
  ArrayList<EdgePath> paths;
  boolean[][] onEdge;

  EdgeCalculator() {
    onEdge = new boolean[width][height];
    findEdgePixels();
  }

  void blackenAnyNonWhite() {
    int i = 0;
    for (int pixel : pixels) {
      float bright = (red(pixel) + green(pixel) + blue(pixel)) / 3;
      pixels[i++] = bright < 80 ? WHITE : BLACK;
    }
  }

  void addPixelLayer() {
    for (int i = 1; i < width-1; ++i) {
      for (int j = 1; j < height-1; ++j) {
        if (onEdge[i][j]) {
          for (int dx = -1; dx < 2; ++dx) {
            for (int dy = -1; dy < 2; ++dy) {
              pixels[(j+dy) * width + i + dx] = 0 ;
            }
          }
        }
      }
    }
  }

  void removePixelLayer() {
    for (int i = 1; i < width-1; ++i) {
      for (int j = 1; j < height-1; ++j) {
        if (onEdge[i][j]) {
          pixels[j * width + i ] = WHITE ;
        }
      }
    }
  }

  void drawVectors(float strokeWt, float scale, PGraphics pdf) {
    pdf.strokeWeight(strokeWt);
    for (EdgePath path: paths) {
      path.draw(scale, pdf);
    }
  }

  void buildVectors() {
    if (paths != null) { 
      return;
    }

    paths = new ArrayList<EdgePath>();
    boolean[][] onAPath = new boolean[width][height];
    int numberOfNodes = 0;
    for (int i = 1; i < width-1; ++i) {
      for (int j = 1; j < height-1; ++j) {
        if (onEdge[i][j] && ! onAPath[i][j]) {
          //create a path. Add this as first node
          onAPath[i][j] = true;
          EdgePath path = new EdgePath(i, j);
          path.populatePath( onEdge, onAPath);
          if (path.nodes.size() > 1) {
            paths.add(path);
            numberOfNodes += path.nodes.size();
          }
        }
      }
    }
    println("buildVectors() created " + paths.size() + " paths, using " + numberOfNodes + " nodes.");
  }

  void reduceVectors(float maxErrorFromLine) {
    //for each path, eliminate vectors without losing image quality
    int numberOfNodes = 0;
    for (EdgePath path: paths) {
      path.reducePath( maxErrorFromLine);
      numberOfNodes += path.nodes.size();
    }
    println("reduceVectors(): " + paths.size() + " paths, using " + numberOfNodes + " nodes.");
  }


  void findEdgePixels() {
    //skip 1 pixel border all the way around, simplifying 
    //implementation
    for (int i = 0; i < width; ++i) {
      for (int j = 0; j < height; ++j) {
        onEdge[i][j] = isOnEdge(i, j);
      }
    }
  }

  void removeNonEdgePixels() {
    for (int i = 1; i < width-1; ++i) {
      for (int j = 1; j < height-1; ++j) {
        if (!onEdge[i][j]) {
          pixels[j * width +i] = WHITE;
        }
      }
    }
  }

  void removeExtraNeighbors() {
    //If all of my neighbors are neighbors to each other,
    //I can be removed. This happens if the max distance
    //(horizontal or vertical) between neighbors is 1.
    for (int i = 1; i < width-1; ++i) {
      for (int j = 1; j < height-1; ++j) {
        if (onEdge[i][j] && neighborsAreConnected(i, j)) {
          onEdge[i][j] = false;
          pixels[j * width +i] = WHITE;
        }
      }
    }
  }

  boolean neighborsAreConnected(int x, int y) {
    int firstNeighborIndex = -1;
    int prevNeighborIndex = -1;
    int index = 0;
    //for each neighbor of (x,y), see if it reachable 
    // from all other neighbors without stepping on x,y.
    //First, gather up live neighbors
    ArrayList<NeighborPixel> liveNeighbors = new ArrayList<NeighborPixel>();
    for (NeighborPixel n : neighbors) {
      if(!isBackground(n.pixel(x, y))) {
        liveNeighbors.add(n);
      }
    }
    if(liveNeighbors.size() == 2) {
      //must be at most one row and on column apart
      NeighborPixel n0 = liveNeighbors.get(0);
      NeighborPixel n1 = liveNeighbors.get(1);
      return abs(n0.dx - n1.dx) < 2 && abs(n0.dy - n1.dy) < 2;
    }
    println("3+ neighbors at"+x+','+y);
    for (NeighborPixel n : neighbors) {
      //only check neighbors that are on the edge
      if (!isBackground(n.pixel(x, y))) {
        if (firstNeighborIndex == -1) {
          firstNeighborIndex = index;
        }   
        else {
          if (prevNeighborIndex % 2 == 0) {
            //previous is in side of 3x3
            if (index - prevNeighborIndex > 2) {
              //TODO
              //could be this pixel is closer to first pixel
              return false;
            }
          }
          else {
            //previous is in corner of 3x3
            if (index - prevNeighborIndex > 1) {
              return false;
            }
          }
        }
        prevNeighborIndex = index;
      }
      ++index;
    }
    return true;
  }

  boolean isOnEdge(int x, int y) {
    if (isBackground(pixels[y * width + x])) {
      return false;
    }
    int n = numBackgroundNeighbors(x, y);
    
    //if there are 7-8 background neighbors, this is a spur or speck, so ignore
    //if there are 0 background neighbors, it is an interior point, 
    return n > 0 && n < 8;
  }

  int numBackgroundNeighbors(int x, int y) {
    //find the pixel value of (up to) 8 neighboring pixels
    //start at 12 o'clock, go clockwise
    int numNeighbors = 0;
    for (NeighborPixel n : neighbors) {
      if (isBackground(n.pixel(x, y))) {
        numNeighbors++;
      }
    }
    return numNeighbors;
  }

  boolean isBackground(int clr) {
    //for now, if it isn't white, its a candidate for being on the edge
    //So this should work whether aliased or not
    return clr == WHITE;
  }
}

int colorCounter = 0;
int[] pathColors = new int[] {
  color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)
};

class EdgeNode {
  int x, y;

  EdgeNode(int x_, int y_) {    
    x = x_;
    y = y_;
  }
}

class EdgePath {
  ArrayList<EdgeNode> nodes = new  ArrayList<EdgeNode>();
  int pathColor;

  EdgePath(int x, int y) {
    nodes.add(new EdgeNode(x, y));
    colorCounter = (colorCounter+1)%3;
    pathColor = pathColors[colorCounter];
  }

  void draw(float scale, PGraphics pdf) {
    pdf.beginShape();
    for (EdgeNode node : nodes) {
      pdf.vertex(node.x * scale, node.y * scale);
    }
    EdgeNode firstNode = nodes.get(0);
//    pdf.vertex(firstNode.x * scale, firstNode.y* scale);
    pdf.endShape();
  }

  void populatePath(boolean[][] onEdge, boolean[][] onAPath) {
    EdgeNode nextNode = null;
    EdgeNode lastNode = null;
    stroke(pathColor);
    do {
      nextNode = findNextNode (onEdge, onAPath);
      if (nextNode != null) {
        pixels[nextNode.x +  nextNode.y * width] = pathColor;
        lastNode = nextNode;
      }
    }   
    while (null != nextNode);
    if (lastNode != null) {
      println("Last node=" + lastNode.x + ',' + lastNode.y);
    }
  }

  void reducePath(float maxErrorFromLine) {
    ArrayList<EdgeNode> nodesToRemoveFromPath = new ArrayList<EdgeNode>();
    int indexOfFirstNodeInShortcut = 0;
    int indexOfLastNodeInShortcut = indexOfFirstNodeInShortcut + 2;
    //follow the path, creating shortened segments by removing unneeded EdgeNodes 
    while (indexOfLastNodeInShortcut < nodes.size () ) {
      EdgeNode firstNodeInShortcut = nodes.get(indexOfFirstNodeInShortcut);
      EdgeNode lastNodeInShortcut = nodes.get(indexOfLastNodeInShortcut);
      Vec2D shortCut = new Vec2D(lastNodeInShortcut.x - firstNodeInShortcut.x, lastNodeInShortcut.y - firstNodeInShortcut.y);
      float error = 0;
      for (int i = indexOfFirstNodeInShortcut + 1; i < indexOfLastNodeInShortcut; ++i) {
        EdgeNode nodeToProject = nodes.get(i);
        Vec2D vecToProject = new Vec2D(nodeToProject.x - firstNodeInShortcut.x, nodeToProject.y - firstNodeInShortcut.y);
        error = max(error, vecToProject.distanceFromProjectionOnto(shortCut));
      }
      if (error > maxErrorFromLine || indexOfLastNodeInShortcut == nodes.size() - 1 ) {
        //went a step too far
        --indexOfLastNodeInShortcut;
        for (int i = indexOfFirstNodeInShortcut + 1; i < indexOfLastNodeInShortcut; ++i) {
          EdgeNode nodeToRemove = nodes.get(i);
          nodesToRemoveFromPath.add(nodeToRemove);
        }
        indexOfFirstNodeInShortcut = indexOfLastNodeInShortcut;
        indexOfLastNodeInShortcut = indexOfFirstNodeInShortcut + 2;
      } 
      else {
        ++indexOfLastNodeInShortcut;
      }
    }
    nodes.removeAll(nodesToRemoveFromPath);
  }

  EdgeNode findNextNode( boolean[][] onEdge, boolean[][] onAPath) {
    //returns null if there is no next node
    EdgeNode currentNode = nodes.get(nodes.size() - 1);
    int x = currentNode.x;
    int y = currentNode.y;

    //loop through neighbors, find nonwhite, unused pixel
    EdgeNode firstNode = nodes.get(0);
    for ( NeighborPixel n : neighbors) {
      if (!n.isBackground(x, y)) {
        int xNbr = x + n.dx;
        int yNbr = y + n.dy;
        if (onEdge[xNbr][yNbr] && !onAPath[xNbr][yNbr]) {
          EdgeNode newEdgeNode = new EdgeNode(xNbr, yNbr);
          onAPath[xNbr][yNbr] = true;
          nodes.add(newEdgeNode);
          if (xNbr == firstNode.x && yNbr == firstNode.y) {
            //we've looped, so report there is no next node
            return null;
          }
          return newEdgeNode;
        }
      }
    }
    //hmmm. 
    println("WHOA!!!");
    return null;
  }
}


class MousePoint {
  int x, y;

  MousePoint(int x_, int y_) {
    x = x_;
    y = y_;
  }
}

class MousePath {
  ArrayList<MousePoint> points = new ArrayList<MousePoint>();
  void addMousePoint(int x, int y) {
    points.add(new MousePoint(x, y));
  }

  MousePoint first() {
    return points.get(0);
  }

  int length() {
    return points.size();
  }
}

class NeighborPixel {
  int dx, dy;

  NeighborPixel(int dx_, int dy_) {
    dx = dx_; 
    dy= dy_;
  }

  int pixel(int x, int y) {
    //If on edge, assume area outside of picture is background color
    if (isOutOfPicture(x, y)) {
      return WHITE;
    }
    return pixels[(y + dy) * width + x + dx];
  }

  boolean isBackground(int x, int y) {
    return pixel(x, y) == WHITE;
  }

  boolean isOutOfPicture(int x, int y) {
    return x + dx < 1 || x + dx >= width ||y + dy < 1 || y + dy >= height;
  }
}

class Vec2D {
  float x, y;

  Vec2D(float x_, float y_) {
    x = x_;
    y=y_;
  }

  Vec2D minus(Vec2D v) {
    return new Vec2D(x - v.x, y - v.y);
  }

  Vec2D plus(Vec2D v) {
    return new Vec2D(x + v.x, y + v.y);
  }

  float length() {
    return dist(x, y, 0, 0);
  }

  float innerProduct(Vec2D other) {
    return x* other.x + y * other.y;
  }

  Vec2D scaleBy(float s) {
    return new Vec2D(x * s, y * s);
  }

  Vec2D projectOnto(Vec2D v) {
    float vLength = v.length();
    float lambda = innerProduct(v) / (vLength * vLength) ;
    return v.scaleBy(lambda);
  }

  float distanceFrom(Vec2D v) {
    Vec2D difference = minus(v);
    return difference.length();
  }

  float distanceFromProjectionOnto(Vec2D v) {
    Vec2D projection = projectOnto(v);
    return distanceFrom(projection);
  }

  String toString() {
    return "Vec2D("+x+','+y+')';
  }
}

void createEdgeOnlyPDF(String filename, float pixelWidth) {
  loadPixels();
  EdgeCalculator ec = new EdgeCalculator();
  ec.removeNonEdgePixels();
  ec.removeExtraNeighbors();
  ec.buildVectors();
  ec.reduceVectors(maxError);
  updatePixels();

  //Now you can scale down the size. 
  PGraphics pdf = createGraphics(1 +(int) pixelWidth, 1 + (int) (height * pixelWidth / width), PDF, "pdf/"+filename);
  pdf.beginDraw();

  float strokeWt = 0.02;
  float scale = pixelWidth / width;
  ec.drawVectors(strokeWt, scale, pdf);

  pdf.dispose();
  pdf.endDraw();
}

void initializeEdgeCalculator() {
  neighbors = new ArrayList<NeighborPixel>();
  neighbors.add(new NeighborPixel(0, -1));
  neighbors.add(new NeighborPixel(1, -1));
  neighbors.add(new NeighborPixel(1, 0));
  neighbors.add(new NeighborPixel(1, 1));
  neighbors.add(new NeighborPixel(0, 1));
  neighbors.add(new NeighborPixel(-1, 1));
  neighbors.add(new NeighborPixel(-1, 0));
  neighbors.add(new NeighborPixel(-1, -1));
}
