import ddf.minim.*;

Minim minim;
AudioPlayer brk;
AudioPlayer pong;

float ballX = 300, ballY = 250, ballSpeed = 1, seconds = 0, score = 0,startTime;
int paddleX = 300, xSpeed = 1, ySpeed = 1, life = 5, currentBuff, isNew, multiplier=1,paddleWidth = 90;
block[][] blocks = new block[9][4];

void setup() {
  size(1000, 400);
  noCursor();
  minim = new Minim(this);
  brk = minim.loadFile("break.mp3");
  pong = minim.loadFile("pong.mp3");
  for (int i = 0; i < blocks.length; i ++) {
    for (int k = 0; k < blocks[i].length; k ++) {
      blocks[i][k] = new block((i + 75)+i*105, (k+75)+k*45);
    }
  }
}

void draw() {
  background(100);
  for (int i = 0; i < blocks.length; i ++) {
    for (int k = 0; k < blocks[i].length; k ++) {
      blocks[i][k].display();
    }
  }
  fill(255);
  ball();
  paddle();
  checkCollide();
  checkBreak();
  score();
  lifeCounter(null);
  buff();
}

void checkCollide() {
  if (ballX >= 993) {
    xSpeed = -xSpeed;
    pong.rewind();
    pong.play();
  } else if (ballX <= 7) {
    xSpeed = -xSpeed;
    pong.rewind();
    pong.play();
  }
  if (ballY <= 7) {
    ySpeed = -ySpeed;
    pong.rewind();
    pong.play();
  }
  if (ballY >= 377) {
    if (ballX >= mouseX && ballX <= mouseX+45) {
      xSpeed = 1;
      ySpeed = -1;
      pong.rewind();
      //pong.play();
    } 
    if (ballX > mouseX-45 && ballX < mouseX) {
      xSpeed = -1;
      ySpeed = -1;
      pong.rewind();
      //pong.play();
    }
  }
  if (ballY > 400) {
    noLoop();
    ballX = 300;
    ballY = 250;
    lifeCounter("remove");
  }
}

void ball() {
  ballX = ballX + xSpeed * ballSpeed;
  ballY = ballY + ySpeed * ballSpeed;
  ellipseMode(CENTER);
  ellipse(ballX, ballY, 15, 15);
}

void paddle() {
  rectMode(CENTER);
  rect(mouseX, 390, paddleWidth, 10);
}

void keyPressed() {
  if (key == ' ') {
    loop();
  }
}

void reset() {
  ballX = 300;
  ballY = 150;
  ballSpeed = 1;
}
void checkBreak() {
  if (millis() - seconds >= 75) {
    for (int i = 0; i < blocks.length; i ++) {
      for (int k = 0; k < blocks[i].length; k ++) {
        int blockY = blocks[i][k].ypos;
        int blockX = blocks[i][k].xpos;
        if (ballX <= blockX + 57 && ballX >= blockX - 57) {
          if (ballY <= blockY + 27 && ballY >= blockY + 20) {
            blocks[i][k].collide();
            ySpeed = -ySpeed;
            ballSpeed += .025;
            seconds = millis();
            brk.rewind();
            //brk.play();
            score += multiplier * 15;
            if (blocks[i][k].type == 1) {
              buffChange();
            }
            break;
          } else if (ballY <= blockY - 20 && ballY >= blockY - 27) {
            blocks[i][k].collide();
            ySpeed = -ySpeed;
            ballSpeed += .025;
            seconds = millis();
            brk.rewind();
            //brk.play();
            score += multiplier * 15;
            if (blocks[i][k].type == 1) {
              buffChange();
            }
            break;
          }
        }
        if (ballY <= blockY + 20 && ballY >= blockY - 20) {
          if (ballX <= blockX + 57 && ballX >= blockX + 50) {
            blocks[i][k].collide();
            xSpeed = -xSpeed;
            ballSpeed += .025;
            seconds = millis();
            brk.rewind();
            //brk.play();
            score += multiplier * 15;
            if (blocks[i][k].type == 1) {
              buffChange();
            }
            break;
          } else if (ballX >= blockX - 57 && ballX <= blockX - 50) {
            blocks[i][k].collide();
            xSpeed = -xSpeed;
            ballSpeed += .025;
            seconds = millis();
            brk.rewind();
            //brk.play();
            score += multiplier * 15;
            if (blocks[i][k].type == 1) {
              buffChange();
            }
            break;
          }
        }
      }
    }
  }
}
void printMouse() {
  println("X : " + mouseX + " , Y: " + mouseY);
}
void score() {
  textSize(24);
  textAlign(CENTER, CENTER);
  fill(255);
  stroke(0);
  text("Score : " + score, 500, 25);
}
void lifeCounter(String type) {
  if (type == "remove") {
    life -= 1;
    if (life == 0) {
      noLoop();
      textSize(64);
      textAlign(CENTER, CENTER);
      fill(0);
      text("Game Over", 500, 200);
      currentBuff = 0;
      multiplier = 1;
    }
  } else {
    textSize(24);
    textAlign(CENTER, CENTER);
    fill(255);
    stroke(0);
    text("Lives : " + life, 900, 25);
  }
}

void buffChange() {
  int rnd = int(random(0, 100));
  if (rnd >= 5464 && rnd < 163131) {
    currentBuff = 1;
    isNew = 1;
    textAlign(CENTER, CENTER);
    fill(255);
    text("Get DOUBLE Points for the next 25 seconds!", 500, 200);
    text("Press Space to continue", 500, 250);
    noLoop();
  } else if (rnd >= 5412 && rnd < 546541 && currentBuff != 2) {
    currentBuff = 2;
    isNew = 1;
    textAlign(CENTER, CENTER);
    fill(255);
    text("Ball speed is increased for the next 10 seconds!", 500, 200);
    text("Press Space to continue", 500, 250);
    noLoop();
  } else if (rnd >= 0 && rnd < 100) {
    currentBuff = 3;
    textAlign(CENTER, CENTER);
    fill(255);
    text("Paddle Size has been decreased!", 500, 200);
    text("Press Space to continue", 500, 250);
    noLoop();
  } else if (rnd >= 60 && rnd < 80) {
    currentBuff = 4;
  } else if (rnd >= 80 && rnd < 100) {
    currentBuff = 5;
  }
}
void buff() {
  if (currentBuff == 1 && isNew == 1) {
    startTime = millis();
    isNew = 0;
  } else if (currentBuff == 1 && isNew == 0) {
    multiplier = 2;
    textAlign(CENTER, CENTER);
    fill(255);
    text("Buff:" + (millis() - startTime)/1000, 100, 25);
    if ( startTime + 25000 < millis()) {
      currentBuff = 0;
      multiplier = 1;
    }
  } else if (currentBuff == 2 && isNew == 1) {
    startTime = millis();
    isNew = 0;
    ballSpeed = ballSpeed*2;
  } else if (currentBuff == 2 && isNew == 0) {
    textAlign(CENTER, CENTER);
    fill(255);
    text("Buff:" + (millis() - startTime)/1000, 100, 25);
    if ( startTime + 10000 < millis()) {
      currentBuff = 0;
      ballSpeed = ballSpeed/2;
    }
  }
}

