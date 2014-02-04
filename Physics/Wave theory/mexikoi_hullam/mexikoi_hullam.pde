int n = 60;
int zoom=20;
float[] z = new float[n], z2 = new float[n], z3=new float[n];


void setup() {
  size(zoom*n+1, zoom*5+1);
  frameRate(5);
  strokeWeight(1.0/zoom);
}

void mousePressed() {
  mouseDragged();
}

void mouseDragged() {
  z[mouseX/zoom] = mouseY>zoom ? 0 : 1;
}

void draw() {
  background(128);
  scale(zoom,-zoom);
  translate(0,-3);
  for(int i=0;i<n;++i) {
    //z2[i] = (i>0 && i < n-1) ? 
      //(z[i-1]==0 && z[i+1]==0) ? 0
      //: (z[i-1]==1 && z[i+1]==1) ? 1
      //: 1-z[i] 
    //: z[i];
   z2[i] = (i>0 && i < n-1) ? 
      z[i] + (z[i-1]-z3[i-1])+(z[i+1]-z3[i+1]) 
    : z[i];
   z2[i] = max(z2[i],0);
   z2[i] = min(z2[i],1);
  }
  for (int i=0;i<n;++i) {
   z3[i] = z[i];
  }
  float[] t = z; z=z2; z2=t;
  for(int i=0;i<n;++i) {
    rect(i, z[i], 1, 1);
  }
  
}
