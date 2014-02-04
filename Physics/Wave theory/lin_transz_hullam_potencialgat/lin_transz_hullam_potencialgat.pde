int n = 600;
float D = 0.1;
float speed = 0.3;
float[] z = new float[n], v = new float[n], V=new float[n];
float beta = 0.01;

void setup() {
  size(600,300);
  noFill();
  clear();
  for (int i=0;i<n;++i) {
    V[i] = height/2;
  }
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
  } else if (mouseButton == CENTER) {
    dragPoint = mouseY;
  }
}


void draw() {
  for (int i=1;i<n-1;++i) {
    v[i] = v[i] + D*(z[i-1]+z[i+1]-2*z[i]) ;
  }
  for (int i=1;i<n-1;++i) {
    z[i] = z[i] + v[i]*speed - beta*(v[i])*(-V[i]+height/2);
  }
  
  if (mousePressed) {
    if (mouseButton == LEFT) {
      z[dragPoint] = mouseY;
      v[dragPoint] = (mouseY-pmouseY)/speed;
    } if (mouseButton == CENTER) {
      int a = mouseX < pmouseX ? mouseX : pmouseX;
      int b = mouseX < pmouseX ? pmouseX : mouseX;
      a = a < 0 ? 0 : a;
      b = b > n-1 ? n-1 : b;
      for (int i = a; i<=b; ++i) {
        V[i] = dragPoint;
      }
    }
  }
 
  
  background(#0F1148);
  
  // potenciál
  stroke(#ff0000); 
  beginShape();
  for (int i=0;i<n;++i) {
    vertex(i*width/ n, V[i]);
  }
  endShape();
  
  // hullám
  stroke(255); 
  beginShape();
  for (int i=0;i<n;++i) {
    vertex(i*width/ n, z[i]);
  }
  endShape();
  
}

