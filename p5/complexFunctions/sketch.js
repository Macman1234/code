var needsRedraw = true;

var range = Math.PI;
var verticalScale = 1;


function setup() {
 createCanvas(512, 512);
   
}

function draw() {
    if (!needsRedraw) {
    return;
  }
  needsRedraw = false;
  clear();
  
  var xMin = -range;
  var xMax = range;
  var yMin = -range * verticalScale;
  var yMax = range * verticalScale;

 for (var i = 0; i < width; ++i) {
    //if (i %10 == 0) {
    //  println("line "+i +" of "+width);
    //}
    var x = xMin + i * (xMax - xMin) / width;
    for (var j = 0; j < height; ++j) {
      var y = yMax - j * (yMax - yMin) / height;
      var z =  new Complex(x, y);
      //      stroke(f(z).grayscaleByAngle());
      //   stroke(f(z.swirl().swirl()).convertToColor());//#17
      stroke(f(z).convertToColor());
      //stroke(f(z).blackWhite());
      point(i, j);
    }
  }

  save("complexFunctions.jpg");

}

function f(z) {
  // Up to image 8, used grayscaleByAngle2, which had a bug

  //return z.sinh().cosh();
    //return z.times(I).sine();
  // return z.times(I).sine().minus(z.sine());
  // return z.times(I).sin().minus(ONE.divideBy(z.sin()));
  // return z.times(I).sinh().minus(ONE.divideBy(z.sinh()));
  // return z.sinh().divideBy(z.sine());
  //return z.sinh().divideBy(z.sine().plus(z)).sinh();//_7
  //  return z.sinh().cosh();//_8
  //  return z;
  //return z.sinh().divideBy(z.sine().plus(z)).sinh();//_9
  //return z.sinh().cosh().sinh();//_10
  //return z.sinh().cosh().sinh().cosh();//_11
  //return z.sinh().cosh().sinh().cosh().sinh();//_11
  //return z.sinh().sinh().sinh().sinh().sinh();//_12
  //  Complex z_ = z.sinh();
  //  for (int i = 0; i < 10; ++i) {
  //    z_ = z_.sinh();
  //  }
  //  return z_;//_13

  //  return ONE.divideBy(z );

    //return z.raisedTo(3).minus(z).plus(z.times(z).scaleBy(1));
    //return new Complex(5, 0).divideBy(z).plus(z);
    return new Complex(0, 2).divideBy(z).plus(z);
  //  return new Complex(2, 2).divideBy(z).plus(z);
  //    return z.sine().plus(new Complex(2, 2).divideBy(z).plus(z));
  //    return new Complex(1,0).divideBy(z).plus(z).sine();
  //  return new Complex(-1, 2).divideBy(z).plus(z.times(new Complex(1, 1))).plus(z.times(z)).sine();
}