import ddf.minim.*;

Minim minim;
AudioPlayer brk;
AudioPlayer pong;
AudioPlayer chnce;

float ballX = 300, ballY = 250, ballSpeed = 1, seconds = 0, score = 0, startTime;
int paddleX = 300, xSpeed = 1, ySpeed = 1, life = 5, currentBuff, isNew, multiplier=1, paddleWidth = 90, BallSize = 15, buffTime;
block[][] blocks = new block[9][4];

void setup() {
  size(1000, 400);
  noCursor();
  minim = new Minim(this);
  brk = minim.loadFile("break.wav");
  pong = minim.loadFile("pong.wav");
  chnce = minim.loadFile("chance.wav");
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
  } else if (ballX <= BallSize/2) {
    xSpeed = -xSpeed;
    pong.rewind();
    pong.play();
  }
  if (ballY <= BallSize/2) {
    ySpeed = -ySpeed;
    pong.rewind();
    pong.play();
  }
  if (ballY >= (height-15)-(BallSize/2)) {
    if (ballX >= mouseX && ballX <= mouseX+(paddleWidth/2)) {
      xSpeed = 1;
      ySpeed = -1;
      pong.rewind();
      pong.play();
    } 
    if (ballX > mouseX-(paddleWidth/2) && ballX < mouseX) {
      xSpeed = -1;
      ySpeed = -1;
      pong.rewind();
      pong.play();
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
  ellipse(ballX, ballY, BallSize, BallSize);
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
        if (ballX <= blockX + (50 + (BallSize/2)) && ballX >= blockX - (50 + (BallSize/2)) && blocks[i][k].display != 1) {
          if (ballY <= blockY + (20 + (BallSize/2)) && ballY >= blockY + 20) {
            blocks[i][k].collide();
            ySpeed = -ySpeed;
            ballSpeed += .025;
            seconds = millis();
            brk.rewind();
            brk.play();
            score += multiplier * 15;
            if (blocks[i][k].type == 1) {
              buffChange();
            }
            break;
          } else if (ballY <= blockY - 20 && ballY >= blockY - (20 + (BallSize/2)) && blocks[i][k].display != 1) {
            blocks[i][k].collide();
            ySpeed = -ySpeed;
            ballSpeed += .025;
            seconds = millis();
            brk.rewind();
            brk.play();
            score += multiplier * 15;
            if (blocks[i][k].type == 1) {
              buffChange();
            }
            break;
          }
        }
        if (ballY <= blockY + 20 && ballY >= blockY - 20 && blocks[i][k].display != 1) {
          if (ballX <= blockX + (50 + (BallSize/2)) && ballX >= blockX + 50) {
            blocks[i][k].collide();
            xSpeed = -xSpeed;
            ballSpeed += .025;
            seconds = millis();
            brk.rewind();
            brk.play();
            score += multiplier * 15;
            if (blocks[i][k].type == 1) {
              buffChange();
            }
            break;
          } else if (ballX >= blockX - (50 + (BallSize/2)) && ballX <= blockX - 50 && blocks[i][k].display != 1) {
            blocks[i][k].collide();
            xSpeed = -xSpeed;
            ballSpeed += .025;
            seconds = millis();
            brk.rewind();
            brk.play();
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
      BallSize = 15;
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
  chnce.rewind();
  chnce.play();
  if(currentBuff == 2){
   ballSpeed = ballSpeed /2; 
  }
  multiplier = 1;
  BallSize = 15;
  buffTime = int(random(10, 20));
  int rnd = int(random(0, 100));
  if (rnd >= 0 && rnd < 20) {
    currentBuff = 1;
    isNew = 1;
    textAlign(CENTER, CENTER);
    fill(255);
    text("Get DOUBLE Points for the next " + buffTime + "seconds!", 500, 200);
    text("Press Space to continue", 500, 250);
    noLoop();
  } else if (rnd >= 20 && rnd < 40 && currentBuff != 2) {
    currentBuff = 2;
    isNew = 1;
    textAlign(CENTER, CENTER);
    fill(255);
    text("Ball speed is increased for the next "+ buffTime + "seconds!", 500, 200);
    text("Press Space to continue", 500, 250);
    noLoop();
  } else if (rnd >= 40 && rnd < 60) {
    currentBuff = 3;
    textAlign(CENTER, CENTER);
    fill(255);
    text("Paddle Size has been decreased!", 500, 200);
    text("Press Space to continue", 500, 250);
    noLoop();
  } else if (rnd >= 60 && rnd < 80) {
    currentBuff = 4;
    isNew = 1;
    textAlign(CENTER, CENTER);
    fill(255);
    text("Ball size has been increased for the next " + buffTime + "seconds!", 500, 200);
    text("Press Space to continue", 500, 250);
    noLoop();
  } else if (rnd >= 80 && rnd < 100) {
    currentBuff = 5;
    textAlign(CENTER, CENTER);
    fill(255);
    text("Recieve 1 Life!", 500, 200);
    text("Press Space to continue", 500, 250);
    noLoop();
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
    if ( startTime + (buffTime * 1000) < millis()) {
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
    if ( startTime + (buffTime * 1000) < millis()) {
      currentBuff = 0;
      isNew = 2;
      ballSpeed = ballSpeed/2;
    }
  } else if (currentBuff == 3) {
    paddleWidth -= 10;
    currentBuff = 0;
    isNew = 2;
  } else if (currentBuff == 4 && isNew == 1) {
    startTime = millis();
    isNew = 0;
    BallSize += 15;
  } else if (currentBuff == 4 && isNew == 0) {
    textAlign(CENTER, CENTER);
    fill(255);
    text("Buff:" + (millis() - startTime)/1000, 100, 25);  
    if ( startTime + (buffTime * 1000) < millis()) {
      currentBuff = 0;
      isNew = 2;
      BallSize = 15;
    }
  } else if (currentBuff == 5) {
    life = life + 1;
    currentBuff = 0;
    isNew = 2;
  }
}

