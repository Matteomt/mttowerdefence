class _GUI{
  _unit building_u;
  _point building_p;
  
  boolean mouseLeft=false;
  int mouseLeftX0=0;
  int mouseLeftY0=0;
  int mouseLeftX1=0;
  int mouseLeftY1=0;
  boolean mouseRight=false;
  int mouseRightX0=0;
  int mouseRightY0=0;
  int mouseRightX1=0;
  int mouseRightY1=0;
  boolean mouseCenter=false;
  int mouseCenterX0=0;
  int mouseCenterY0=0;
  int mouseCenterX1=0;
  int mouseCenterY1=0;
  
  _GUI(){
  }
  void click(){
      this.building_p=new _point(mouseX,height-mouseY,0);
      this.building_u=new _unit( false,
                            this.building_p,
                            6,
                            0,
                            0,
                            20000
                          );
      this.building_u.add(new _gun(0.001, 1, 200, 50, .49, 40));
      
                      
      SPACE.add(this.building_u);
  }
}  


void mousePressed() {
  if(mouseButton==LEFT){
    GUI.mouseLeft=true;
    GUI.mouseLeftX0=mouseX;
    GUI.mouseLeftY0=mouseY;
  }
  if(mouseButton==RIGHT){
    GUI.mouseRight=true;
    GUI.mouseRightX0=mouseX;
    GUI.mouseRightY0=mouseY;
  }
  if(mouseButton==CENTER){
    GUI.mouseCenter=true;
    GUI.mouseCenterX0=mouseX;
    GUI.mouseCenterY0=mouseY;
  }
}
void mouseReleased() {
  if(mouseButton==LEFT){
    GUI.mouseLeft=false;
    GUI.mouseLeftX1=mouseX;
    GUI.mouseLeftY1=mouseY;
  }
  if(mouseButton==RIGHT){
    GUI.mouseRight=false;
    GUI.mouseRightX1=mouseX;
    GUI.mouseRightY1=mouseY;
  }
  if(mouseButton==CENTER){
    GUI.mouseCenter=false;
    GUI.mouseCenterX1=mouseX;
    GUI.mouseCenterY1=mouseY;
  }
}
void mouseClicked(){
  GUI.click();
}
