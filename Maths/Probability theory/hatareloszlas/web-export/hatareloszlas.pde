class MainStuff extends Stuff {
  void setup() {
    size(300, 600);
    add(graph = new Graph());
    add(new AddButton());
    add(new DelButton());
    add(helper = new Helper());
  }
  void draw() {
    background(240);
  }
}

Graph graph;
Helper helper;

class Graph extends Stuff {
  float[] ps, ps2;
  int n;

  void setup() {
    x = y = 0;
    w = width; 
    h = height;

    n = width;
    ps = new float[n];
    ps2 = new float[n];
  }

  void mousePressed() {
    draggedStuff = this;
    if (helper.parent != null) helper.remove();
  }


  void mouseDragged() {
    for (int i=(int)pmouseX; i<=(int)mouseX; ++i) {
      if (0<=i && i < n)
        ps[i] = h-mouseY > 0 ? h-mouseY : 0;
    }
    for (int i=(int)mouseX; i<=(int)pmouseX; ++i) {
      if (0<=i && i < n)
        ps[i] = h-mouseY > 0 ? h-mouseY : 0;
    }
  }

  void draw() {
    /*noFill();
     beginShape();
     for (int i=0; i<w; ++i) {
     vertex(i, h-ps[i]);
     }
     endShape();*/
    stroke(0, 0, 255);
    for (int i=0; i<w; ++i) {
      line(i, h, i, h-ps[i]);
    }
  }

  void add2() {
    long area = 0; 
    for (int i=0; i<width; ++i) area += ps[i];

    for (int i=0; i<width; ++i) {
      ps2[i] = 0;
      for (int j=i-width/2; j<i; ++j) {
        ps2[i] += (j<0?0:ps[j]) * (2*i-j>=width?0:ps[2*i-j]);
      }
    }

    long area2 = 0; 
    for (int i=0; i<width; ++i) area2 += ps2[i];

    float d = 1.0*area/area2;

    for (int i=0; i<width; ++i) {
      ps[i]=ps2[i] * d;
    }
  }

  void clear() {
    for (int i=0; i<width; ++i) {
      ps[i]=0;
    }
  }

  void mouseMoved() {
    cursor(CROSS);
  }
}

abstract class Button extends Stuff {
  String text;

  Button(String atext, float ax) { 
    mode = CENTER;
    h=30; 
    w=20+textWidth(atext); 
    x=ax; 
    y=20;
    text = atext;
  }

  void draw() {
    noStroke(); 
    fill(0, mouseOver ? 200 : 128);
    rectMode(mode);
    rect(0, 0, w, h, h/3);

    textAlign(CENTER, CENTER);
    fill(255);
    text(text, 0, 0);
  }

  void mouseEntered() {
    cursor(HAND);
  }
}

class AddButton extends Button {
  AddButton() {
    super("(X+X)/2", 40);
  }
  void mouseClicked() {
    graph.add2();
  }
}


class DelButton extends Button {
  DelButton() {
    super("Törlés", 110);
  }
  void mouseClicked() {
    graph.clear();
  }
}

class Helper extends Stuff {
  void setup() {
    mode = CENTER;
    x = width/2; 
    y = height/2;
  }

  void draw() {
    fill(0, 100);
    textAlign(CENTER, CENTER);
    text("Rajzolj egy valószínűségi eloszlást,\nmajd kattints az (X+X)/2 gombra!", 0, 0);
  }
}

/*
Sometimes you don't need a complex framework for your Processing sketch.
Just some stuff you can draw click and drag.

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

