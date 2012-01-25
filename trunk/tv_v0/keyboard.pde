/*  checkKey
from http://wiki.processing.org/w/Multiple_key_presses :

Modified version of Option 1 multiplekeys (should provide improved performance and accuracy)
@author Yonas Sandbæk http://seltar.wliia.org (modified by jeffg)
*/
 
// usage: 
// if(checkKey(KeyEvent.VK_CONTROL) && checkKey(KeyEvent.VK_S)) println("CTRL+S");  
 
boolean[] keys = new boolean[526];
boolean checkKey(int k){
  if (keys.length > k) return keys[k];
  return false;
}
void keyReleased(){
//  GUI.keyReleased();
  keys[keyCode] = false; 
}
void keyPressed(){
//  GUI.keyReleased();
  keys[keyCode] = true;
}
