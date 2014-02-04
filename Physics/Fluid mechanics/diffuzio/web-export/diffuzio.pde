int n=240, a = 800/n;
float[] colors=new float[n], newcolors=new float[n];

void setup() {
  size(n*a,255+a*3);
  for(int i=n/2; i<n; ++i) { colors[i]=255; }
  frameRate(100);
}

void draw() {
  background(128);
  
  noStroke();
  for(int i=0; i<colors.length; ++i) {
    fill(colors[i]);
    rect(i*a,0,a,a);
  }
  
  noFill(); stroke(255,0,0);
  beginShape();
  for(int i=0; i<colors.length; ++i) {
    vertex(i*a+a/2, height-colors[i]-a);
  }
  endShape();
  
  noFill(); stroke(0,0,255);
  beginShape();
  for(int i=1; i<colors.length; ++i) {
    vertex(i*a, height+colors[i-1]-colors[i]-a);
  }
  endShape();
  
  
  for(int i=1; i<colors.length-1; ++i) {
    //newcolors[i] = colors[i] + (colors[i+1] - 2*colors[i] + colors[i-1]) / 2;
    //newcolors[i] = (colors[i+1] + colors[i-1]) / 2;  
    //newcolors[i] = colors[i] + ((colors[i+1] - 2*colors[i] + colors[i-1]) / 2)*0.1;
    //newcolors[i] = lerp(colors[i], (colors[i+1] + colors[i-1]) / 2, 1); 
    newcolors[i] = lerp(colors[i], (colors[i+1] + colors[i-1]) / 2, 0.01);  
  }
  for(int i=1; i<colors.length-1; ++i) {
    colors[i] = newcolors[i]; 
  }
  
    
}


