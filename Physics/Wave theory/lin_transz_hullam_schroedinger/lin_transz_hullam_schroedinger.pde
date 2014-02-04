int n = 600;
float D = 600;
float speed = 0.0008,
      m=10;
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
    V[i] = 0;
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
   y[i] = 0; x[i] = 0;
  }
}

int sourceX, sourceY;

void mousePressed() {
  sourceX = mouseX < 50 ? 0 : mouseX > width-50 ? n-1 : mouseX;
  sourceY = mouseY;
}

boolean paused;
void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
}


void draw() {
  /*for (int i=1;i<n-1;++i) {
    vx[i] = vx[i] + D*(x[i-1]+x[i+1]-2*x[i]) ;
    vy[i] = vy[i] + D*(y[i-1]+y[i+1]-2*y[i]) ;
  }*/
  if (!paused) {
    for (int i=1;i<n-1;++i) {
      x[i] = x[i] - speed*(-D*(y[i-1]+y[i+1]-2*y[i]) + m*V[i]*y[i]);
      y[i] = y[i] + speed*(-D*(x[i-1]+x[i+1]-2*x[i]) + m*V[i]*x[i]);
    }
  } else {
    fill(192);
    text("PAUSED", 20, 20);
  }
  
  if (mousePressed) {
    if (mouseButton == LEFT) {
      x[sourceX] = -mouseX+sourceX;
      y[sourceX] = mouseY-height/2;
      vx[sourceX] = (mouseX-pmouseX)/speed;
      vy[sourceX] = (mouseY-pmouseY)/speed;
    } if (mouseButton == CENTER) {
      int a = mouseX < pmouseX ? mouseX : pmouseX;
      int b = mouseX < pmouseX ? pmouseX : mouseX;
      a = a < 0 ? 0 : a;
      b = b > n-1 ? n-1 : b;
      for (int i = a; i<=b; ++i) {
        V[i] = height/2-sourceY;
      }
    } else if (mouseButton == RIGHT) {
      int a=mouseX, b=pmouseX;
      if (a>b) { int t = a; a=b; b=t; }
      a = min(n-1,a); b=max(0,b);
      for (int i=a; i<=b; ++i) {
        x[i] = 0;
        y[i] = mouseY-height/2;
        vx[i] = 0;
        vy[i] = 0;
      }
    }
  }
 
  
  background(#0F1148);
  
  // potenciál
  strokeWeight(1);
  stroke(#ff0000); 
  beginShape();
  for (int i=0;i<n;++i) {
    vertex(i*width/ n, height/2-V[i]);
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
  line(j-1-0.2*x[j-1],y[j-1]+height/2,j-0.2*x[j],y[j]+height/2);
}
