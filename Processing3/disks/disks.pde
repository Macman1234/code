ArrayList<Disk> disks = new ArrayList<Disk>();
int numberDisksToAddAtOnce = 10;
boolean showOutline = false;
boolean disksAreBlack = false;
boolean handleChange = true;

void setup() {
  size(500, 800);
  initializeNeighborPixelArray();
}

void keyPressed() {
  if (key == '+') {
    for (int i = 0; i < numberDisksToAddAtOnce; ++i) {
      float radius = width * 0.03;// + random(width * 0.05);
      disks.add(new Disk(random(width), random(height), radius));
    }
    handleChange = true;
  } else if (key == '-') {
    if (disks.size() > 0) {
      for (int i = 0; i < numberDisksToAddAtOnce; ++i) {
        disks.remove(disks.size() - 1);
      }
    }
    handleChange = true;
  } else if (key == 'o') {
    showOutline = !showOutline;
    handleChange = true;
  } else if (key == 't') {
    disksAreBlack = !disksAreBlack;
    handleChange = true;
  }
}

void draw() {
  if (!handleChange) {
    return;
  }
  background(0);
  for (Disk disk : disks) {
    disk.draw();
  }
  if (showOutline) {
    EdgeCalculator edge = new EdgeCalculator();
    edge.sendToDisplay();
  }
  handleChange = false;
}