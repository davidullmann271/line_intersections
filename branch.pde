class Branch {
  Line2D line;
  Vec2D start;
  Vec2D end;
  Vec2D dirVec;
  PVector tdirVec;
  float dir;
  boolean cangrow = true;
  
  
  PVector tstart, tend;
  float len;
  float prob;
  //float rCol = random(150,255);
  
  boolean gotp = false;
  
  Branch(float x, float y, float dir){
    start = new Vec2D(x,y);
    end = new Vec2D(x,y);
    tstart = new PVector(x,y);
    tend = new PVector(x,y);
    
    this.dir = dir;
    float dx = growspeed*cos(dir);
    float dy = growspeed*sin(dir);
    this.dirVec = new Vec2D(dx,dy);
    tdirVec = new PVector(dx,dy);
    len = 0;
    line = new Line2D(start,end);
  }
  
  boolean grow(){
    if(cangrow){
      end.addSelf(dirVec);
      tend.set(end.x, end.y);
    }
    
    
    len = tstart.dist(tend);
    line = new Line2D(start,end);
    if(end.x < 0 || end.x > width || end.y < 0 || end.y > height) cangrow = false;
    return cangrow;
  }
  
  boolean intersect_other(Branch other){
    Line2D.LineIntersection inter = line.intersectLine(other.line);
    if (inter.getType()==Line2D.LineIntersection.Type.INTERSECTING) {
      Vec2D pos=inter.getPos();
      float xdist = end.x-pos.x;
      float ydist = end.y-pos.y;
      if(sqrt(pow(xdist,2) + pow(ydist,2)) < 1 ){
        cangrow = false;
        tend.sub(tdirVec.mult(1));
        return true;
      }
      return false;
    }
    return false;
  }
  
  boolean intersect_wall(Wall other){
    Line2D.LineIntersection inter = line.intersectLine(other.line);
    if (inter.getType()==Line2D.LineIntersection.Type.INTERSECTING) {
      Vec2D pos=inter.getPos();
      float xdist = end.x-pos.x;
      float ydist = end.y-pos.y;
      if(sqrt(pow(xdist,2) + pow(ydist,2)) < 1 ){
        cangrow = false;
        tend.sub(tdirVec.mult(1));
        return true;
      }
      return false;
    }
    return false;
  }
  
  void show(){
    line(start.x, start.y, tend.x, tend.y);
  }
}

class Wall{
  Line2D line;
  Vec2D start;
  Vec2D end;
  Vec2D dirVec;
  PVector tdirVec;
  float dir;  
  PVector tstart, tend;
  
  Wall(PVector tstart, PVector tend){
    this.tstart = tstart;
    this.tend = tend;
    start = new Vec2D(tstart.x,tstart.y);
    end = new Vec2D(tend.x, tend.y);
    tdirVec = tend.copy().sub(tstart);
    dirVec = new Vec2D(tdirVec.x, tdirVec.y);
    dir = tdirVec.heading();
    line = new Line2D(start,end);
  }
  
  void show(){
    line(tstart.x, tstart.y, tend.x, tend.y);
  }
}
