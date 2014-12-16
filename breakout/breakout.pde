float ballX = 300, ballY = 300, ballDirection = random(1, 358), ballSpeed = 1.9, padDiff, yDiff, xDiff;
int paddleX = 300;
block[][] blocks = new block[15][5];
int i; 
int k;
void setup() {
  size(1000, 400);
  noCursor();
  for (i = 0; i < blocks.length; i ++) {
    for (k = 0; k < blocks[i].length; k ++) {
      blocks[i][k] = new block((i+38)+i*65, (k+75)+k*35);
    }
  }
}

void draw() {
  background(100);
  for (i = 0; i < blocks.length; i ++) {
    for (k = 0; k < blocks[i].length; k ++) {
      blocks[i][k].display();
    }
  }
  fill(255);
  ball();
  paddle();
  checkCollide();
  checkBreak();
}

void checkCollide() {
  if (ballX >= 993) {
    if (ballDirection > 0 && ballDirection < 90) {
      ballDirection += 90;
    } else if (ballDirection > 270 && ballDirection < 360) {
      ballDirection -= 90;
    }
  } else if (ballX <= 7) {
    if (ballDirection > 180 && ballDirection < 270) {
      ballDirection += 90;
      ballSpeed += .1;
    } else if (ballDirection > 90 && ballDirection < 180) {
      ballDirection -= 90;
      ballSpeed += .1;
    }
  }
  if (ballY <= 7) {
    ballDirection = 90;
    //    if (ballDirection > 180 && ballDirection < 270) {
    //      ballDirection-=90; 
    //      ballSpeed += .1;
    //    } else if (ballDirection > 270 && ballDirection < 360) {
    //      ballDirection -=270;
    //      ballSpeed += .1;
    //    }
  }
  if (ballY >= 377) {
    if (ballX > mouseX-45 && ballX <= mouseX+45) {
      ballDirection = 270;
    }
  }
  if (ballY > 390) {
    noLoop();
    fill(250);
    textSize(64);
    textAlign(CENTER, CENTER);
    fill(0);
    text("Game Over", 500, 150);
  }
}

void ball() {
  ballX = ballX + cos(radians(ballDirection)) * ballSpeed;
  ballY = ballY + sin(radians(ballDirection)) * ballSpeed;
  ellipseMode(CENTER);
  ellipse(ballX, ballY, 15, 15);
}

void paddle() {
  rectMode(CENTER);
  rect(mouseX, 390, 90, 10);
}

void reset() {
  ballX = 300;
  ballY = 150;
  ballSpeed = 1;
  ballDirection = random(1, 358);
}
void checkBreak() {
  for (i = 0; i < blocks.length; i ++) {
    for (k = 0; k < blocks[i].length; k ++) {
      int blockY = blocks[i][k].getY();
      int blockX = blocks[i][k].getX();
      if (ballX < blockX + 30 && ballX > blockX - 30) {
        if (ballY <= blockY + 22) {
          blocks[i][k].collide();
          println("collided");
          ballDirection = 90;
        } else if (ballY >= blockY - 22) {
          blocks[i][k].collide();
          println("collided");
          ballDirection = 270;
        }
      }
    }
  }
}

