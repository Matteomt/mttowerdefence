class _point_static{
  float x,y,z;
  float x2D,y2D;
  
  _point_static(float x, float y, float z) {
    this.set(x, y, z);
  }
  _point_static(_point_static p) {
    this.set(p.x,p.y,p.z);
  }
  _point_static(_point p) {
    this.set(p.x,p.y,p.z);
  }
  void set(_point_static p) {
    this.set(p.x,p.y,p.z);
  }
  void set(_point p) {
    this.set(p.x,p.y,p.z);
  }
  void set(float xx, float yy, float zz) {
    this.x=xx;
    this.y=yy;
    this.z=zz;
    this.x2D=xx;   
    this.y2D=height-(yy+zz/2);
  }
  float distance_from(_point_static p) {
    return sqrt(sq(this.x-p.x)+sq(this.y-p.y)+sq(this.z-p.z));
  }
  float distance_from(_point p) {
    return sqrt(sq(this.x-p.x)+sq(this.y-p.y)+sq(this.z-p.z));
  }
  _point get_dynamic(){
    _point p=new _point(this.x,this.y,this.z);
    return p;
  }
}
class _point {
  //general purpose 3D point - with 2-derivative moving functions
  
  float x=0,    y=0,    z=0;       //position (now)
  float x0=0,   y0=0,   z0=0;      //start (position 0)
  float xs=0,   ys=0,   zs=0;      //speed (first derivative of position)
  float xs2=0,  ys2=0,  zs2=0;     //acceleration (second derivative of position)
  float xs3=0,  ys3=0,  zs3=0;     //third derivative of position
  float speed=0;                   //vectorial xs+ys+zs
  float speed2=0;                  //vectorial xs2+ys2+zs2
  float speed3=0;                  //vectorial xs3+ys3+zs3
  int start=0;                     //t0 (time at the beginning of the moving)
  float x2D, y2D;                  //position of the point on the screen
  
  
  _point(float x, float y, float z) {
    this.set(x, y, z);
  }
  _point(_point p) {
    this.set(p.x,p.y,p.z);
  }
  _point(_point_static p) {
    this.set(p.x,p.y,p.z);
  }
  void set(_point p) {
    this.set(p.x,p.y,p.z);
  }
  void set(_point_static p) {
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
    this.motion_set(xs      , ys      , zs      ,
                    this.xs2, this.ys2, this.zs2,
                    this.xs3, this.ys3, this.zs3 );
  }
  void motion_set(float xs, float ys, float zs, float xs2, float ys2, float zs2){
    this.motion_set(xs      , ys      , zs      ,
                    xs2     , ys2     , zs2     ,
                    this.xs3, this.ys3, this.zs3 );
  }
  void motion_set(float xs, float ys, float zs, float xs2, float ys2, float zs2, float xs3, float ys3, float zs3){
    this.x0=this.x;     this.y0=this.y;     this.z0=this.z;
    this.xs =xs;        this.ys =ys;        this.zs =zs;
    this.xs2=xs2;       this.ys2=ys2;       this.zs2=zs2;
    this.xs3=xs3;       this.ys3=ys3;       this.zs3=zs3;
    this.start=SPACE.time;
    this.speed =sqrt(xs *xs  + ys *ys  + zs *zs );
    this.speed2=sqrt(xs2*xs2 + ys2*ys2 + zs2*zs2);
    this.speed3=sqrt(xs3*xs3 + ys3*ys3 + zs3*zs3);
  }
    
