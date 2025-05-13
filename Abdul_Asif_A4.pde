/***********************
 *     Abdul Asif      *
 *                     *
 *  Abdul_Asif_A4.pde  *
 *                     *
 * ICS 3U1 Assignment  *
 *        #34          *
 *                     *
 * Creating a game of  *
 * Space Invaders in   *
 * Processing using    *
 * arrays, along with  *
 * boolean expressions,*
 * if statements,      *
 * methods, and        *
 * variables           *
 *                     *
 *  January 19, 2023  *
 **********************/
//global variables and boolean expressions
PImage Invader;
PImage Tank;
PFont font;
PImage StartScreen;
PImage WinImage;
PImage LoseImage;
boolean moveTankLeft = false, moveTankRight = false;
boolean canShoot = true;
boolean showLaser = false;
boolean spacePressed = false;
boolean invadersMovingRight = false;
boolean[] invadersDie = new boolean[21]; //array for the number of invaders all together
boolean invaderTouchedRightEdge = false;
boolean invaderTouchedLeftEdge = false;
boolean winGame = false;
boolean loseGame = false;
boolean gameEnds = false;
int time;
int gameScreen = 1; //allows games to switch between different screens
int maxYPositionOfInvader = 0;
int score = 0;
int movementTime;
int delayTimer;
int invaderXSpeed = 3;
int invaderYSpeed = 10;
int tankX = 375;
int tankY = 690;
int maxXPositionOfInvader = 20;//minimum x and maximum x position of the invader before it detects the boundary and goes the other way
int minXPositionOfInvader = 740;
int laserX=  -5; // laser X and Y positions
int laserY=  -5;
int [] invaderX = {140, 215, 290, 365, 440, 515, 590}; // array for the X values of the invader
int [] invaderY = {100, 150, 200}; // array for the Y values of the invader
void setup() {
  size(800, 800);
  //initializes the images and font
  Invader = loadImage("image-removebg-preview (16).png");
  Tank = loadImage("tank.png");
  StartScreen = loadImage ("startscreen.png");
  WinImage = loadImage ("YouWin.png");
  LoseImage = loadImage ("YouLose.jpeg");
  font = createFont("PhosphateSolid.ttf", 128);
}
void draw () {
  //code that changes the between the menu, instructions, game, win screen, and lose screen based on which gameScreen you are on
  textFont(font); //font that I imported
  if (gameScreen == 1) {
    drawMenu ();
  } else if (gameScreen == 2) {
    drawInstructions ();
  } else if (gameScreen == 3) {
    drawGame ();
  } else if (gameScreen == 4) {
    winScreen ();
  } else if (gameScreen == 5) {
    loseScreen ();
  }
}
void drawGame () {
  background(#FFFFFF);
  fill (0);
  textSize (50);
  text (score, 20, 60);
  //method signatures
  moveTank (); //the tank
  checkIfTankHitEdges (); //check tank's boundaries
  drawRowsofInvaders (); //draw multiple rows of invaders
  drawLaser();//draw laser
  shoot ();//shoot laser
  invadersMovement();//move the invaders using time
  checkWin ();//check if the player won
  checkLose ();// check if the player lost
  checkInvadersHitEdges ();// check invader's boundaries
  Invader.resize(50, 40);
  Tank.resize(50, 40);
  image(Tank, tankX, tankY);
}
void drawInvader (int x, int y) { //make an invader
  image(Invader, x, y, 50, 37);
}

void drawRowsofInvaders() {

  for (int i = 0; i < 7; i++) {
    for (int m = 0; m < 3; m++) {
      if (invadersDie[m*(7)+i] == false) { //if invaders are alive and if the laser is showing and the laser hits an invader, cause them to dissapear, make the laser dissappear, allow user to shoot again and add to score
        if (showLaser) {
          if (laserX > invaderX[i] && laserX < invaderX[i] + 50 && laserY > invaderY[m] && laserY < invaderY[m] + 37) { 
           invadersDie[m*(7)+i] = true;
            showLaser = false;
            canShoot = true;
            score = score +1;
                       }
        
        }
        drawInvader(invaderX[i], invaderY[m]);
      }
    }
  }
}


void moveTank() { //move tank right or left 5 if right key is pressed
  if (moveTankRight) {
    tankX=tankX+5;
  }
  if (moveTankLeft) {
    tankX=tankX-5;
  }
}
void checkIfTankHitEdges () { //if tank's x positon is out of the left edge, add 5 to its position so it still stays on the screen
  if (tankX < 0) {
    tankX = tankX+5;
  } else if (tankX > 750) { //if tank's x positon is out of the right edge, subtract 5 from its position so it still stays on the screen
    tankX = tankX-5;
  }
}
void drawLaser () { // draw the laser only if the laser is supposed to be shown
  if ( showLaser == true) {
    fill (#000000);
    rect (laserX, laserY, 8, 20, 10);
  }
}
void shoot () { //shoot the laser if the laser is supposed to be shown and take 10 away from its y position to take it all the way up
  if (showLaser==true) {
    laserY = laserY -10;
  }
  if (spacePressed == true && canShoot) { //if you pressed space and you are allowed to shoot (because the previous laser has dissappeared), place the laser in proportion to the tank,
    //shoot the laser, and don't allow the player to shoot again
    laserX = tankX + 80/2 - 20;
    showLaser = true;
    laserY =  height-132;
    canShoot=false;
  }//however if the laser goes of the top edge, make it dissapear and allow the player to shoot again
  if (laserY< -7) {
    showLaser=false;
    canShoot=true;
  }
}
//makses invaders move using similar code to clockwork
void invadersMovement() {
  if (millis()/500 - movementTime > 0) { //if it's been 0.5 seconds since the invaders last moved, move them again
    movementTime = millis()/500;
    for (int i = 0; i < 7; i++) {
      for (int m = 0; m < 3; m++) {
        if (invadersMovingRight == true) {// if they are moving right
          invaderX[i] = invaderX[i] + 10; //add 10 to their x position
        } else {//if they are going left
          invaderX[i] = invaderX[i] - 10; //subtract 10 from their x position
        }
      }
    }
  }
}



void checkInvadersHitEdges() {

  for (  int i = 0; i < 7; i++) {
    for (int m = 0; m < 3; m++) {

      if (invaderX[i] > maxXPositionOfInvader && invadersDie[i] == false) { //if the x position of the invader is greater than its max position and invaders are alive, make it go back to its max
        maxXPositionOfInvader = invaderX[i];
      }
      if (invaderX[i] < minXPositionOfInvader && invadersDie[i] == false) { //if the x position of the invader is less than its min position and invaders are alive, make it go back to its min
        minXPositionOfInvader = invaderX[i];
      }
    }
  }
  if (invadersMovingRight == true && maxXPositionOfInvader > 740) { //if they are going right and their position goes greater than 740, make them go down
    for (  int i = 0; i < 7; i++) {
      for (int m = 0; m < 3; m++) {
        invaderY[m] = invaderY[m] + invaderYSpeed;
      }
    }
    minXPositionOfInvader = 740; //reset variables
    maxXPositionOfInvader = 18;
    invadersMovingRight = false; 
  } else if (invadersMovingRight == false && minXPositionOfInvader < 20) { //if they are going left and they are at less than 20 in x position, make them go down

    for (  int i = 0; i < 7; i++) {
      for (int m = 0; m < 3; m++) {

        invaderY[m] = invaderY[m] + invaderYSpeed;
      }
    }
    minXPositionOfInvader = 740;//reset variables
    maxXPositionOfInvader = 20;
    invadersMovingRight = true;
  }
}

void setVariables() { //make a function to set the variables for when the game ends so that you can play again and everything goes back to normal
  for (int i = 0; i < 7; i++) {
    for (int m = 0; m < 3; m++) {
      invadersDie[m*(7)+i] = false;
      invaderX[i] =  (i*75) + 130;
      invaderY[m] = m*55+50;
    }
    maxYPositionOfInvader = 0;
    score = 0;
    invaderXSpeed = 3;
    invaderYSpeed = 10;
    tankX = 375;
    tankY = 690;
    laserX=  -5;
    laserY=  -5;
    invadersDie[i] = false;
    winGame = false;
    loseGame = false;
    gameEnds = false;
    invaderTouchedRightEdge = false;
    invaderTouchedLeftEdge = false;
    moveTankLeft = false;
    moveTankRight = false;
    canShoot = true;
    showLaser = false;
    spacePressed = false;
    invadersMovingRight = false;
  }
  gameScreen = 3;
}

void drawMenu() {// draw the menu screen
  background(0);
  StartScreen.resize(550, 350);
  image(StartScreen, 130, 170);
  textSize(30);
  fill(#ffffff);
  text("PRESS ENTER TO SEE INSTRUCTIONS", 190, 500);
}
void drawInstructions () {// draw the instructions screen
  background(#348DA2);
  fill(#ffffff);
  textSize (100);
  text ("INSTRUCTIONS", 80, 150);
  textSize (25);
  text ("- USE ARROW KEYS TO MOVE TANK", 205, 230);
  text ("- PRESS SPACEBAR TO SHOOT LASER", 200, 330);
  text ("- EACH ALIEN IS WORTH 1 SCORE; GET 21 TO WIN", 155, 430);
  text ("- ELIMINATE ALL ALLIENS BEFORE THEY HIT THE BOTTOM TO WIN!", 55, 530);
  textSize (50);
  text ("PRESS ENTER TO PLAY", 190, 650);
}
void checkWin() { // check if the player wins
  if (score == 21) { //if the score is 21 (meaning all invaders died), you win and the game screen goes to the win screen
    winGame = true;
    gameScreen = 4;
  }
}
void winScreen () { //draw win screen
  WinImage.resize(800, 800);
  image(WinImage, 0, 0);
  fill (#ffffff);
  textSize (50);
  textSize (35);
  text ("PRESS 'R' TO RESTART", 240, 550);
  if (key=='r'|| key=='R') {
  }
}
void checkLose() { //check if the player loses
  for (int i = 0; i < 7; i++) {
    for (int m = 0; m < 3; m++) {

      if (invaderY[m] > maxYPositionOfInvader && invadersDie[i] == false) { //if the invader's y position is greater than its max y position and invaders are alive, set it back to its max y
        //position
        maxYPositionOfInvader = invaderY[m];
      }
    }
  }
  if (maxYPositionOfInvader>790) { //however, if their position is greater than 790 (meaning they haven't died), then you have lost and the lose screen starts
    loseGame = true;
    gameScreen = 5;
  } else {
    maxYPositionOfInvader = 0; //reset variable
  }
}
void loseScreen() { //make lose screen
  background (0);
  LoseImage.resize(800, 500);
  image(LoseImage, 0, 80);
  fill (#FFFFFF);
  textSize (50);
  text ("YOU LOST!", 295, 550);
  textSize(35);
  text("PRESS 'R' TO RESTART", 250, 600);
  if (key=='r'|| key=='R') {
  }
}

void keyPressed() {
  if (keyCode == 39) { //Right
    moveTankRight = true;
  }
  {
    if (keyCode == 37) { // Left
      moveTankLeft = true;
    }
    if (keyCode == 32) { //Up
      spacePressed = true;
    }
  }
}
void keyReleased() {
  if (keyCode == 39) { //Right
    moveTankRight = false;
  }
  {
    if (keyCode == 37) { // Left
      moveTankLeft = false;
    }
    if (keyCode==32) { //Space
      spacePressed=false;
    }
    if (keyCode==82 && winGame == true) { //If R key is pressed and you won the game, take it back the the game and reset the variables
      gameScreen = 3;
      setVariables();
    }
    if ( keyCode==82 && loseGame == true ) {//If R key is pressed and you lost the game, take it back the the game and reset the variables
      gameScreen = 3;
      setVariables();
      //if the enter key is pressed and you are on the menu screen, the instructions start
    } else if (keyCode == 10 && gameScreen==1) {
      gameScreen=2;

      //if the enter key is pressed and you are on the instructions screen, the game starts
    } else if (keyCode == 10 && gameScreen==2) { // Enter Key
      gameScreen=3;
    }
  }
}
