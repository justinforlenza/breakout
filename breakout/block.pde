class block {
  int xpos;
  int ypos;
  int type;
  PImage block;
  block(int _xpos, int _ypos) {
    xpos=_xpos;
    ypos=_ypos;
    int rnd = int(random(0, 100));
    if ( rnd >= 0 && rnd <= 15) {
      block = loadImage("special.png");
      type = 1;
    } else {
      block = loadImage("normal.png");
      type = 0;
    }
  }
  void collide() {
    xpos = 800;
    ypos = 800;
  }
  void display() {
    imageMode(CENTER);
    image(block, xpos, ypos, 100, 40);
  }
}

