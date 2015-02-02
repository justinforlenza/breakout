class block {
  int xpos;
  int ypos;
  int type;
  int display;
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
    display = 1;
  }
  void display() {
    if (display != 1) {
      imageMode(CENTER);
      image(block, xpos, ypos, 100, 40);
    }
  }
}

