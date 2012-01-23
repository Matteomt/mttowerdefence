class _point {
  //general purpose 3D point - with 2-derivative moving functions
  
  float x,   y,   z;       //position (now)
  float x0,  y0,  z0;      //start (position 0)
  float xs,  ys,  zs;      //speed (first derivative of position)
  float xs2, ys2, zs2;   //acceleration (second derivative of position)
  float speed=0;         //vectorial xs+ys+zs
  float speed2=0;        //vectorial xs2+ys2+zs2
  int start=0;           //t0 (time at the beginning of the moving)
  float x2D, y2D;        //position of the point on the screen
  
  
  _point(float x, float y, float z) {
    this.set(x, y, z);
  }
  _point(_point p) {
    this.set(p.x,p.y,p.z);
  }
  void set(_point p) {
    this.set(p.x,p.y,p.z);
  }
  void set(float xx, float yy, float zz) {
    this.x=xx;
    this.y=yy;
    this.z=zz;
    this.x2D=x;   
    this.y2D=height-(y+z/2);
  }
  
  
  void motion_set(float xs, float ys, float zs){
    this.motion_set(xs,       ys,       zs,
                  this.xs2, this.ys2, this.zs2);
  }
  void motion_set(float xs, float ys, float zs, float xs2, float ys2, float zs2){
    this.x0=this.x;     this.y0=this.y;     this.z0=this.z;
    this.xs=xs;         this.ys=ys;         this.zs=zs;
    this.xs2=xs2;       this.ys2=ys2;       this.zs2=zs2;
    this.start=SPACE.time;
    this.speed=sqrt(xs*xs + ys*ys + zs*zs);
    this.speed2=sqrt(xs2*xs2 + ys2*ys2 + zs2*zs2);
  }
  
  void motion_add(float xs, float ys, float zs){
    this.motion_set(   this.xs  + xs,        this.ys  + ys,         this.zs  + zs,
                       0            ,        0            ,         0                 );
  }
  void motion_add(float xs, float ys, float zs, float xs2, float ys2, float zs2){
    this.motion_set(   this.xs  + xs,        this.ys  + ys,         this.zs  + zs,
                       this.xs2 + xs2,       this.ys2 + ys2,        this.zs2 + zs2    );
  }
  
  
  void speed_mul(float mul){
    this.speed_mul(mul,1);
  }
  void speed_mul(float mul,float mul2){
    this.motion_set( this.xs *mul,  this.ys *mul,  this.zs *mul,
                     this.xs2*mul2, this.ys2*mul2, this.zs2*mul2 );
  }
  
  
  void move(){
    this.move(0);
  }
  void move(int t_offset){
    if(start==0)return;
    this.set(
      this.x0 + this.xs*(t_offset+SPACE.time-this.start) + .5*this.xs2*sq(t_offset+SPACE.time-this.start),
      this.y0 + this.ys*(t_offset+SPACE.time-this.start) + .5*this.ys2*sq(t_offset+SPACE.time-this.start),
      this.z0 + this.zs*(t_offset+SPACE.time-this.start) + .5*this.zs2*sq(t_offset+SPACE.time-this.start)
    );
  }
  void move(int t_offset, boolean refresh_speed){
    this.speed =sqrt(xs*xs + ys*ys + zs*zs);
    this.speed2=sqrt(xs2*xs2 + ys2*ys2 + zs2*zs2);
    this.move(0);
  }
  
  
  _point get_next(int t_offset){
    _point p=new _point(this.x,this.y,this.z);
    p.motion_set(this.xs,this.ys,this.zs);
    p.move(t_offset);
    return p;
  }
  
  
  _point adjust(float offset_x, float offset_y, float offset_z){
    _point p=new _point(
                        this.x+offset_x,
                        this.y+offset_y,
                        this.z+offset_z
                       );
    return p;
  }
  
  
  float distance_from(_point p) {
    return sqrt(sq(this.x-p.x)+sq(this.y-p.y)+sq(this.z-p.z));
  }
  
  
  /*
    collision with line AB; c is AB distance;
    vedi formula di Erone per comprendere i calcoli;
    return: float{overshot(d: distance from A of this point after projection on AB), centration (h/margin)}
  */
  float[] collision_check(_point A, _point B, float c, float margin) {
    float a,b,d,h2;
    float r[]=new float[2];
    margin*=margin; //margin = margin ^ 2 !!!!
    
    a = this.distance_from(A);
    b = this.distance_from(B);
    d = (a*a + c*c - b*b) / (2*c);
    h2= a*a - d*d;
    
    r[0]=d;
    r[1]=h2/margin;
    
    //collision position adjust:
    if(h2<margin)r[0]+=sqrt(margin-h2);
    
    return r;
  }
  
  void move_on(float d){
    this.set(this.adjust(
                          d*this.xs/this.speed,
                          d*this.ys/this.speed,
                          d*this.zs/this.speed
                        ));
  }
}