  void motion_add(float xs, float ys, float zs){
    this.motion_set(   this.xs  + xs,        this.ys  + ys,         this.zs  + zs     );
  }
  void motion_add(float xs, float ys, float zs, float xs2, float ys2, float zs2){
    this.motion_set(   this.xs  + xs,        this.ys  + ys,         this.zs  + zs,
                       this.xs2 + xs2,       this.ys2 + ys2,        this.zs2 + zs2    );
  }
  
  
  void motion_set_cubic_bezier(_point_static[] cp, float speed, float randomnes, float a, float b, float c, float d){
    _point_static[] cpr=new _point_static[0];
    float mul;
    for(int i=0;i<4;i++){
      switch(i){
        case 0: mul=a; break;
        case 1: mul=b; break;
        case 2: mul=c; break;
        default: mul=d;
      }
      if(mul!=0)
        cpr = (_point_static[]) append(cpr, new _point_static(   cp[i].x + mul*randomnes*pow(random(-100.,100.)/100,3),
                                                                 cp[i].y + mul*randomnes*pow(random(-100.,100.)/100,3),
                                                                 cp[i].z  ));
      else
        cpr = (_point_static[]) append(cpr, cp[i]);
    }
    
    this.motion_set_cubic_bezier(cpr, speed);
  }
  void motion_set_cubic_bezier(_point_static[] cp, float speed){
    this.set(cp[0].x, cp[0].y, cp[0].z);
    
    float ax, bx, cx,
          ay, by, cy,
          az, bz, cz,
          len;
    
    cx = 3.0 * (cp[1].x - cp[0].x);
    bx = 3.0 * (cp[2].x - cp[1].x) - cx;
    ax = cp[3].x - cp[0].x - cx - bx;
 
    cy = 3.0 * (cp[1].y - cp[0].y);
    by = 3.0 * (cp[2].y - cp[1].y) - cy;
    ay = cp[3].y - cp[0].y - cy - by;
    
    cz = 3.0 * (cp[1].z - cp[0].z);
    bz = 3.0 * (cp[2].z - cp[1].z) - cz;
    az = cp[3].z - cp[0].z - cz - bz;
    
    len=sqrt(   sqrt(ax*ax+ay*ay+az*az)/3.
              + sqrt(bx*bx+by*by+bz*bz)/2.
              + sqrt(cx*cx+cy*cy+cz*cz)    );
    len/=speed/10;
    
    ax/=len*len*len;  bx/=len*len;  cx/=len;
    ay/=len*len*len;  by/=len*len;  cy/=len;
    az/=len*len*len;  bz/=len*len;  cz/=len;
    
    this.motion_set( cx, cy, cz,
                     bx, by, bz,
                     ax, ay, az );
  }
  
  
  
  
  void speed_mul(float mul){
    this.speed_mul(mul,mul,mul);
  }
  void speed_mul(float mul,float mul2){
    this.speed_mul(mul,mul2,mul2*mul);
  }
  void speed_mul(float mul,float mul2,float mul3){
    this.motion_set( this.xs *mul , this.ys *mul , this.zs *mul ,
                     this.xs2*mul2, this.ys2*mul2, this.zs2*mul2,
                     this.xs3*mul3, this.ys3*mul3, this.zs3*mul3 );
  }
  
  
  void move(){
    this.move(0);
  }
  void move(int t_offset){
    if(this.start==0)return;
    
    float t = t_offset + SPACE.time-this.start;
    float t2 = t*t;
    float t3 = t2*t;
    
    this.set(
      this.x0
        + this.xs  * t
        + this.xs2 * t2
        + this.xs3 * t3,
      this.y0
        + this.ys  * t
        + this.ys2 * t2
        + this.ys3 * t3,
      this.z0
        + this.zs  * t
        + this.zs2 * t2
        + this.zs3 * t3
    );
  }
  void move(int t_offset, boolean refresh_speed){
    this.speed =sqrt(xs *xs  + ys *ys  + zs *zs );
    this.speed2=sqrt(xs2*xs2 + ys2*ys2 + zs2*zs2);
    this.speed3=sqrt(xs3*xs3 + ys3*ys3 + zs3*zs3);
    this.move(0);
  }
  
  
  _point get_next(int t_offset){
    _point p=new _point(this.x,this.y,this.z);
    p.motion_set(this.xs  ,this.ys  ,this.zs  ,
                 this.xs2 ,this.ys2 ,this.zs2 ,
                 this.xs3 ,this.ys3 ,this.zs3 );
    p.move(t_offset);
    return p;
  }
  
  
  _point_static get_static(){
    _point_static p=new _point_static(this.x,this.y,this.z);
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
  float distance_from(_point_static p) {
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
    
    if(c<=0)c=A.distance_from(B);
    if(margin<1.5)margin=1.5;
    
    a = this.distance_from(A); a*=a;
    b = this.distance_from(B);
    d = (a + c*c - b*b) / (2*c);
    h2= a - d*d;
    
    r[0]=d;
    r[1]=h2/margin;
    
    //collision position adjust:
    if(h2<margin)r[0]+=sqrt(margin-h2);
    
    return r;
  }
  
  void move_on(float d){
    this.set(
              this.x  +  d*this.xs/this.speed,
              this.y  +  d*this.ys/this.speed,
              this.z  +  d*this.zs/this.speed
             );
  }
}
