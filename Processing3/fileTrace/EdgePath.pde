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
    pdf.endShape();
  }

  void populatePath(int[] pxls, boolean[][] onEdge, boolean[][] onAPath) {
    EdgeNode nextNode = null;
    EdgeNode lastNode = null;
    stroke(pathColor);
    do {
      nextNode = findNextNode (pxls, onEdge, onAPath);
      if (nextNode != null) {
        pxls[nextNode.x +  nextNode.y * width] = pathColor;
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
      } else {
        ++indexOfLastNodeInShortcut;
      }
    }
    nodes.removeAll(nodesToRemoveFromPath);
  }

  EdgeNode findNextNode(int[] pxls, boolean[][] onEdge, boolean[][] onAPath) {
    //returns null if there is no next node
    EdgeNode currentNode = nodes.get(nodes.size() - 1);
    int x = currentNode.x;
    int y = currentNode.y;

    //loop through neighbors, find nonwhite, unused pixel
    EdgeNode firstNode = nodes.get(0);
    for ( NeighborPixel n : neighbors) {
      if (!n.isBackground(pxls, x, y)) {
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