class block {
 int xpos;
 int ypos;
 int state = 0;
 color[] states = {color(0,0,255),color(0,255,0),color(255,255,0),color(255,102,0),color(255,0,0),color(0,0,0)};
 block(int _xpos, int _ypos){
  xpos=_xpos;
  ypos=_ypos;
 }
 void collide(){
  if(state < 2){
   state ++;
  } else {
   xpos = 800;
   ypos = 800;
  }
 }
 void display(){
  fill(states[state]);
  rectMode(CENTER);
  rect(xpos,ypos,100,40); 
 }
}

