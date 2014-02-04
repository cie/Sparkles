int n = 601;
float speed = 0.9,
      m=10;
  int step=5;
float[]
  Ex = new float[n], 
  Ey = new float[n], 
  Hx = new float[n],
  Hy = new float[n], 
  Ex2 = new float[n], 
  Ey2 = new float[n], 
  Hx2 = new float[n],
  Hy2 = new float[n], 
  ior=new float[n] ;
float beta = 0.01;

void setup() {
  size(600,300);
  noFill();
  clear();
  for (int i=0;i<n;++i) {
    ior[i] = 1;
  }
}

void mouseClicked() {
  if (mouseButton == RIGHT) {
    clear();
  }
}

void clear() {
  for (int i=0;i<n;++i) {
   Ex[i] = 0; Ey[i] = 0;
   Hy[i] = 0; Hx[i] = 0;
  }
}

int sourceX, sourceY;

void mousePressed() {
  //sourceX = mouseX < 50 ? 0 : mouseX > width-50 ? n-1 : mouseX;
  sourceX = mouseX;
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
  //scale(10,1); step=1;
  if (!paused) {
    for (int i=1;i<n-1;++i) {
      Ex[i] = Ex[i] + speed*(Hy[i+1]-Hy[i-1])/2/ior[i]/ior[i];
      Ey[i] = Ey[i] - speed*(Hx[i+1]-Hx[i-1])/2/ior[i]/ior[i];
      Hx[i] = Hx[i] - speed*(Ey[i+1]-Ey[i-1])/2;
      Hy[i] = Hy[i] + speed*(Ex[i+1]-Ex[i-1])/2;
    }/*
    float[] t;
    t = Ex; Ex = Ex2; Ex2 = t;
    t = Ey; Ey = Ey2; Ey2 = t;
    t = Hx; Hx = Hx2; Hx2 = t;
    t = Hy; Hy = Hy2; Hy2 = t;*/
    Ex[0] = Ex[1];
    Ey[0] = Ey[1];
    Hx[0] = Hx[1];
    Hy[0] = Hy[1];
    Ex[n-1] = Ex[n-2];
    Ey[n-1] = Ey[n-2];
    Hx[n-1] = Hx[n-2];
    Hy[n-1] = Hy[n-2];
  }
  
  float newEx=0, newEy=0, newHx=0, newHy=0;
  
  if (mousePressed) {
    if (mouseButton == LEFT) {
      int i;
      if (sourceX <width/2) {
        newEx = (mouseX-sourceX);
        newEy = mouseY-height/2;
        newHx = (mouseY-height/2);
        newHy = -(mouseX-sourceX);
        i = 0;
      } else {
        newEx = (mouseX-sourceX);
        newEy = mouseY-height/2;
        newHx = -(mouseY-height/2);
        newHy = (mouseX-sourceX);
        i = n-1;
      }
      Ex[i] = newEx;
      Ey[i] = newEy;
      Hx[i] = newHx;
      Hy[i] = newHy;
      
    } if (mouseButton == CENTER) {
      int a = mouseX < pmouseX ? mouseX : pmouseX;
      int b = mouseX < pmouseX ? pmouseX : mouseX;
      a = a < 0 ? 0 : a;
      b = b > n-1 ? n-1 : b;
      for (int i = a; i<=b; ++i) {
        ior[i] = 2-2.0*sourceY/height;
      }
    } else if (mouseButton == RIGHT) {
      /*int a=mouseX, b=pmouseX;
      if (a>b) { int t = a; a=b; b=t; }
      a = min(n-1,a); b=max(0,b);
      for (int i=a; i<=b; ++i) {
        x[i] = 0;
        y[i] = mouseY-height/2;
        vx[i] = 0;
        vy[i] = 0;
      }*/
    }
  } else {
  }
 
  
  background(#0F1148);
  
  // ior
  noFill();
  strokeWeight(1);
  stroke(#ffff00); 
  beginShape();
  for (int i=0;i<n;++i) {
    vertex(i*width/ n, (2-ior[i])/2*height);
  }
  endShape();
  
  // hullám
  strokeWeight(2);
  for(int i=0; i<n; i+=step) {
    if (Ex[i] < Hx[i]) { E(i); H(i); } else { H(i); E(i); }
    
    stroke(255,255,255);
    line(i,height/2,i+0.2*Hx[i],height/2+Hy[i]);
  }
  
  //indikátor
  if (mousePressed && mouseButton == LEFT) {
    
    // shadows
    strokeWeight(6);
    int shade = 80, delta = 5;
    //E
    stroke(#000000,shade);
    line(sourceX+delta, height/2+delta, sourceX+newEx+delta, height/2+newEy);
    //H
    stroke(#000000,shade);
    line(sourceX+delta, height/2+delta, sourceX+newHx+delta, height/2+newHy+delta);
    // center
    noStroke();
    fill(0,shade);
    ellipse(sourceX+delta,height/2+delta,21,21);
    
    //E
    stroke(#aa0000);
    line(sourceX, height/2, sourceX+newEx, height/2+newEy);
    //H
    stroke(#aaaaaa);
    line(sourceX, height/2, sourceX+newHx, height/2+newHy);
    
    //center
    strokeWeight(2);
    stroke(89);
    fill(128);
    ellipse(sourceX,height/2,20,20);
    
    
  }
  
}

void E(int i) {
  stroke(255,0,0);
  line(i,height/2,i+0.2*Ex[i],height/2+Ey[i]);
}

void H(int i) {
  stroke(255,255,255);
  line(i,height/2,i+0.2*Hx[i],height/2+Hy[i]);
}

