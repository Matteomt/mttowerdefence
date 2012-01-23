/**

 The following development purpose introduction is in italian, sorry.
 
 - Qualcosa a proposito della grafica:
 In questo gioco la grafica è 2D, ma vengono utilizzate delle funzioni personalizzate
 per creare un finto 3D proiettato isometricamente.
 L'asse X coincide con quello della grafica nativa.
 L'asse Y coincide con quello della grafica nativa, ma cresce verso la parte alta dello schermo;
 L'asse Z coincide con l'asse Y, ma e le misure, su di esso, sono dimezzate.
 
 **/


int MAXTOWERS=100;
int MAXENEMYS=500;
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
  
  
  //////////////Test track
  _point_static[] t_points=new _point_static[0];
  t_points=(_point_static[]) append(t_points, new _point_static(100,height/2,0));
  t_points=(_point_static[]) append(t_points, new _point_static(  width/3,height,0));
  t_points=(_point_static[]) append(t_points, new _point_static(2*width/3,0,0));
  t_points=(_point_static[]) append(t_points, new _point_static(width-100,height/2,0));
  
  SPACE.add(new _track(
                t_points,
                true,
                true,
                null,
                10
            ));

}




/*               draw sycle                */
/////////////////////////////////////////////
void draw() {                              //
  background(BACKGROUND_C);                //
  SPACE.draw();                            //
}                                          //
/////////////////////////////////////////////
