// "use strict";

var MAX_CLUSTER_DIAMETER = 6;

function setup() {
  createCanvas(100, 100);
}

function intersectionPoints() {
  var allPointClusters = [];
  loadPixels();
  var d = pixelDensity();
  var openPointClusters = [];
  for (var y = 0; y < height ; ++y) {

    for (var x = 0; x < width ; ++x) {
      //check the red value: should be 255 for white, 127 for grey, <127 for intersection
      var pixelOffset = 4 * (y * width * d + x) * d;
      var pixel = pixels[pixelOffset];
      if (pixel < 127) {
        setRGBA(x, y, 255, 0, 0, 255);
        // found an intersection pixel, add it to an adjacent cluster from row above..
        // println("(x,y) = " + x + ',' + y + ')');
        var foundCluster = false;
        for (var clusterCtr = 0; clusterCtr < openPointClusters.length; ++clusterCtr) {
          var cluster = openPointClusters[clusterCtr];
          var distToCluster = cluster.distanceTo(x, y);
          if (distToCluster < MAX_CLUSTER_DIAMETER) {
            foundCluster = true;
            cluster.add(x, y);
            // if (cluster.x_ == 98) {
            //   println(x + ',' + y);
            // }
            break;
          }
        }
        if (!foundCluster) {
          //nothing found...create a new PointCluster
          var newCluster = new PointCluster(x, y);
          openPointClusters.push(newCluster);
          allPointClusters.push(newCluster);
        }
        // println(existingPointCluster);
        // pointClustersInThisRow[x] = existingPointCluster;
      }
    }
    //only keep clusters from above that are sufficiently close
    var newOpenPointClusters = [];
    for (clusterCtr = 0; clusterCtr < openPointClusters.length; ++clusterCtr) {
      cluster = openPointClusters[clusterCtr];
      if (y - cluster.y() <= MAX_CLUSTER_DIAMETER) {
        newOpenPointClusters.push(cluster);
      }
    }
    openPointClusters = newOpenPointClusters;
  }
  updatePixels();
  return allPointClusters;
}

function setRGBA(x, y, r, g, b, a) {
  var d = pixelDensity();
  for (var i = 0; i < d; i++) {
    for (var j = 0; j < d; j++) {
      // loop over
      var idx = 4 * ((y * d + j) * width * d + (x * d + i));
      pixels[idx] = r;
      pixels[idx + 1] = g;
      pixels[idx + 2] = b;
      pixels[idx + 3] = a;
    }
  }
}


function draw() {
  background(255);

  noSmooth(); //must use exactly one color for drawing, so no aliasing 
  noFill();
  stroke(127);
  strokeWeight(3);
  blendMode(MULTIPLY); //intersections will be darker

  // ellipse(width / 3, height / 3, width / 2, height / 2);
  ellipse(width / 2, height / 2, width / 2, height / 2);
  ellipse(width / 3, height / 3, width / 2, height / 2);
  ellipse(width / 4, height / 4, width / 2, height / 2);
  ellipse(3 * width / 4, 3 * height / 4, width / 2, height / 2);

  var pts = intersectionPoints();
  if (frameCount == 1) {
    println(pts);
  }
  // var msg = mouseX * 2 + ',' + mouseY * 2;
  // noStroke();
  // // fill(255, 0, 0);
  // // rect(width / 2, height / 2 - 20, textWidth(msg), 20);
  // fill(0);
  // text(msg, width / 2, height / 2);
}