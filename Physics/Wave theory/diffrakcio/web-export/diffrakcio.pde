
int n = 120;
int d = 48;
float lambda=10;
float k = 2*PI/lambda;
float[] zone= new float[n];
int zoom=10;
float dim=0.1;

void setup() {
  size(n*zoom,d*zoom);
  strokeWeight(zoom);
}

void mouseDragged() {
    int a = pmouseX/zoom, b=mouseX/zoom;
    if (a>b) { a=b-a; b-=a; a+=b; }
    a=max(0,a); b = min(n-1,b);
    for (int i=a; i<=b; ++i) zone[i] = (mouseButton == LEFT ? (height-mouseY) : 0);
}

void draw() {
  background(0,0,80);
  for(int i=0; i<n; ++i) {
    stroke(zone[i]*zone[i]*0.02,0,0,255);
    line(i*zoom,d*zoom-30,i*zoom,d*zoom);
  }
  for(int i=0; i<n; ++i) {
    float x = 0; float y = 0;
    for(int j=0; j<n; ++j) {
      int dx = (i-j);
      float R = sqrt(d*d+(dx*dx));
      x+=zone[j]*cos(k*R)/R;
      y+=zone[j]*sin(k*R)/R;
    }
    stroke(dim * (x*x+y*y),0,0,255);
    line(i*zoom,0,i*zoom,30);
  } 
}

