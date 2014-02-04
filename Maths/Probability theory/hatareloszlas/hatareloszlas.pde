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

