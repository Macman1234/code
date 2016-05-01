int colorCounter = 0;
int[] pathColors = new int[] {
  color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), 
  color(255, 255, 0), color(255, 0, 255), color(0, 255, 255)
};

class EdgeNode {
  int x, y;

  EdgeNode(int x_, int y_) {    
    x = x_;
    y = y_;
  }
}

class EdgePath {
  PGraphics pg;
  ArrayList<EdgeNode> nodes = new  ArrayList<EdgeNode>();
  int pathColor;

  EdgePath(PGraphics pg_, int x, int y, boolean[][] onAPath) {
    colorCounter = (colorCounter+1)%pathColors.length;
    pathColor = pathColors[colorCounter];//color(random(255), random(255), random(255));
    pg = pg_;
    pg.pixels[x +  y * pg.width] = pathColor;

    //populatePath
    nodes.add(new EdgeNode(x, y));
    onAPath[x][y] = true;
    while ( findNextNode (onAPath) != null);
  }

  void drawOnPDF(float scale, PGraphics pdf) {
    pdf.beginShape();
    pdf.noFill();
    for (EdgeNode node : nodes) {
      pdf.vertex(node.x * scale, node.y * scale);
    }
    pdf.endShape();
  }

  EdgeNode findNextNode(boolean[][] onAPath) {
    //returns null if there is no next node
    EdgeNode currentNode = nodes.get(nodes.size() - 1);
    int x = currentNode.x;
    int y = currentNode.y;

    //loop through neighbors, find nonwhite, unused pixel
    EdgeNode firstNode = nodes.get(0);
    for ( NeighborPixel n : neighbors) {
      if (n.isBlack(pg, x, y)) {
        int xNbr = x + n.dx;
        int yNbr = y + n.dy;
        if (xNbr == firstNode.x && yNbr == firstNode.y) {
          //we've looped back to the firstNode
          nodes.add(firstNode);
          return null;
        }
        if (!onAPath[xNbr][yNbr]) {
          onAPath[xNbr][yNbr] = true;
          pg.pixels[xNbr +  yNbr * pg.width] = pathColor;
          EdgeNode nextNode = new EdgeNode(xNbr, yNbr);
          nodes.add(nextNode);
          return nextNode;
        }
      }
    }
    return null;
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
      } else {
        ++indexOfLastNodeInShortcut;
      }
    }
    nodes.removeAll(nodesToRemoveFromPath);
  }
}