class Vec2D {
  float x, y;

  Vec2D(float x_, float y_) {
    x = x_;
    y=y_;
  }

  Vec2D minus(Vec2D v) {
    return new Vec2D(x - v.x, y - v.y);
  }

  Vec2D plus(Vec2D v) {
    return new Vec2D(x + v.x, y + v.y);
  }

  float length() {
    return dist(x, y, 0, 0);
  }

  float innerProduct(Vec2D other) {
    return x* other.x + y * other.y;
  }

  Vec2D scaleBy(float s) {
    return new Vec2D(x * s, y * s);
  }

  Vec2D projectOnto(Vec2D v) {
    float vLength = v.length();
    float lambda = innerProduct(v) / (vLength * vLength) ;
    return v.scaleBy(lambda);
  }

  float distanceFrom(Vec2D v) {
    Vec2D difference = minus(v);
    return difference.length();
  }

  float distanceFromProjectionOnto(Vec2D v) {
    Vec2D projection = projectOnto(v);
    return distanceFrom(projection);
  }

  String toString() {
    return "Vec2D("+x+','+y+')';
  }
}