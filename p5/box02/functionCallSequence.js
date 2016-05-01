"use strict";

var FunctionCallSequence = class FunctionCallSequence {
  constructor(filename) {
    this.filename = filename;
    this.contents = new Array();
  }

  reset() {
    this.contents = new Array();
  }

  background(clr) {
    background(clr);
    this.pushFunctionCall("background", clr);
  }

  beginShape() {
    beginShape();
    this.pushFunctionCall("beginShape");
  }

  ellipse(x, y, dx, dy) {
    ellipse(x, y, dx, dy);
    this.pushFunctionCall("ellipse", x, y, dx, dy);
  }

  endShape(arg) {
    endShape();
    this.pushFunctionCall("endShape", arg);
  }

  fill(clr) {
    fill(clr);
    this.pushFunctionCall("fill", clr);
  }

  line(x0, y0, x1, y1) {
    line(x0, y0, x1, y1);
    this.pushFunctionCall("line", x0, y0, x1, y1);
  }

  noFill() {
    noFill();
    this.pushFunctionCall("noFill");
  }

  noStroke() {
    noStroke();
    this.pushFunctionCall("noStroke");
  }

  pop() {
    pop();
    this.pushFunctionCall("pop");
  }

  push() {
    push();
    this.pushFunctionCall("push");
  }

  rect(x, y, w, h) {
    rect(x, y, w, h);
    this.pushFunctionCall("rect", x, y, w, h);
  }

  rectMode(mode) {
    rectMode(mode);
    this.pushFunctionCall("rectMode", mode);
  }

  rotate(theta) {
    rotate(theta);
    this.pushFunctionCall("rotate", theta);
  }

  stroke(clr) {
    stroke(clr);
    this.pushFunctionCall("stroke", clr);
  }

  strokeWeight(w) {
    strokeWeight(w);
    this.pushFunctionCall("strokeWeight", w);
  }

  text(value, x, y) {
    text(value, x, y);
    this.pushFunctionCall("text", "" + value, x, y);
  }

  translate(x, y) {
    translate(x, y);
    this.pushFunctionCall("translate", x, y);
  }

  pushFunctionCall(funcName, arg1, arg2, arg3, arg4) {
    var functionCall = {};
    functionCall.functionName = funcName;
    if (arg1 != null) {
      functionCall.arg1 = arg1;
    }
    if (arg2 != null) {
      functionCall.arg2 = arg2
    }
    if (arg3 != null) {
      functionCall.arg3 = arg3;
    }
    if (arg4 != null) {
      functionCall.arg4 = arg4;
    }
    append(this.contents, functionCall);
  }

  vertex(x, y) {
    vertex(x, y);
    this.pushFunctionCall("vertex", x, y);
  }

  writeToFile() {
    //seems writing to file is broken, so we write to console
    for (var objIndex in this.contents) {
      if (objIndex > 0) {
        console.log(',');
      }
      var json = this.contents[objIndex];
      console.log(json);
    }
    this.reset();
  }

}