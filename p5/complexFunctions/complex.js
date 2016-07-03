var Complex = class Complex {
  constructor(a, b) {
    this.real = a;
    this.imag = b;
  }

  abs2() {
    return this.real * this.real + this.imag * this.imag;
  }

  theta() {
    //between 3 * pi/2 and -pi/2
    var theta;
    if (this.real == 0) {
      theta = this.imag > 0 ? PI / 2 : -PI / 2;
    } else {
      theta = atan(this.imag / this.real);
      if (this.real < 0) {
        theta += PI;
      }
    }
    return theta;
  }

  angleWrapped() {
    //continuously varies between pi/2 and -pi/2
    var angle = theta();
    if (angle > PI / 2) {
      angle = PI - angle;
    }
    return angle;
  }

  grayscaleByQuadrant() {
    if (this.real > 0) {
      return this.imag > 0 ? 255 : 0;
    }
    return this.imag > 0 ? 170 : 85;
  }

  blackWhite() {
    return this.real * this.imag > 0 ? 255 : 0;
  }

  grayscaleByAngle() {
    //map angle between - PI/2 to 3 * PI/2 to 0 to 255
    return (int) map(angleWrapped(), -PI / 2, PI / 2, 0, 255);
  }

  convertToColor() {
    //map angle between - PI/2 to 3 * PI/2 to 0 to 255
    float angle = theta();
    if (angle > PI / 2) {
      angle = PI - angle;
    }
    float maxColor = 255.9999;
    int r = (int) map(angleWrapped(), -PI / 2, PI / 2, 0, maxColor);
    int g = (int) map(sinh().sinh().angleWrapped(), -PI / 2, PI / 2, 0, maxColor);
    int b = (int) map(ONE.divideBy(this).angleWrapped(), -PI / 2, PI / 2, 0, maxColor);
    return color(r, g, b);
  }

  conjugate() {
    return new Complex(real, -imag);
  }

  divideBy(Complex z) {
    return times(z.conjugate()).scaleBy(1 / z.abs2());
  }

  raisedTo(int n) {
    if (n < 0) {
      return new Complex(1, 0).divideBy(raisedTo(-n));
    }
    if (n == 0) {
      return new Complex(1, 0);
    }
    if (n == 1) {
      return new Complex(real, imag);
    }
    return this.times(raisedTo(n - 1));
  }

  minus(Complex z) {
    return new Complex(real - z.real, imag - z.imag);
  }

  plus(Complex z) {
    return new Complex(real + z.real, imag + z.imag);
  }

  scaleBy(float s) {
    return new Complex(real * s, imag * s);
  }

  swirl() {
    return times(this).scaleBy(1 / sqrt(abs2()));
  }

  // _cosh(float x) {
  //   float e_x = exp(x);
  //   return (e_x + 1 / e_x) / 2;
  // }

  // _sinh(float x) {
  //   float e_x = exp(x);
  //   return (e_x - 1 / e_x) / 2;
  // }

  ln() {
    float angle = theta();
    if (angle < 0) {
      angle += 2 * PI;
    }
    return new Complex(log(abs2()) / 2, angle);
  }

  sine() {
    return new Complex(sin(real) * _cosh(imag), cos(real) * _sinh(imag));
  }

  cosine() {
    return new Complex(cos(real) * _cosh(imag), -sin(real) * _sinh(imag));
  }

  cosh() {
    return new Complex(_cosh(real) * cos(imag), _sinh(real) * sin(imag));
  }

  sinh() {
    return new Complex(_sinh(real) * cos(imag), _cosh(real) * sin(imag));
  }

  tanh() {
    return sinh().divideBy(cosh());
  }

  times(Complex z) {
    return new Complex(real * z.real - imag * z.imag, real * z.imag + imag * z.real);
  }
}