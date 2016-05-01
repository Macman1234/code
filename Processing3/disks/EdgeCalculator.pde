//GLOBALS
ArrayList<NeighborPixel> neighbors;
ArrayList<NeighborPixel> adjacentNeighbors;
int MIN_NODES_PER_PATH = 5;
float MAX_ERROR =  0.5;
int WIDTH_IN_INCHES =  6;

int WHITE = color(255);
int BLACK = color(0);
float PIXELS_PER_INCH = 72;

class EdgeCalculator {  //<>//
  PGraphics pg;
  ArrayList<EdgePath> paths;
  String inputText;

  EdgeCalculator() {
    pg = createGraphics(width, height);
    pg.beginDraw();
    loadPixels();
    pg.loadPixels();
    arrayCopy(pixels, pg.pixels);
    pg.updatePixels();
    pg.endDraw();

    //filterToBlackAndWhiteOnly();
    //trimSpurs();
    removeAllButEdgePixels();
    //buildVectors();
    //createEdgeOnlyPDF(INPUT_TEXT+'_'+FONT+".pdf", 72 * WIDTH_IN_INCHES );
  }

  void sendToDisplay() {
    pg.updatePixels();
    image(pg, 0, 0);
  }

  //void filterToBlackAndWhiteOnly() {
  //  pg.loadPixels();
  //  int i = 0;
  //  for (int pixel : pg.pixels) {
  //    float gray = (red(pixel) + green(pixel) + blue(pixel)) / 3;
  //    pg.pixels[i++] = gray > 0 ? WHITE : BLACK;
  //  }
  //  updatePGraphicsToDisplay();
  //}

  void createEdgeOnlyPDF(String filename, float pixelWidth_) {
    int drawingWidth = 1 +(int) pixelWidth_;
    int drawingHeight = 1 + (int) (pg.height * pixelWidth_ / pg.width);

    float scale = pixelWidth_ / pg.width;

    PGraphics pdf = createGraphics(drawingWidth, drawingHeight, PDF, "pdf/"+filename);
    pdf.beginDraw();
    pdf.strokeWeight(0.072);
    for (EdgePath path : paths) {
      path.drawOnPDF(scale, pdf);
    }
    pdf.dispose();
    pdf.endDraw();
  }

  //void draw() {
  //  for (EdgePath path : paths) {
  //    path.draw();
  //  }
  //}

  void buildVectors() {
    if (paths != null) { 
      return;
    }
    paths = new ArrayList<EdgePath>();
    boolean[][] onAPath = new boolean[pg.width][pg.height];
    int numberOfNodes = 0;
    for (int i = 1; i < pg.width-1; ++i) {
      for (int j = 1; j < pg.height-1; ++j) {
        if (isBlack(i, j) && ! onAPath[i][j]) {
          //onAPath[i][j] = true;
          EdgePath path = new EdgePath(pg, i, j, onAPath);
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
      int[] pixelCopy = new int[pg.pixels.length];
      arrayCopy(pg.pixels, pixelCopy);

      for (int i = 1; i < pg.width-1; ++i) {
        for (int j = 1; j < pg.height-1; ++j) {
          //If BLACK, then determine whether we should remove it
          if ( isBlack(i, j)) {
            //if it only has one white neighbor, and it is adjacent (not diagonal),
            //then it is part of border, and should remain
            boolean becomeWhite = true;
            int numOfWhiteNeighbors = numberOfWhiteNeighbors(i, j);
            if (numOfWhiteNeighbors > 0) {
              if (numOfWhiteNeighbors == 1) {
                for (NeighborPixel nbr : adjacentNeighbors) {
                  if (nbr.isWhite(pg, i, j)) {
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
                  ((adjacentNeighbors.get(0).isBlack(pg, i, j)
                  || adjacentNeighbors.get(2).isBlack(pg, i, j)) ) &&
                  ((adjacentNeighbors.get(1).isBlack(pg, i, j) 
                  || adjacentNeighbors.get(3).isBlack(pg, i, j)) );
                if (!isRedundantEdgePixel) {
                  //unless a pixel has at least two contiguous white neighbors, it should become white
                  boolean previousNeighborIsWhite = neighbors.get(7).isWhite(pg, i, j);
                  for (NeighborPixel nbr : neighbors) {
                    boolean nbrIsWhite = nbr.isWhite(pg, i, j);
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
              pixelCopy[j * pg.width +i] = WHITE;
              ++pixelsChanged;
            }
          }
        }
      }
      arrayCopy(pixelCopy, pg.pixels);
      pg.updatePixels();
    } while (pixelsChanged > 0);
  }

  boolean isBlack(int x, int y) {
    int pixelOffset = y * pg.width + x;
    if (pixelOffset >= pg.pixels.length) {
      println("ArrayIndexException in EdgeCalculator.isBlack("+x+','+y+"). Do you have the correct size() params?");
      System.exit(-1);
    }
    return pg.pixels[pixelOffset] == BLACK;
  }

  int numberOfWhiteNeighbors(int x, int y) {
    //find the pixel value of (up to) 8 neighboring pg.pixels
    //start at 12 o'clock, go clockwise
    int numNeighbors = 0;
    for (NeighborPixel n : neighbors) {
      if (n.pixel(pg, x, y) == WHITE) {
        numNeighbors++;
      }
    }
    return numNeighbors;
  }

  NeighborPixel soleBlackNeighbor(int x, int y) {
    if (numberOfWhiteNeighbors(x, y) == 7) {
      for (NeighborPixel n : neighbors) {
        if (n.pixel(pg, x, y) == BLACK) {
          return n;
        }
      }
    }
    return null;
  }
}