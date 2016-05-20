"""
ellipseFollowMouse

Draw an ellipse centered at the mouse cursor
"""


def setup():
    size(320, 240)


def draw():
    background(255)
    
    diameter = width * 0.2
    stroke(0)
    strokeWeight(width * 0.01)
    fill(200, 200, 0)
    ellipse(mouseX, mouseY, diameter, diameter);

