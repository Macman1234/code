function cylindricalTower(radius, height, blockType) {
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
    this.chkpt('cylindricalTower');
    var deltaAngle = 1.0 / radius; //large radius requires smaller angle deltas
    for (var heightCtr = 0; heightCtr < height; heightCtr++) {
        var angle = 0;
        while (angle < 2 * Math.PI) {
            var x = radius * Math.cos(angle);
            var y = radius * Math.sin(angle);

            this.up(heightCtr)
                .right(Math.round(x))
                .fwd(Math.round(y))
                .box(blockType)
                .move('cylindricalTower');
            angle += deltaAngle;
        }
    }

    //return to the starting checkpoint
    this.move('cylindricalTower');
}

var Drone = require('drone');
Drone.extend(cylindricalTower);