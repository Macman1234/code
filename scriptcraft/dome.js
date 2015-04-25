function dome(radius, blockType) {
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
    this.chkpt('dome');
    var deltaAngle = 1.0 / radius; //large radius requires smaller angle deltas
    var elevationAngle = 0;
    while (elevationAngle < 2 * Math.PI) {
        var angle = 0;
        while (angle < 2 * Math.PI) {
            var heightAdjustedRadius = radius * Math.cos(elevationAngle);
            var x = Math.cos(angle) * heightAdjustedRadius;
            var y = Math.sin(angle) * heightAdjustedRadius;

            this.up(Math.round(radius * Math.sin(elevationAngle)))
                .right(Math.round(x))
                .fwd(Math.round(y))
                .box(blockType)
                .move('dome');
            angle += deltaAngle;
        }
        elevationAngle += deltaAngle;
    }

    //return to the starting checkpoint
    this.move('dome');
}

var Drone = require('drone');
Drone.extend(dome);