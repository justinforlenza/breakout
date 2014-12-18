float ballX = 300, ballY = 250, ballSpeed = 1;
int paddleX = 300, xSpeed = 1, ySpeed = 1;
block[][] blocks = new block[9][4];
void setup() {
  size(1000, 400);
  noCursor();
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
}

void checkCollide() {
  if (ballX >= 993) {
    xSpeed = -xSpeed;
  } else if (ballX <= 7) {
    xSpeed = -xSpeed;
  }
  if (ballY <= 7) {
    ySpeed = -ySpeed;
  }
  if (ballY >= 377) {
    if (ballX > mouseX-45 && ballX <= mouseX+45) {
      ySpeed = -ySpeed;
    }
  }
  if (ballY > 390) {
    noLoop();
    textSize(64);
    textAlign(CENTER, CENTER);
    fill(0);
    text("Game Over", 500, 200);
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
  rect(mouseX, 390, 90, 10);
}

void reset() {
  ballX = 300;
  ballY = 150;
  ballSpeed = 1;
  ballDirection = random(1, 358);
}
void checkBreak() {
  for (int i = 0; i < blocks.length; i ++) {
    for (int k = 0; k < blocks[i].length; k ++) {
      int blockY = blocks[i][k].getY();
      int blockX = blocks[i][k].getX();
      if (ballX <= blockX + 57 && ballX >= blockX - 57) {
        if (ballY <= blockY + 27 && ballY >= blockY + 20) {
          blocks[i][k].collide();
          ySpeed = -ySpeed;
          ballSpeed += .025;
        } else if (ballY <= blockY - 20 && ballY >= blockY - 27) {
          blocks[i][k].collide();
          ySpeed = -ySpeed;
          ballSpeed += .025;
        }
      } else if (ballY <= blockY + 27 && ballY >= blockY - 27) {
        if (ballX <= blockX + 57 && ballX >= blockX + 50) {
          blocks[i][k].collide();
          xSpeed = -xSpeed;
          ballSpeed += .025;
        } else if (ballX >= blockX - 57 && ballX <= blockX - 50) {
          blocks[i][k].collide();
          xSpeed = -xSpeed;
          ballSpeed += .025;
        }
      }
    }
  }
}

