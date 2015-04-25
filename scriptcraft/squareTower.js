function squareTower(blocksPerSide, height, blockType) {
    up(1);
    //set default values if user did not provide parameters...
    if (typeof blocksPerSide == 'undefined') {
        blocksPerSide = 3;
    }
    if (typeof height == 'undefined') {
        height = 2;
    }
    if (typeof blockType == 'undefined') {
        blockType = blocks.gold;
    }
    //checkpoint the starting location
    this.chkpt('squareTower');
    for (var heightCtr = 0; heightCtr < height; heightCtr++) {
        for (var wallCounter = 0; wallCounter < 4; wallCounter++) {
            for (var blockCounter = 1; blockCounter < blocksPerSide; ++blockCounter) {
                this.box(blockType).fwd(1);
            }
            this.turn(1);
        }
        this.up(1);
    }
    //return to the starting checkpoint
    this.move('squareTower');
}

var Drone = require('drone');
Drone.extend(squareTower);