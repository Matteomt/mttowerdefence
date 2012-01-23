class _unit {
  int id=-1;
  _point position;
  boolean selected=false;
  int tower_flags[]; //0: good shot count

  boolean enemy=false;
  int type;
  float radius;
  float speed;
  float life; //it's the max damage that this tower can get. It's always > 0 when alive. 0 means death.
  float damage=0; //if life<0 -> damage is time of death

  _gun guns[];
  float pointing; //angle

  _unit(boolean enemy, _point position, float radius, int type, float speed, float life) {
    this.enemy=enemy;
    this.position=position;
    this.speed=speed*UNITSPEED;
    this.radius=radius;
    this.type=type;
    this.life=life;
    
    this.guns=new _gun[0];
    
    this.tower_flags=new int[10];
    this.tower_flags[0]=0;

    this.selected=true;
    this.pointing=PI/4;
  }
  void add(_gun g){
    this.guns=(_gun[]) append(this.guns, g);
    this.guns[this.guns.length-1].unit=this;
  }
  
  void delete(int delay){
    this.life=0;
    this.damage = SPACE.time-DEBRISLIFE+min(delay,DEBRISLIFE);
  }

  void hit(float strength,_fire fire) {
    this.damage+=strength;
    if(this.position.start != 0)this.position.start+=fire.gun.weight*fire.gun.delay/10;
    if(damage>=life){
      life=0;
      damage=SPACE.time;
      this.position.motion_add( 0, 0, 0,
                                0, 0, max(0-this.position.z*2,-100.*2)/sq(DEBRISLIFE)
                               );
    }
    
    SPACE.units[fire.gun.unit.id].tower_flags[0]++;
    
    //add fire delay
    //this.fire_last+=this.fdelay/10;
  }
  

  void draw() {
    this.position.move(0);
    
    if(checkKey(KeyEvent.VK_D)){ //debug
      println((this.enemy?"* Enemy":". Tower")+" "+this.id+" ("+this.position.x+", "+this.position.y+") {");
    }
    
    for(int i=0;i<this.guns.length;i++)this.guns[i].draw();    
    
    
    if(checkKey(KeyEvent.VK_D)){ //debug
      println("}");
    }
    

    pushStyle();
    noStroke();
    
    if (this.enemy) {
    // --- ENEMY--------------------------
    
      switch(this.type) {
        default:
          if(this.life<=0)
            fill(0,100,100,(SPACE.time%120>60)?(100-100*sq((SPACE.time-this.damage)/DEBRISLIFE)):0);
          else
            fill(0,100,100,(SPACE.time%80>40)?(100-100*this.damage/this.life):100);
      }
      SPACE.d_ellipse(this.position, 2*this.radius, 2*this.radius);
      
      fill(180,100,100,100);
      SPACE.d_text(this.id+" ",this.position);
      
      
    } else {
    // --- TOWER--------------------------
    
      switch(this.type) {
        default:
          if(this.life<=0)
            fill(120, 20, 100,(SPACE.time%120>60)?(100-100*sq((SPACE.time-this.damage)/DEBRISLIFE)):0);
          else
            fill(120, 20, 100,(SPACE.time%80>40)?(100-100*this.damage/this.life):100);
      }
      SPACE.d_ellipse(this.position, 2*this.radius, 2*this.radius);
      SPACE.d_ellipse(this.position.adjust(0,0,0-this.position.z), 1, 1);
      
      fill(120-180,100,70,100);
      SPACE.d_text(this.id+" ",this.position);
    }
    popStyle();
  }
}
