class _track {
  _track next;
  _point_static points[];
  _unit units[];
  boolean beginning;
  boolean ending;
  
  
  _track(_point_static points[],boolean beginning, boolean ending, _track next){
    this.next=next;
    this.beginning=beginning;
    this.ending=ending;
    this.units=new _unit[0];
    this.points=points;
  }
  
  void add(_unit u){
    this.add(u,false);
  }
  void add(_unit u, boolean neww){
    if(!neww || ( neww && SPACE.add(u).level==0 )){
      this.units = ( _unit[] ) append(this.units,u);
    }
    u.position.motion_set_cubic_bezier(points,u.speed,50,0,1,1,this.ending?0.9:0);
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
       
    for(int i=0;i<this.units.length;i++){
      if(this.units[i].life>0 && this.units[i].position.distance_from(this.points[this.points.length-1]) < (this.ending?50:1)+25*this.units[i].position.speed)
        this.end(i, this.units[i]);
    }
    
    /*
    pushStyle();
    noFill();
    stroke(0x77A538FF);
    strokeCap(ROUND);
    strokeWeight(20);
    
    bezier(  this.points[0].x2D, this.points[0].y2D,
             this.points[1].x2D, this.points[1].y2D,
             this.points[2].x2D, this.points[2].y2D,
             this.points[3].x2D, this.points[3].y2D  );
    
    popStyle(); */
  }
}
