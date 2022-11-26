class Colorbook{
  boolean has_white;
  
  Colorbook(){
    has_white = true;
  }


/////////////////////////////////////////// MAIN

  boolean colorSection(){
//print("\r\npart: " + frameCount + " color: " + col);
    boolean found = false;
    for (int i = 0; i < width*height; i++) {
//print("\r\nchecking pixel"+i+" for white... ");
      if(coloringRule(pixels[i])){
        color col = mixFromColorhexes(index_to_coords(i));
//print("white found...");
        found = true;
        pixels[i] = col;
        
        ArrayList<Integer> group = new ArrayList<Integer>();
        group.add(i);
//print("creating group...");
        for(int j = 0; j < group.size(); j++){
          PVector currentpos = index_to_coords(group.get(j));
//print("currently checking " + currentpos + "\r\n");
          for(int n = 0; n < 4; n++){
            int addx = ((n%2)*2-1) * floor(n/2);
            int addy = ((n%2)*2-1) * (1-floor(n/2));
            int neighborx = (int(currentpos.x)+addx);
            int neighbory = (int(currentpos.y)+addy);
//print("neighbor"+n+" values: "+addx + " " + addy + "...");
            if(neighborx < 0 || neighborx > width-1 || neighbory < 0 || neighbory > height-1){
//print("skipping this neighbor");
              continue;
            }
        
            int neighborindex = coords_to_index(new PVector(neighborx, neighbory));
            if(coloringRule(pixels[neighborindex])){
//print("neighbor was white...");
              //float distfrombase = (abs(basepos.x-neighborpos.x)+abs(basepos.y-neighborpos.y))/1.2;
              //float mult = distfrombase/maxdist;
              //pixels[neighborindex] = color(red(col)*mult, green(col)*mult, blue(col)*mult);
              pixels[neighborindex] = col;
              group.add(neighborindex);
//print("pixel and group set. groupsize: " + group.size());
            } 
          }
//print("\r\n" + "removing checked pixel from list\r\n");
          group.remove(j);
          j--;
          //if(group.size()==0){
          //  break;
          //}
        }
//print("group done. breaking outer loop\r\n");
        break;
      }  
    }
//print("\r\npart: " + frameCount + " color: " + col + "\r\n\r\n");
    return found;
  }
  
/////////////////////////////////////////// ENVIRONMENT
  
  void colorImageFull(float rmax, float gmax, float bmax){
    color col = randomColor(rmax,gmax,bmax);
    boolean stillfound = colorSection();
    while(stillfound){
      col = randomColor(rmax,gmax,bmax);
      stillfound = colorSection();
    }
  }
  
  void colorImagePart(){
    if(has_white){
      has_white = colorSection();
    }
  }
  
/////////////////////////////////////////// UTILITY
 
  boolean coloringRule(color col){
    //return red(col) == green(col) && green(col) == blue(col) && red(col) != 0;
    return col == color(brightness_bg);
  }
  
  void resetWhitestate(){
    has_white = true;
  }
}

int coords_to_index(PVector vector){
  return int(vector.y)*width + int(vector.x);
}

PVector index_to_coords(int index){
  return new PVector(index%width, floor(index/float(width)));
}

color randomColor(float rmax, float gmax, float bmax){
  return color(random(rmax), random(gmax), random(bmax));
}

color mixFromColorhexes(PVector pixelpos){
  boolean middle = pixelpos.dist(new PVector(width/2.0, height/2.0)) < R_walls;
  float xdist = middle ? (pixelpos.x - width/2.0)*4.0 : width-pixelpos.x;
  float ydist = middle ? (pixelpos.y - height/3.0)*3.0 : height-pixelpos.y;
  float dist = sqrt(pow(xdist,2) + pow(ydist,2));
  
  float differ = random(-col_rand_intensity, col_rand_intensity);
  
  float randomvalue = min(max(map(dist,0,maxdistance,0,colorhexes.length-1)+differ, 0), colorhexes.length-1);
  //float randomvalue = random(colorhexes.length-1);
  int bottomindex = floor(randomvalue);
  int topindex = ceil(randomvalue);
  float fraction = randomvalue - bottomindex;
  color bottom = colorhexes[bottomindex];
  color top = colorhexes[topindex];
  color created = color(weightedAverage(red(bottom), red(top), fraction),
                        weightedAverage(green(bottom), green(top), fraction),
                        weightedAverage(blue(bottom), blue(top), fraction));
  return created;
}

float weightedAverage(float val1, float val2, float ratio){
  return val1 + (val2 - val1) * ratio;
}
