class block {
 int xpos;
 int ypos;
 int state = 0;
 color[] states = {color(0,0,255),color(0,255,0),color(255,255,0),color(255,102,0),color(255,0,0),color(0,0,0)};
 block(int _xpos, int _ypos){
  xpos=_xpos;
  ypos=_ypos;
  int type = int(random(0,100));
  if( type >= 0 && type <= 10){
   block = loadImage("special.png"); 
  } else {
    block = loadImage("normal.png");
  }
 }
 void collide(){
   xpos = 800;
   ypos = 800;
 }
 void display(){
  fill(states[state]);
  rectMode(CENTER);
  rect(xpos,ypos,100,40,10); 
 }
}

