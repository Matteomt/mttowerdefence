/**

 The following development purpose introduction is in italian, sorry.
 
 - Qualcosa a proposito della grafica:
 In questo gioco la grafica è 2D, ma vengono utilizzate delle funzioni personalizzate
 per creare un finto 3D proiettato isometricamente.
 L'asse X coincide con quello della grafica nativa.
 L'asse Y coincide con quello della grafica nativa, ma cresce verso la parte alta dello schermo;
 L'asse Z coincide con l'asse Y, ma e le misure, su di esso, sono dimezzate.
 
 **/


int MAXTOWERS=500;
int MAXENEMYS=1000;
int MAXFIRES=100;
int DEBRISLIFE=3000;
int FIREFXLIFE=750;
float FIREUNPRECISION=1;
float CHECKRANGE=50;
float MINVISIBLELIGHT=0.05;
int BACKGROUND_C=0;
float UNITSPEED=1;


_SPACE SPACE;
_GUI GUI;


/* ******************************************************************************************** */


void setup() {
  size(1280, 720);
  colorMode(HSB, 360, 100, 100, 100);
  background(0);
  smooth();
  delay(50);
  SPACE=new _SPACE();
  GUI=new _GUI();
  delay(1000);
  
  
  //////////////Test tracks
  _point_static[] t_points=new _point_static[0];
  _track tr;
  t_points=(_point_static[]) append(t_points, new _point_static(531,472,0));
  t_points=(_point_static[]) append(t_points, new _point_static(991,935,0));
  t_points=(_point_static[]) append(t_points, new _point_static(1261,27,0));
  t_points=(_point_static[]) append(t_points, new _point_static(749,239,0));
  SPACE.add(tr=new _track( t_points, false, true, null, 30 ));
  
  t_points=new _point_static[0];
  t_points=(_point_static[]) append(t_points, new _point_static(-39,152,0));
  t_points=(_point_static[]) append(t_points, new _point_static(477,-33,0));
  t_points=(_point_static[]) append(t_points, new _point_static(270,212,0));
  t_points=(_point_static[]) append(t_points, new _point_static(531,472,0));
  SPACE.add(new _track( t_points, true, false, tr, 30 ));
  
  t_points=new _point_static[0];
  t_points=(_point_static[]) append(t_points, new _point_static(547,749,0));
  t_points=(_point_static[]) append(t_points, new _point_static(113,511,0));
  t_points=(_point_static[]) append(t_points, new _point_static(131, 73,0));
  t_points=(_point_static[]) append(t_points, new _point_static(531,472,0));
  SPACE.add(new _track( t_points, true, false, tr, 30 ));

}




/*               draw sycle                */
/////////////////////////////////////////////
void draw() {                              //
  background(BACKGROUND_C);                //
  SPACE.draw();                            //
}                                          //
/////////////////////////////////////////////
