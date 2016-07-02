class Complex {
  float real, imag;

  Complex(float a, float b) {
    real = a;
    imag = b;
  }

  float abs2() {
    return real * real + imag * imag;
  }

  float theta() {
    //between 3 * pi/2 and -pi/2
    float theta;
    if (real == 0) {
      theta = imag > 0 ? PI /2 : - PI/2;
    } 
    else {
      theta = atan(imag / real);
      if (real < 0) {
        theta += PI;
      }
    }
    return theta;
  }

  float angleWrapped() {
    //continuously varies between pi/2 and -pi/2
    float angle = theta();
    if (angle > PI /2) {
      angle =  PI - angle;
    }
    return angle;
  }

  int grayscaleByQuadrant() {
    if (real > 0) {
      return imag > 0 ? 255 : 0;
    }
    return imag > 0 ? 170 : 85;
  }

  int blackWhite() {
    return real * imag > 0 ? 255 : 0;
  }

  int grayscaleByAngle() {
    //map angle between - PI/2 to 3 * PI/2 to 0 to 255
    return (int) map(angleWrapped(), -PI /2, PI/2, 0, 255);
  }

  color convertToColor() {
    //map angle between - PI/2 to 3 * PI/2 to 0 to 255
    float angle = theta();
    if (angle > PI /2) {
      angle =  PI - angle;
    }
    float maxColor = 255.9999;
    int r = (int) map(angleWrapped(), - PI/2, PI / 2, 0, maxColor);
    int g = (int) map(sinh().sinh().angleWrapped(), - PI/2, PI / 2, 0, maxColor);
    int b = (int) map(ONE.divideBy(this).angleWrapped(), - PI/2, PI / 2, 0, maxColor);
    return color(r, g, b);
  }

  Complex conjugate() {
    return new Complex(real, -imag );
  }

  Complex divideBy(Complex z) {
    return times(z.conjugate()).scaleBy(1 / z.abs2());
  }

  Complex raisedTo(int n) {
    if (n < 0) { 
      return new Complex(1, 0).divideBy(raisedTo(-n));
    }
    if (n == 0) {
      return new Complex(1, 0);
    }
    if (n ==1 ) { 
      return new Complex(real, imag);
    }
    return this.times(raisedTo(n - 1));
  }

  Complex minus(Complex z) {
    return new Complex(real - z.real, imag - z.imag);
  }

  Complex plus(Complex z) {
    return new Complex(real + z.real, imag + z.imag);
  }

  Complex scaleBy(float s) {
    return new Complex(real * s, imag * s);
  }

  Complex swirl() {
    return times(this ).scaleBy(1/sqrt(abs2()) );
  }

  float _cosh(float x) {
    float e_x = exp(x);
    return (e_x + 1/e_x) / 2;
  }

  float _sinh(float x) {
    float e_x = exp(x);
    return (e_x - 1/e_x) / 2;
  }

  Complex ln() {
    float angle = theta();
    if (angle < 0) {
      angle += 2 * PI;
    }
    return new Complex(log(abs2())/2, angle);
  }

  Complex sine() {
    return new Complex(sin(real) * _cosh(imag), cos(real) * _sinh(imag));
  }

  Complex cosine() {
    return new Complex(cos(real) * _cosh(imag), - sin(real) * _sinh(imag));
  }

  Complex cosh() {
    return new Complex(_cosh(real) * cos(imag), _sinh(real) * sin(imag));
  }

  Complex sinh() {
    return new Complex(_sinh(real) * cos(imag), _cosh(real) * sin(imag));
  }

  Complex tanh() {
    return sinh().divideBy(cosh());
  }

  Complex times(Complex z) {
    return new Complex(real * z.real - imag * z.imag, real * z.imag + imag * z.real);
  }
}
