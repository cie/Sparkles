/*
Sometimes you don't need a complex framework for your Processing sketch.
Just some stuff you can draw click and drag.

This code is hosted on https://gist.github.com/cie/7982429 .

1. Copy-paste this code to a new tab in your sketch, and create subclasses of Stuff.
2. Add this code to your sketch: 

class MainStuff extends Stuff {
  void setup() {
  }
  
  void draw() {
  }
}

3. Create other Stuff subclasses and add them to the MainStuff in its setup() method:

class Button extends Stuff {}

add(new Button());

4. In your Stuff subclasses, you can use setup(), draw(), mouse{Pressed,Released,Moved,Clicked}(),
   mouseOver, mouseX, mouseY, pmouseX, pmouseY as you would expect. mouseEntered() and mouseLeft() are
   called when the mouse enters or leaves the stuff. add() and remove() can be used to manage children.
   children and parent stores children and parent. You can override children() if you want to restrict
   the type of child stuffs.
5. You can set x,y,w,h,angle,scale in your stuff. x and y are in the parent's coordinate system.
   You can override hit(). Set mode to CENTER to have (0,0) in the center, or CORNER (default) to have
   it in the upper right corner. You don't have to use x and y in draw().
6. If in a mousePressed() you set draggedStuff=this, then that stuff will receive mouseDragged() events.
   It will be automatically unset at a mouseReleased() event.
*/

class Stuff {
  float x, y, w, h, angle, scale = 1;
  int mode = CORNER;
  boolean mouseOver;
  boolean setUp;
  void setup() { }
  
  void draw() { }
  
  void drawAll() { 
    pushMatrix(); 
    pushStyle();
    if (x!=0 || y!=0) { translate(x,y); } 
    if (angle != 0) {rotate(angle); } 
    if (scale != 1) {scale(scale);} 
    draw(); 
    for(Stuff c : children()) { c.drawAll(); } 
    popMatrix(); popStyle();
  }
  
  float mouseX, mouseY, pmouseX, pmouseY;
  
  void mousePressed() { }
  void mouseClicked() { }
  void mouseDragged() { }
  void mouseReleased() { }
  void mouseMoved() {}
  void mouseEntered() {}
  void mouseLeft() {}
  
  void setMouse(float ax, float ay) {
    pmouseX = mouseX; pmouseY = mouseY;
    mouseX = (ax-x)/scale; mouseY = (ay-y)/scale;
    
    for (Stuff c : children()) {
      c.setMouse(mouseX,mouseY);
    }
  }
  
  
  boolean mouseEvent(int event) {
    ArrayList<? extends Stuff> ch = children();
    for(int i = ch.size()-1; i>=0; --i) {
      Stuff c = ch.get(i);
      if (c.mouseEvent(event)) {
        if (event == MOVE) { if (mouseOver) {  mouseOver = false; mouseLeft();} }
        return true;
      }
    }
 
    if (hit(mouseX, mouseY)) {
      switch(event) {
        case 120: 
          mousePressed();
          draggedStuff = this;
          break;
        case 121:
          mouseReleased();
          break;
        case 122:
          mouseClicked();
          break;
        case 123:
          if (!mouseOver) { mouseOver = true; mouseEntered(); } 
          mouseMoved();
          break;
      }
      return true;
    } else {
      if (mouseOver) { mouseOver = false; mouseLeft(); } 
      return false;
    }
  }
  
  
  
  Stuff parent;
  ArrayList<Stuff> children = new ArrayList<Stuff>();
  void add(Stuff c) { children.add(c); c.parent = this; if (!c.setUp) { c.setup(); c.setUp = true; } }
  void remove() { parent.children.remove(this); parent = null; }
  
  boolean hit(float ax, float ay) {
    return mode == CENTER 
      ? abs(ax)<w/2 && abs(ay)<h/2 
      : 0<ax && ax<w && 0<ay && ay<h;
  }
  ArrayList<Stuff> children() { return children; };
}
static int PRESS = 120, RELEASE = 121, CLICK = 122, MOVE=123;

MainStuff mainStuff;
Stuff draggedStuff;

void draw() {
  mainStuff.drawAll();
}

void mouseClicked() {
  mainStuff.mouseEvent(CLICK);
}

void mouseMoved() {
  mainStuff.setMouse(mouseX, mouseY);  
  mainStuff.mouseEvent(MOVE);
}

void mousePressed() {
  mainStuff.mouseEvent(PRESS);
}

void mouseDragged() {
  mainStuff.setMouse(mouseX, mouseY);
  mainStuff.mouseEvent(MOVE);
  if (draggedStuff != null) {
    draggedStuff.mouseDragged();
  }
}

void mouseReleased() {
  mainStuff.mouseEvent(RELEASE);
  draggedStuff = null;
}

void setup() {
  mainStuff = new MainStuff();
  mainStuff.setup(); mainStuff.setUp = true;
}
