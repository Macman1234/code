import processing.pdf.*;

String inputFile = "pentagons2.js";
String outputFile = "pentagons2Output.pdf";

void setup() {
  size(800, 800, PDF, outputFile);

  JSONArray jsonArray = loadJSONArray(inputFile);
  for (int i = 0; i < jsonArray.size(); i++) {
    JSONObject command = jsonArray.getJSONObject(i); 
    handleCommand(command);
  }
}

void handleCommand(JSONObject command) {
  String functionName = command.getString("functionName");
  if (functionName.equals("background")) {
    int clr = command.getInt("arg1");
    background(clr);
  } else if (functionName.equals("beginShape")) { 
    beginShape();
  } else if (functionName.equals("endShape")) { 
    endShape();
  } else if (functionName.equals("ellipse")) {
    float arg1 = command.getFloat("arg1");
    float arg2 = command.getFloat("arg2");
    float arg3 = command.getFloat("arg3");
    float arg4 = command.getFloat("arg4");
    ellipse(arg1, arg2, arg3, arg4);
  } else if (functionName.equals("fill")) {
    int arg1 = command.getInt("arg1");
    fill(arg1);
  } else if (functionName.equals("line")) {
    float arg1 = command.getFloat("arg1");
    float arg2 = command.getFloat("arg2");
    float arg3 = command.getFloat("arg3");
    float arg4 = command.getFloat("arg4");
    line(arg1, arg2, arg3, arg4);
  } else if (functionName.equals("noFill")) {    
    noFill();
  } else if (functionName.equals("noStroke")) {    
    noStroke();
  } else if (functionName.equals("pop")) {    
    popMatrix();
  } else if (functionName.equals("push")) {    
    pushMatrix();
  } else if (functionName.equals("rect")) {
    float arg1 = command.getFloat("arg1");
    float arg2 = command.getFloat("arg2");
    float arg3 = command.getFloat("arg3");
    float arg4 = command.getFloat("arg4");
    rect(arg1, arg2, arg3, arg4);
  } else if (functionName.equals("rectMode")) {
    String arg1 = command.getString("arg1").toUpperCase();
    if (arg1.equals("CENTER")) {
      rectMode(CENTER);
    } else {
      println("Unrecognized rectMode: "+arg1);
    }
  } else if (functionName.equals("rotate")) {
    float arg1 = command.getFloat("arg1");
    rotate(arg1);
  } else if (functionName.equals("stroke")) {
    int arg1 = command.getInt("arg1");
    stroke(arg1);
  } else if (functionName.equals("strokeJoin")) {
    String arg1 = command.getString("arg1").toUpperCase();
    if (arg1.equals("MITER")) {
      strokeJoin(MITER);
    } else if (arg1.equals("ROUND")) {
      strokeJoin(ROUND);
    } else {
      println("Unrecognized strokeJoin: "+arg1);
    }
  } else if (functionName.equals("strokeWeight")) {
    float arg1 = command.getFloat("arg1");
    println("strokeWeight="+arg1);
    strokeWeight(arg1);
  } else if (functionName.equals("text")) {
    String arg1 = command.getString("arg1");
    float arg2 = command.getFloat("arg2");
    float arg3 = command.getFloat("arg3");
    text(arg1, arg2, arg3);
  } else if (functionName.equals("translate")) {
    float arg1 = command.getFloat("arg1");
    float arg2 = command.getFloat("arg2");
    translate(arg1, arg2);
  } else if (functionName.equals("vertex")) {
    float arg1 = command.getFloat("arg1");
    float arg2 = command.getFloat("arg2");
    vertex(arg1, arg2);
  } else {
    println("Unrecognized command: "+ functionName);
  }
}