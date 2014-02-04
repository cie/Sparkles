int n = 600;
float D = 0.1;
float speed = 0.3;
float[] z = new float[n], v = new float[n];
float beta = 0.00;

void setup() {
  size(600,300);
  stroke(255); noFill();
  clear();
}

void mouseClicked() {
  if (mouseButton == RIGHT) {
    clear();
  }
}

void clear() {
  for (int i=0;i<n;++i) {
   v[i] = 0;
   z[i] = height/2;
  }
}

int dragPoint;

void mousePressed() {
  if (mouseButton == LEFT) {
    dragPoint = mouseX < 50 ? 0 : mouseX > width-50 ? n-1 : mouseX;
  }
}


void draw() {
  for (int i=1;i<n-1;++i) {
    v[i] = v[i] + D*(z[i-1]+z[i+1]-2*z[i]) - beta*(v[i]);
  }
  for (int i=1;i<n-1;++i) {
    z[i] = z[i] + v[i]*speed;
  }
  
  if (mousePressed) {
    if (mouseButton == LEFT) {
      z[dragPoint] = mouseY;
      v[dragPoint] = (mouseY-pmouseY)/speed;
    }
  }
 
  
  background(#0F1148);
  
  beginShape();
  for (int i=0;i<n;++i) {
    vertex(i*width/ n, z[i]);
  }
  endShape();
}

