class Family {
  ArrayList<Branch> branches;
  ArrayList<Wall> walls;
  StartVectors sv;
  
  boolean can_grow = true;
  boolean is_growing = true;
  
  int maxbranches, spawnspeed;
  float a1, a2, a3;
  
  Family(int maxbranches, int startbranches, int spawnspeed, float a1, float a2, float a3){
    sv = new StartVectors();
    branches = new ArrayList<Branch>();
    walls = new ArrayList<Wall>();
    this.maxbranches = maxbranches;
    this.spawnspeed = spawnspeed;
    this.a1 = a1;
    this.a2 = a2;
    this.a3 = a3;
    if(!use_startvectors){
      for(int i = 0; i < startbranches; i++){
        float theta = a1;
        if(i%3 == 0) theta = a2;
        else if (i%3 == 1) theta = a3;
        branches.add(new Branch(random(width), random(height),theta));
      }
    } else {
      for(int i = 0; i < sv.grower_dirs.size(); i++){
        PVector current = sv.grower_dirs.get(i);
        Branch b = new Branch(current.x, current.y, current.z);
        branches.add(b);
      }
    }
    if(use_walls){
      for(int i = 0; i < sv.wall_starts.size(); i++){
        PVector start = sv.wall_starts.get(i);
        PVector end = sv.wall_ends.get(i);
        walls.add(new Wall(start, end));
      }
    }
  }
  
  void evaluate(){
    float sum = 0;
    for(int i = 0; i < branches.size(); i++){
        sum += branches.get(i).len;
    }
    for(int i = 0; i < branches.size(); i++){
        branches.get(i).prob = branches.get(i).len/sum;
    }
  }
  
  Branch pickOne(ArrayList<Branch> list){
    int index = 0;
    float r = random(1);
    
    while(r > 0 && index < list.size()) {
      r = r - list.get(index).prob;
      index++;
    }
    if(index != 0)index--;
    
    return list.get(index);
  }
  
  void addBranches(){
    if(branches.size() < maxbranches) {
      evaluate();
      
      Branch rand = branches.get(floor(random(branches.size())));
      if(branches.size()>10) {
        evaluate();
        rand = pickOne(branches);
      } 
      
      float randLerp = random(1);
     // float randLerp = (sqrt(5)-1)/2;
      float x = lerp(rand.start.x, rand.end.x, randLerp);
      float y = lerp(rand.start.y, rand.end.y, randLerp);
      
      Branch b = new Branch(x,y,rand.dir+PI/2);
      branches.add(b);
    } else {
      can_grow = false;
    }
  }
  
  void intersect(){
    for(Branch b : branches){
      if(b.cangrow){
        for(Branch c : branches){
          if(b == c){
            continue;
          }
          if(b.intersect_other(c)){
            break;
          }
        }
      }
    }
    if(use_walls){
      for(Branch b : branches){
        if(b.cangrow){
          for(Wall c : walls){
            if(b.intersect_wall(c)){
              break;
            }
          }
        }
      }
    }
  }
  
  void run(){
    boolean growing_found = false;
    for(Branch b : branches){
      b.show();
      boolean cangrow = b.grow();
      if(cangrow){
        growing_found = true;
      }
    }
    is_growing = growing_found;
    for(Wall w : walls){
      w.show();
    }
    //if(can_grow){
    if(true){
      for(int n = 0; n < spawnspeed; n++){
        addBranches();
      }
      
      intersect();
      delete();
    }
  }
  
  void delete(){
    for(int i = branches.size()-1; i >=0; i--){
      Branch b = branches.get(i);
      if(!b.cangrow && b.len < 3) branches.remove(i);
    }
  }
}
