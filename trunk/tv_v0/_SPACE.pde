class _SPACE {
  boolean alternateFrame=true;
  int time;
  float fps;
  _track tracks[];
  _unit units[];
  int enemys=0;

  _SPACE() {
    this.time();
    this.tracks=new _track[0];
    this.units=new _unit[0];
  }
  int time(){
    this.time=100+millis();
    
    if(fps>30){
      if(this.time%80<40) this.alternateFrame=true;
      else this.alternateFrame=false;
    }else this.alternateFrame=!this.alternateFrame;
    
    return this.time;
  }

  _error add(_unit adding) {

    if (adding.enemy && ++enemys>MAXENEMYS) {
      enemys--;
      return new _error(1, "Too many enemys");
    } 
    else
      if (!adding.enemy && this.units.length-enemys>MAXTOWERS) {
        return new _error(1, "Too many towers");
      }

    int j;
    for (j=0;j<this.units.length;j++) {
      if (this.units[j].life<=0 && (this.time-this.units[j].damage)>DEBRISLIFE) { //if tower is not existing in any form (neither debris)
        adding.id=j;
        this.units[j]=adding;
        return new _error(0);
      }
    }
    if (j==this.units.length) {
      adding.id=j; //last position index
      this.units = (_unit[]) append(this.units, adding);
      return new _error(0);
    }
    return new _error(2);
  }

  _error add(_track adding){
    this.tracks= (_track[]) append(this.tracks, adding);
        
    return new _error(0);
  }



  int level=1;
  int last_emit_t;
  int emit_count=0;
  
  void wave(){
    _unit u; _track tr;
    if(this.emit_count<10 && SPACE.time-this.last_emit_t > 1000){
      this.last_emit_t=SPACE.time;
      this.emit_count++;
      for(int i=0; i<this.tracks.length; i++){
        tr=SPACE.tracks[i];
        if(!tr.beginning)
          continue;
          
        tr.add(u=new _unit( true,
                          new _point(tr.points[0]),
                          3,
                          3,
                          0.1,
                          100*this.level*this.level
                        ),true);
        u.add(new _gun(0.4, 0, 200, 100, 1, 500));
        
      }
    }
    else if(this.emit_count==10){
      this.emit_count=0;
      this.last_emit_t=SPACE.time+10000;
      this.level++;
    }
  }




  /* * * * * DRAWING FUNCTIOSN  * * * * */
  
  void d_line(_point p0, _point pf) {
    line(p0.x2D, p0.y2D, pf.x2D, pf.y2D);
  }
  void d_point(_point p) {
    point(p.x2D, p.y2D);
  }
  void d_ellipse(_point p, float rx, float ry) {
    ellipse(p.x2D, p.y2D, rx, ry);
  }
  void d_text(String t, _point p){
    text(t, p.x2D, p.y2D);
  }


  void draw() {
    this.fps=this.time;
    this.time();
    this.fps=1000./(this.time-this.fps);
    this.wave();
    
    
    // -- draw TRACKS
    
    pushStyle();
    noFill();
    stroke(0x20A538FF);
    strokeCap(ROUND);
    bezierDetail(50);
    
    _track tr;
    for(int i=0;i<this.tracks.length;i++){
      tr=this.tracks[i];
      if(this.tracks[i].beginning){
        for(int r=1;r<8;r++){
          strokeWeight(r*5);
          beginShape();
          vertex(tr.points[0].x2D,tr.points[0].y2D);
          while(true){
            bezierVertex(  tr.points[1].x2D,tr.points[1].y2D,
                           tr.points[2].x2D,tr.points[2].y2D,
                           tr.points[3].x2D,tr.points[3].y2D   );
            if(!tr.ending && tr.next!=null)
              tr=tr.next;
            else  break;
          }
          endShape();
          tr=this.tracks[i];
        }
      }
      tr.draw();
    }    
    popStyle();
    
    
    
    // -- draw UNITS
    
    for (int i=0;i<this.units.length;i++) {
      if (this.units[i].life>0 || this.time-this.units[i].damage<DEBRISLIFE) { //if tower is existing
        this.units[i].draw();
      }
    }
    
    
    // -- overlays
    text("fps:      "+this.fps,20,30);
    text("livello:  "+this.level,20,50);
    text("n. torri: "+(this.units.length-this.enemys),20,70);
  }
}
