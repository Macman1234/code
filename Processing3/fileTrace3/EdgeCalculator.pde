class EdgeCalculator { 
  float MAX_ERROR = 1;
  PImage img;
  ArrayList<EdgePath> paths;

  EdgeCalculator(String inputFileName) {
    img = loadImage("input/"+inputFileName );

    filterToBlackAndWhiteOnly();
    trimSpurs();
    fatten(FATTEN_BY_PIXELS);
    filterToBlackAndWhiteOnly();//do it again because fatten aliases

    removeAllButEdgePixels();
    buildVectors();
    createEdgeOnlyPDF(INPUT_FILE_NAME+"_traced.pdf", 72 * WIDTH_IN_INCHES );
  }

  void filterToBlackAndWhiteOnly() {
    img.loadPixels();
    int i = 0;
    for (int pixel : img.pixels) {
      float gray = (red(pixel) + green(pixel) + blue(pixel)) / 3;
      img.pixels[i++] = gray > 240 ? WHITE : BLACK; //<>//
    }
    img.updatePixels();
  }

  void fatten(int depth) {
    if (depth == 0) {
      return;
    }
    println("fattening by " + depth + " pixels");
    fill(0);
    noStroke();
    int diameter = depth * 2;
    img.loadPixels();
    loadPixels();
    arrayCopy(img.pixels, pixels);
    updatePixels();
    //image(img, 0, 0);//display it so that we can draw
    for (int y = 1; y < height-1; ++y) {
      for (int x = 1; x < width-1; ++x) {
        if (isBlack(x, y) && numberOfWhiteNeighbors(x, y) > 0) {
          ellipse(x, y, diameter, diameter);
        }
      }
    }
    println("done fatten");
    loadPixels();
    arrayCopy(pixels, img.pixels);
    img.updatePixels();
  }

  void trimSpurs() {
    //There can be pixel paths that come out from the edge, but when only one pixel wide,
    //we want to ignore them. 
    //This method is optional, and if you want the spurs to be in the cut, 
    //you of course don't want to call trimSpurs
    int pixelsChanged = 0;
    do {
      pixelsChanged = 0;
      for (int x = 1; x < width-1; ++x) {
        for (int y = 1; y < height-1; ++y) {
          if (isBlack(x, y) && numberOfWhiteNeighbors(x, y) > 6) {
            int pixelOffset = y * width + x;
            img.pixels[pixelOffset] = WHITE;
            ++pixelsChanged;
            int xNbr = x;
            int yNbr = y;
            NeighborPixel blackNeighbor = null;
            while (null != (blackNeighbor = soleBlackNeighbor(xNbr, yNbr))) {
              xNbr += blackNeighbor.dx;
              yNbr += blackNeighbor.dy;
              pixelOffset = yNbr * width + xNbr;
              img.pixels[pixelOffset] = WHITE;
              ++pixelsChanged;
            }
          }
        }
      }
    } while ( pixelsChanged > 0);
  }

  void createEdgeOnlyPDF(String filename, float pixelWidth) {
    int drawingWidth = 1 +(int) pixelWidth;
    int drawingHeight = 1 + (int) (height * pixelWidth / width);

    float scale = pixelWidth / width;
    //String fattenedFileName = FATTEN_BY_PIXELS == 0 ? filename : filename + "_"+FATTEN_BY_PIXELS;
    println("Creating pdf "+ filename);
    PGraphics pdf = createGraphics(drawingWidth, drawingHeight, PDF, "pdf/"+filename);
    pdf.beginDraw();
    //pdf.background(255, 255, 255, 0);
    noFill();
    pdf.strokeWeight(0.072);
    for (EdgePath path : paths) {
      path.drawOnPDF(scale, pdf);
    }
    pdf.dispose();
    pdf.endDraw();
    println("pdf written");
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
        if (isBlack(i, j) && ! onAPath[i][j]) {
          onAPath[i][j] = true;
          EdgePath path = new EdgePath(img.pixels, i, j);
          path.populatePath(onAPath);
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

  void removeAllButEdgePixels() {
    int pixelsChanged;
    do {
      pixelsChanged = 0;
      int[] pixelCopy = new int[img.pixels.length];
      arrayCopy(img.pixels, pixelCopy);

      for (int i = 1; i < width-1; ++i) {
        for (int j = 1; j < height-1; ++j) {
          //If BLACK, then determine whether we should remove it
          if ( isBlack(i, j)) {
            //if it only has one white neighbor, and it is adjacent (not diagonal),
            //then it is part of border, and should remain
            boolean becomeWhite = true;
            int numOfWhiteNeighbors = numberOfWhiteNeighbors(i, j);
            if (numOfWhiteNeighbors > 0) {
              if (numOfWhiteNeighbors == 1) {
                for (NeighborPixel nbr : adjacentNeighbors) {
                  if (nbr.isWhite(img.pixels, i, j)) {
                    becomeWhite = false;
                    break;
                  }
                }
              } else {
                //there are white neighbors, but not exactly one.

                //Typical case of an edge: there will be two black neighbors.
                //But if they are adjacent to this pixel (not diagonal), and not across
                //from each other, then this pixel can be removed.
                //This means the pixel should be white if there is a black pixel up or down, 
                //and a black pixel right or left.
                boolean isRedundantEdgePixel = (numOfWhiteNeighbors == 6) && 
                  ((adjacentNeighbors.get(0).isBlack(img.pixels, i, j) 
                  || adjacentNeighbors.get(2).isBlack(img.pixels, i, j)) ) &&
                  ((adjacentNeighbors.get(1).isBlack(img.pixels, i, j) 
                  || adjacentNeighbors.get(3).isBlack(img.pixels, i, j)) );
                if (!isRedundantEdgePixel) {
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
              }
            }
            if (becomeWhite) {
              pixelCopy[j * width +i] = WHITE;
              ++pixelsChanged;
            }
          }
        }
      }
      arrayCopy(pixelCopy, img.pixels);
      img.updatePixels();
    } while (pixelsChanged > 0);
  }

  boolean isBlack(int x, int y) {
    int pixelOffset = y * width + x;
    if (pixelOffset >= img.pixels.length) {
      println("ArrayIndexException in EdgeCalculator.isBlack(). Do you have the correct size() params?");
      System.exit(-1);
    }
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

  NeighborPixel soleBlackNeighbor(int x, int y) {
    if (numberOfWhiteNeighbors(x, y) == 7) {
      for (NeighborPixel n : neighbors) {
        if (n.pixel(img.pixels, x, y) == BLACK) {
          return n;
        }
      }
    }
    return null;
  }
}