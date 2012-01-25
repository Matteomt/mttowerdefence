class _track {
  int level;
  _track next;
  _point_static points[];
  _unit units[];
  boolean beginning;
  boolean ending;
  
  int last_emit_t;
  int emit_count=0;
  
  _track(_point_static points[],boolean beginning, boolean ending, _track next, int level){
    this.next=next;
    this.level=level;
    this.beginning=beginning;
    this.ending=ending;
    this.units=new _unit[0];
    this.points=points;
    this.last_emit_t=SPACE.time;
  }
  
  void wave(){
    _unit u;
    if(this.emit_count<10 && SPACE.time-this.last_emit_t > 1500){
      this.last_emit_t=SPACE.time;
      this.emit_count++;
      this.add(u=new _unit( true,
                        new _point(points[0]),
                        3,
                        3,
                        0.1,
                        100*this.level*this.level
                      ), true);
      u.add(new _gun(0.4, 0, 200, 2, 1, 500));
    }
    else if(this.emit_count==10){
      this.emit_count=0;
      this.last_emit_t=SPACE.time+10000;
      level++;
    }
  }
  
  void add(_unit u){
    this.add(u,false);
  }
  void add(_unit u, boolean neww){
    if(!neww || ( neww && SPACE.add(u).level==0 )){
      this.units = ( _unit[] ) append(this.units,u);
    }
    u.position.motion_set_cubic_bezier(points,u.speed,50,0,1,1,this.ending?1.2:0);
  }
  
  void end(int index,_unit u){
    if(this.ending){
      u.delete(500);
      u.position.motion_add(0,0,0,-2,-2,0);
      println(u.id+": ended");
    }
    else{
      this.next.add(u);
    }
    this.remove(index);
  }
  void remove(int index){
    _unit[] unew = new _unit[this.units.length-1];
    for(int i=0; i<this.units.length-1; i++)
      unew[i] = this.units[i<index?i:i+1];
    this.units=unew;
  }
  
  void draw(){
    
    if(beginning)this.wave();
    
    
    for(int i=0;i<this.units.length;i++){
      if(this.units[i].life>0 && this.units[i].position.distance_from(this.points[this.points.length-1]) < (this.ending?70:1)+25*this.units[i].position.speed)
        this.end(i, this.units[i]);
    }
    
    
    pushStyle();
    noFill();
    stroke(100);
    
    beginShape();
    vertex(this.points[0].x2D, this.points[0].y2D);
    for(int i=0;i+3<this.points.length;i+=3){
      bezierVertex( this.points[i+1].x2D, this.points[i+1].y2D,
                    this.points[i+2].x2D, this.points[i+2].y2D,
                    this.points[i+3].x2D, this.points[i+3].y2D  );
    }
    endShape();
    
    popStyle();
  }
}
