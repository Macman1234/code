class EdgeCalculator { 
  float MAX_ERROR =  1;
  PImage img;
  ArrayList<EdgePath> paths;
  //boolean[][] onEdge;

  EdgeCalculator(String inputFileName) {
    img = loadImage("input/"+inputFileName );

    filterToBlackAndWhiteOnly();

    removeAllButEdgePixels();

    buildVectors();
  }

  void filterToBlackAndWhiteOnly() {
    img.loadPixels();
    int i = 0;
    for (int pixel : img.pixels) {
      float gray = (red(pixel) + green(pixel) + blue(pixel)) / 3;
      img.pixels[i++] = gray > 127 ? WHITE : BLACK;
    }
    img.updatePixels();
  }

  void createEdgeOnlyPDF(String filename, float pixelWidth) {
    int drawingWidth = 1 +(int) pixelWidth;
    int drawingHeight = 1 + (int) (height * pixelWidth / width);

    float strokeWt = 0.072;
    float scale = pixelWidth / width;

    PGraphics pdf = createGraphics(drawingWidth, drawingHeight, PDF, "pdf/"+filename);
    pdf.beginDraw();

    drawVectors(strokeWt, scale, pdf);

    pdf.dispose();
    pdf.endDraw();
  }

  void drawVectors(float strokeWt, float scale, PGraphics pdf) {
    pdf.strokeWeight(strokeWt);
    for (EdgePath path : paths) {
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
        if (isOnEdge(i, j) && ! onAPath[i][j]) {
          onAPath[i][j] = true;
          EdgePath path = new EdgePath(i, j);
          path.populatePath(img.pixels, onAPath);
          if (path.nodes.size() > MIN_NODES_PER_PATH) {
            paths.add(path);
            numberOfNodes += path.nodes.size();
          }
        }
      }
    }
    print("buildVectors(): " + paths.size() + " paths, created " + numberOfNodes + " nodes");

    //for each path, eliminate vectors without losing image quality
    numberOfNodes = 0;
    for (EdgePath path : paths) {
      path.reducePath( MAX_ERROR);
      numberOfNodes += path.nodes.size();
    }
    println(", trimmed to " + numberOfNodes + " nodes.");
  }

  //void removeInteriorPixels() {
  //  int[] pixelCopy = new int[img.pixels.length];
  //  arrayCopy(img.pixels, pixelCopy);
  //  for (int i = 1; i < width-1; ++i) {
  //    for (int j = 1; j < height-1; ++j) {
  //      if (numBackgroundNeighbors(i, j) == 0) 
  //        pixelCopy[j * width +i] = WHITE;
  //    }
  //  }
  //  arrayCopy(pixelCopy, img.pixels);
  //  img.updatePixels();
  //}

  void removeAllButEdgePixels() {
    int[] pixelCopy = new int[img.pixels.length];
    arrayCopy(img.pixels, pixelCopy);

    for (int i = 1; i < width-1; ++i) {
      for (int j = 1; j < height-1; ++j) {
        //If BLACK, then determine whether we should remove it
        if ( img.pixels[j * width +i]==BLACK) {
          //if it only has one white neighbor, and it is adjacent (not diagonal),
          //then it is part of border, and should remain
          boolean becomeWhite = true;
          if (numberOfWhiteNeighbors(i, j) < 2) {
            for (NeighborPixel nbr : adjacentNeighbors) {
              if (nbr.isWhite(img.pixels, i, j)) {
                becomeWhite = false;
              }
            }
          } else {
            //unless a pixel has at least two contiguous white neighbors, it should become white
            boolean previousNeighborIsWhite = neighbors.get(7).isWhite(img.pixels, i, j);
            for (NeighborPixel nbr : neighbors) {
              boolean nbrIsWhite = nbr.isWhite(img.pixels, i, j);
              if (previousNeighborIsWhite && nbrIsWhite)
              {
                becomeWhite = false;
              }
              previousNeighborIsWhite = nbrIsWhite;
            }
          }
          if (becomeWhite) {
            pixelCopy[j * width +i] = WHITE;
          }
        }
      }
    }
    arrayCopy(pixelCopy, img.pixels);
    img.updatePixels();
  }

  boolean isOnEdge(int x, int y) {
    int pixelOffset = y * width + x;
    return img.pixels[pixelOffset] == BLACK;
  }

  int numberOfWhiteNeighbors(int x, int y) {
    //find the pixel value of (up to) 8 neighboring img.pixels
    //start at 12 o'clock, go clockwise
    int numNeighbors = 0;
    for (NeighborPixel n : neighbors) {
      if (n.pixel(img.pixels, x, y) == WHITE) {
        numNeighbors++;
      }
    }
    return numNeighbors;
  }

  //boolean isWhiteColor(int clr) {
  //  return clr == WHITE;
  //}
}