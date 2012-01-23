class _fire {
  _gun gun;
  _unit thinking;
  
  boolean got=false; //ended
  
  _point position;
  _point last_check_p;
  int last_check_t=0;
  _point last_coll_p;
  int last_coll_t;
  
  float life=1;
  float radius=1;
  float distance_done=0;
  
  int units_hit[];
  
  _fire(_gun gun, float xs, float ys, float zs, _unit thinking) {
    this.gun=gun;
    if(gun.prediction<=0)this.thinking=thinking=null;
    else this.thinking=thinking;

    this.position=new _point(gun.unit.position.x, gun.unit.position.y, gun.unit.position.z);
    this.units_hit=new int[0];
    this.life=1+gun.weight;
   
    if(thinking != null || this.gun.prediction<=0){
      switch(gun.prediction){
        case 1:
          float dis=thinking.position.distance_from(this.position);
          _point predicted=thinking.position.get_next(round(dis*gun.weight));
          this.position.motion_set(
              (predicted.x-this.position.x)/gun.weight/dis,
              (predicted.y-this.position.y)/gun.weight/dis,
              (predicted.z-this.position.z)/gun.weight/dis
          );
          break;
        default:
          this.position.motion_set(
              xs/gun.weight,
              ys/gun.weight,
              zs/gun.weight
          );
      }
    }
    
    float alfa=FIREUNPRECISION, beta=FIREUNPRECISION, r;
    r=random(0.-gun.precision,gun.precision)*PI;
    alfa *= (r*r*(r<0?-1:1)) / gun.precision; //precision angle on xy plane
    r=random(0.-gun.precision,gun.precision)*PI;
    beta *= (r*r*(r<0?-1:1)) / gun.precision; //precision angle on xz plane
    this.position.motion_set(
            cos( acos(this.position.xs/this.position.speed) + alfa/1080 ) * this.position.speed,
            sin( asin(this.position.ys/this.position.speed) + alfa/1080 ) * this.position.speed,
            sin( asin(this.position.zs/this.position.speed) + beta/1080 ) * this.position.speed
    );
    
    this.last_check_p=new _point(this.position);
    this.last_check_t=SPACE.time;
    this.last_coll_p=new _point(this.position);
    this.last_coll_t=0;
  }
  
  void draw() {
    if(this.got)return;
    
    this.position.move(0);
    this.distance_done=this.gun.unit.position.distance_from(this.position);
    
    if (this.life<=0.001 || this.distance_done>this.gun.range) {
      this.got=true;
    }
    
    
    {
    /*
     * check collision with other units
      */
        int id=-1;     //colliding unit id
        float margin;  //of the collision
        float ab=this.position.distance_from(this.last_check_p);
        float coll[],back=0,centration=2;  //collision result
        _unit coll_u;  //colliding unit object
        
        float distance=0;
        float nearest_d=9999;
        int nearest_id=-1;
        
        //iterate over all units
        while(id<SPACE.units.length-1) {
          id++;
          coll_u=SPACE.units[id];
        
          //don't hit friend units
          if( this.gun.unit.enemy == coll_u.enemy  ||  coll_u.life<=0 )
             continue;
          
          //don't hit units already hit by this fire
          int h=-1;
          while(h<this.units_hit.length && (h<0 || id!=this.units_hit[h]))h++;
          if(h>=0 && h<this.units_hit.length && id==this.units_hit[h])//note that this IF is needed!
             continue;
          
          //collide with the nearest first!
          distance = coll_u.position.distance_from(this.gun.unit.position);
          if(distance >= nearest_d)
             continue;
          
          //check effective collision with a "virtual interpolation" of this fire's movement
          margin=coll_u.radius;
          coll=coll_u.position.collision_check(this.position,this.last_check_p, ab, margin);   //see _point::collision_check( , , )!
          back=coll[0]; centration=coll[1];
          if( back < 0-margin  ||  centration>1 )
             continue;
          
     
          //--> so it is the nearest!
          nearest_d=distance;
          nearest_id=id;
          
          
        }
        
        if(nearest_id>-1){
        
          
          ///// HIT!!!
          
          id=nearest_id;
          coll_u=SPACE.units[id];
          
          //add to hit units list
          this.units_hit=append(this.units_hit,id);
          //reduce fire's life
          this.life -= coll_u.radius;
          //send event to the unit
          coll_u.hit(this.gun.strength,this);
          //move back to colliding position
          this.position.move_on(0-back);
          this.last_coll_t=SPACE.time;
          this.last_coll_p.set(this.position);
          //draw collision fx
          pushStyle();
          noStroke();
          fill(0,100,100,100-100*(SPACE.time-this.last_coll_t)/FIREFXLIFE);
          SPACE.d_text(""+coll_u.id,this.last_coll_p);
          popStyle();
          
          //debug info of the collision
          if(checkKey(KeyEvent.VK_D))println("      fire hit("+   this.gun.unit.id+" to "+id+")["+(this.units_hit.length)+"];  //millis:"+SPACE.time);

        }
    }
        
    this.last_check_p.set(this.position);
    this.last_check_t=SPACE.time;
    
    
    pushStyle();
    //draw collision fx
    noStroke();
    fill(0,100,100,100-100*(SPACE.time-this.last_coll_t)/FIREFXLIFE);
    SPACE.d_ellipse(this.last_coll_p,5,5);
          
          
    //draw fire movement
    for(int i=0;i<5;i++){
      stroke(
             this.gun.unit.enemy?0:180,
             80,
             100,
             (5-i) * 20 * ( 1-sq(this.distance_done/this.gun.range)) * ( this.gun.unit.life>0 ? 1 : (1-(SPACE.time-this.gun.unit.damage)/DEBRISLIFE))
            );
            
      if(this.gun.weight<0.5){
        if(100*(SPACE.time-this.last_coll_t)/FIREFXLIFE  >  1)
          SPACE.d_line(this.gun.unit.position,this.last_coll_p);
        else if(i==0)
          SPACE.d_line(this.gun.unit.position,this.position);
      }else{
        SPACE.d_line(this.position.get_next(-10),this.position.get_next(10));
        break;
      }
    }
    popStyle();
  }
}
