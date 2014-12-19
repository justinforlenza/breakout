import ddf.minim.*;

Minim minim;
AudioPlayer brk;
AudioPlayer pong;

float ballX = 300, ballY = 250, ballSpeed = 1, seconds = 0, score = 0;
int paddleX = 300, xSpeed = 1, ySpeed = 1,life = 5;

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
  lifeCounter("");
  //printMouse();
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
      pong.play();
    } 
    if (ballX > mouseX-45 && ballX < mouseX) {
      xSpeed = -1;
      ySpeed = -1;
      pong.rewind();
      pong.play();
    }
  }
  if (ballY > 400) {
    noLoop();
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
  rect(mouseX, 390, 90, 10);
}

void keyPressed(){
 if (key == ' '){
  loop();
  ballX = 300;
  ballY = 250;
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
            brk.play();
            score += blocks[i][k].state * 15;
            println(score);
            break;
          } else if (ballY <= blockY - 20 && ballY >= blockY - 27) {
            blocks[i][k].collide();
            ySpeed = -ySpeed;
            ballSpeed += .025;
            seconds = millis();
            brk.rewind();
            brk.play();
            score += blocks[i][k].state * 15;
            println(score);
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
            brk.play();
            score += blocks[i][k].state * 15;
            println(score);
            break;
          } else if (ballX >= blockX - 57 && ballX <= blockX - 50) {
            blocks[i][k].collide();
            xSpeed = -xSpeed;
            ballSpeed += .025;
            seconds = millis();
            brk.rewind();
            brk.play();
            score += blocks[i][k].state * 15;
            println(score);
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
void lifeCounter(String type){
 if (type == "remove"){
  life -= 1;
  if (life == 0){
    noLoop();
    textSize(64);
    textAlign(CENTER, CENTER);
    fill(0);
    text("Game Over", 500, 200); 
  }
 } else {
  textSize(24);
  textAlign(CENTER, CENTER);
  fill(255);
  stroke(0);
  text("Lives : " + life, 900, 25);
 }
}

