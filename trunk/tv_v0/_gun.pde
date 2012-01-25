class _gun{
  _unit unit;
  
  _fire fires[];
  float precision;
  char prediction;
  float range;
  float strength;
  float weight; // = 1/moving_speed
  
  int delay;
  int shot_time;
  
  _gun(_gun g){
    this.set(g.precision, g.prediction, g.range, g.strength, g.weight, g.delay);
  }
  _gun(float p, char pred, float r, float s, float w, int d){
    this.set(p,pred,r,s,w,d);
  }
  _gun(float p, float pred, float r, float s, float w, float d){
    this.set(p,(char)pred,r,s,w,(int)d);
  }
  void set(float p, char pred, float r, float s, float w, int d){    
    this.precision=p;
    this.prediction=pred;
    this.range=r;
    this.strength=s;
    this.weight=w;
    this.delay=d;
    this.shot_time=SPACE.time+int(random(-750,750));
    
    this.fires=new _fire[0];
  }
  
  void fire(_unit thinking){
    float l=thinking.position.distance_from(this.unit.position);
    this.fire(
              (thinking.position.x-this.unit.position.x)/l,
              (thinking.position.y-this.unit.position.y)/l,
              (thinking.position.z-this.unit.position.z)/l,
              thinking
             );
  }
  void fire(float xs, float ys, float zs){
    fire(xs,ys,zs,null);
  }
  void fire(float xs, float ys, float zs, _unit thinking){
     if(this.fires.length>=MAXFIRES)
        this.fires =(_fire[]) subset(this.fires,1);
     this.fires    =(_fire[]) append(this.fires, new _fire(
                                                           this,
                                                           xs,ys,zs,
                                                           thinking
                                                          ));
     this.shot_time=SPACE.time+int(random(-50,50));
  }
  
  void draw(){
    //delete ended fires
    int dead_fires=0;
    while (this.fires.length>++dead_fires && this.fires[dead_fires].got);
    this.fires=(_fire[]) subset(this.fires,dead_fires-1);
    
    //draw fire
    for (int i=0; i<this.fires.length; i++)fires[i].draw();
    
    //shot 1 new fire
    if( SPACE.time-this.shot_time >= this.delay   &&  this.range>0 && this.unit.life>0){
      int hitting_id=-999;
      float max_nice=-999999.;
      float nice; float dis=0;
      for (int i=0;i<SPACE.units.length;i++) {
        if (
         this.unit.enemy != SPACE.units[i].enemy  &&
         SPACE.units[i].life>0  &&
         (dis=this.unit.position.distance_from(SPACE.units[i].position)) <= this.range+SPACE.units[i].radius
        ){
            nice=this.range*20-dis*10;
            if(nice>max_nice){
              max_nice=nice;
              hitting_id=i;
            }
        }
      }
      if(max_nice>=0 && hitting_id>=0){
        _unit hitting=SPACE.units[hitting_id];
        if(false && this.weight>=1)
            this.fire(hitting);
        else{
            dis=this.unit.position.distance_from(hitting.position);
            hitting.hit(this.strength*(1-(dis<10?10:dis)/this.range),this);
            stroke(
             this.unit.enemy?0:180,
             80,
             100,
             90 * ( 1-sq(dis/this.range))
            );
            SPACE.d_line(this.unit.position, hitting.position);
        }
      }
      
      if(checkKey(KeyEvent.VK_D)){
        println("      max_nice: "+max_nice+"  //in firing action; hitting unit nice>=0");
      }
    }
  }
}
