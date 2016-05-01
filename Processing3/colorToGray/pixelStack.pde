int[] copyPixels(int[] pxls_) {
  int[] pxls = new int[pxls_.length];
  for (int pxlCtr = 0; pxlCtr < pixels.length; ++pxlCtr) {
    pxls[pxlCtr] = pxls_[pxlCtr];
  }
  return pxls;
}

class Pixels {
  int[] pxls;

  Pixels(int[] pxls_) {
    pxls = copyPixels(pxls_);
  }
}

class PixelStack {
  ArrayList<Pixels> pixelsStack = new ArrayList<Pixels>();

  int[] pop() {
    Pixels pixelsObject = pixelsStack.get(pixelsStack.size() - 1);
    pixelsStack.remove(pixelsObject);
    return pixelsObject.pxls;
  }

  int[] top() {
    Pixels pixelsObject = pixelsStack.get(pixelsStack.size() - 1);
    return pixelsObject.pxls;
  }

  int[] topCopy() {
    return copyPixels(top());
  }

  void push(int[] pxls_) {
    pixelsStack.add(new Pixels(pxls_));
  }

  int depth() {
    return pixelsStack.size();
  }
}