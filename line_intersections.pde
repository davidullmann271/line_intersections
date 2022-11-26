import toxi.geom.*; 
import toxi.processing.*;

int max_branches = 5000;
int spawnspeed_branches = 5;
int startcount_branches = 3;
float growspeed = 1;
//float mingrowdist = 3;
float a1 = 0;
float a2 = 0.7854; // = pi/4.0
float a3 = 1.05;
int whitelimit_dismisser = 3;
int maxcount_dismisser = 1;
int brightness_bg = 0;
int brightness_line = 255;
float col_rand_intensity = 0.4;

boolean use_startvectors = true;
int n = 3;
int m = 20;
float r = 100.0;
float R = 250.0;
boolean order = false;
float da_deg = -120.0;
boolean use_walls = true;
int n_walls = 6;
float R_walls = 250.0;

color[] colorhexes = {#f4f1de, #e07a5f, #3d405b, #81b29a, #f2cc8f};
//color[] colorhexes = {#22223b, #4a4e69, #9a8c98, #c9ada7, #f2e9e4};
//color[] colorhexes = {#780000, #c1121f, #fdf0d5, #003049, #669bbc};
//color[] colorhexes = {#e63946, #f1faee, #a8dadc, #457b9d, #1d3557};
//color[] colorhexes = {#006d77, #83c5be, #edf6f9, #ffddd2, #e29578};
//color[] colorhexes = {#ff0000, #ff0000, #ff0000, #ff0000, #ff0000};
//color[] colorhexes = {#252323, #70798c, #f5f1ed, #dad2bc, #a99985};


Family f;
Colorbook c;
boolean dismisser_used = false;
float maxdistance;

void setup(){
  //fullScreen(P2D);
  size(1080,1080);
  //size(600,480);
  background(brightness_bg);
  smooth(0);
  stroke(brightness_line);
  strokeWeight(2);
  maxdistance=sqrt(pow(width,2)+pow(height,2));
  f = new Family(max_branches, startcount_branches, spawnspeed_branches, a1, a2, a3);
  c = new Colorbook();
}

void keyPressed(){
  if(key == 'r'){
    resetGraphics();
  }
}

void resetGraphics(){
  f = new Family(max_branches, startcount_branches, spawnspeed_branches, a1, a2, a3);
  loadPixels();
  clearPixels();
  updatePixels();
  c.resetWhitestate();
  dismisser_used = false;
  loop();
}



void draw(){
  f.run();
  if(!f.can_grow && !f.is_growing && c.has_white){
    loadPixels();
    if(!dismisser_used){
      for(int i = 0; i < maxcount_dismisser; i++){
        dismissWhites();
      }
      dismisser_used = true;
    }
    c.colorImagePart();
    updatePixels();
  } 
  if(!c.has_white){
    noLoop();
    print("Graphics ready.\r\n");
  }
  
}

void clearPixels(){
  for (int i = 0; i < width*height; i++) {
    pixels[i] = color(brightness_bg);
  }
}

void dismissWhites(){
  for(int j = 1; j < height-1; j++){
    for(int i = 1; i < width-1; i++){
      PVector currentpos = new PVector(i, j);
      int currentind = coords_to_index(currentpos);
      if(pixels[currentind] == color(brightness_line)){
        int sum = 0;
        for(int m = -1; m <= 1; m++){
          for(int n = -1; n <= 1; n++){
             PVector neighborpos = new PVector(i+n, j+m);
             int neighborind = coords_to_index(neighborpos);
             if(pixels[neighborind] == color(brightness_line)){
               sum++;
             }
          }
        }
        if(sum <= whitelimit_dismisser){
          pixels[currentind] = color(brightness_bg);
        }
      }
    }
  }
}
