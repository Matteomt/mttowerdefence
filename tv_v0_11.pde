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


_SPACE SPACE;


/* ******************************************************************************************** */


void setup() {
  size(1280, 720);
  colorMode(HSB, 360, 100, 100, 100);
  background(0);
  smooth();
  delay(50);
  SPACE=new _SPACE();
  delay(50);
  
  
  //////////////Test units
  _unit u;
  for(int i=0;i<3;i++){
      SPACE.add(u=new _unit( false,
                        new _point(width/2-94*i, height/2-300+60*i, 100),
                        30-10*i,
                        0,
                        20000
                      ));
      u.add(new _gun(0.001, i%2==0?0:1, 1000, 15, 0.491, 40));
  }
                      
  for(int i=0;i<7;i++){
      SPACE.add(u=new _unit( true,
                        new _point(width/2+82*i, height/2+200+15*i, 0),
                        3,
                        3,
                        4000
                      ));
      u.add(new _gun(0.4, i%2==0?0:1, 1000, 15, 1, 40));
  }
}




/*               draw sycle                */
/////////////////////////////////////////////
void draw() {                              //
  background(BACKGROUND_C);                //
  SPACE.draw();                            //
}                                          //
/////////////////////////////////////////////
