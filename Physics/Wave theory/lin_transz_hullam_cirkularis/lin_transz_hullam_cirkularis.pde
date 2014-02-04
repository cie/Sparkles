int n = 600;
float D = 0.1;
float speed = 2.3;
float[]
  x = new float[n], 
  y = new float[n], 
  vx = new float[n],
  vy = new float[n], 
  V=new float[n] ;
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
   vx[i] = 0; vy[i] = 0;
   y[i] = height/2; x[i] = 0;
  }
}

int sourceX, sourceY;

void mousePressed() {
  sourceX = mouseX < 50 ? 0 : mouseX > width-50 ? n-1 : mouseX;
  sourceY = mouseY;
}


void draw() {
  for (int i=1;i<n-1;++i) {
    vx[i] = vx[i] + D*(x[i-1]+x[i+1]-2*x[i]) ;
    vy[i] = vy[i] + D*(y[i-1]+y[i+1]-2*y[i]) ;
  }
  for (int i=1;i<n-1;++i) {
    x[i] = x[i] + vx[i]*speed - beta*(vx[i])*(-V[i]+height/2);
    y[i] = y[i] + vy[i]*speed - beta*(vy[i])*(-V[i]+height/2);
  }
  
  if (mousePressed) {
    if (mouseButton == LEFT) {
      x[sourceX] = -mouseX+sourceX;
      y[sourceX] = mouseY;
      vx[sourceX] = (mouseX-pmouseX)/speed;
      vy[sourceX] = (mouseY-pmouseY)/speed;
    } if (mouseButton == CENTER) {
      int a = mouseX < pmouseX ? mouseX : pmouseX;
      int b = mouseX < pmouseX ? pmouseX : mouseX;
      a = a < 0 ? 0 : a;
      b = b > n-1 ? n-1 : b;
      for (int i = a; i<=b; ++i) {
        V[i] = sourceY;
      }
    }
  }
 
  
  background(#0F1148);
  
  // potenciál
  strokeWeight(1);
  stroke(#ff0000); 
  beginShape();
  for (int i=0;i<n;++i) {
    vertex(i*width/ n, V[i]);
  }
  endShape();
  
  // hullám
int i = 1;
  while (i<n) {
    int k = i;
    while (k<n-1&&x[k]<x[k-1]) ++k;
    for (int j=k; j>=i; --j) { 
      stick(j);
    }
    int l=k;
    while (l<n-2&&x[l+1]<x[l]) ++l;
    for (int j=l; j>=i; --j) {
     stick(j); 
    }
    i = l+1;
  }
  
  
}
void stick(int j) {
  //stroke(-atan2(y[j]-y[j-1], x[j]-x[j-1])*20+128);
  float dx = x[j]-x[j-1], dy = y[j]-y[j-1], a=sqrt(dx*dx+dy*dy+1);
  stroke(abs((1*dx+2*dy+2*1)/a)*50+40); 
  strokeWeight(max(0,12-height*10.0/(x[j-1]+height*1.21)));
  line(j-1-0.2*x[j-1],y[j-1],j-0.2*x[j],y[j]);
}
