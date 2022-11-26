class StartVectors{
  ArrayList<PVector> grower_dirs;
  ArrayList<PVector> wall_starts;
  ArrayList<PVector> wall_ends;
  
  StartVectors(){
    float da_rad = da_deg/360.0*TWO_PI;
    grower_dirs = new ArrayList<PVector>();
    wall_starts = new ArrayList<PVector>();
    wall_ends = new ArrayList<PVector>();
    
    PVector mid = new PVector(width/2.0, height/2.0);
    float delta_a = TWO_PI / float(n);
    float start_a = delta_a / 2.0;
    for(int i = 0; i < n; i++){
      float a = PI/2.0 + start_a + i * delta_a;
      PVector delta = PVector.fromAngle(a).mult(r);
      grower_dirs.add(new PVector(mid.x+delta.x, mid.y+delta.y, a+da_rad));
    }
    
    
    boolean R_valid = (width/2.0 > R);
    if(R_valid){
      for(int j = 0; j < m; j++){
        float random_a = int(!order) * random(PI);
        float chosen_a = int(order) * ((j%3==0) ? a1 : ((j%3==1) ? a2 : a3));
        float other_a = random_a + chosen_a;
        float pos_random_a = random(TWO_PI);
        float dist_random =  random(R, width/2);
        PVector other_pos = PVector.fromAngle(pos_random_a).mult(dist_random).add(mid);
        grower_dirs.add(new PVector(other_pos.x, other_pos.y, other_a));
      }
    } else {
      print("Big radius should be smaller than half image width.\r\n");
    }
    if(use_walls && n_walls > 3){
      float delta_a_wall = TWO_PI/float(n_walls);
      for(int k = 1; k < n_walls+1; k++){
        wall_starts.add(PVector.fromAngle(((k-1)%n_walls)*delta_a_wall).mult(R_walls).add(mid));
        wall_ends.add(PVector.fromAngle((k%n_walls)*delta_a_wall).mult(R_walls).add(mid));
      }
    }
  }
}
