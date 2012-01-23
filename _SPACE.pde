class _SPACE {
  int time;
  _unit units[];
  int enemys=0;

  _SPACE() {
    this.time();
  }
  int time(){
    this.time=100+millis();
    return this.time;
  }

  _error add(_unit adding) {
    if (this.units==null) {
      units=new _unit[1];
      adding.id=0;
      units[0]=adding;
      return new _error(0);
    }

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
      if (this.units[j].life<=0 && this.units[j].damage>DEBRISLIFE) { //if tower is not existing in any form (neither debris)
        adding.id=j;
        this.units[j]=adding;
        return new _error(0);
      }
    }
    if (j==this.units.length) {
      adding.id=j; //last position index
      this.units = (_unit[]) append(this.units, adding);
    }
    return new _error(2);
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
    this.time();
    for(int i=0;i<this.tracks.length;i++){
      this.tracks[i].draw();
    }
    for (int i=0;i<this.units.length;i++) {
      if (this.units[i].life>0 || this.time-this.units[i].damage<DEBRISLIFE) { //if tower is existing
        this.units[i].draw();
      }
    }
  }
}
