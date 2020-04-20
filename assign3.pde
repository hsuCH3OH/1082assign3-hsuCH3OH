final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;
final int GRID = 80;
float hogFrame;
float baselineY=0;
float lifeQ =0; // quantity of lives

int speedX,soldierXAxis,soldierYAxis, oldTime, nowTime,mainX, mainY;
int groundhogIdleX, groundhogIdleY, groundhogMovingSpeed, groundhogMovingSpeed2;
int cabbageX, cabbageY, lifeImageX, lifeImageY, outOfCanvas;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil8x24, soil0,soil1, soil2, soil3, soil4, soil5, life, soldierImg;
PImage backgroundImg, groundhogIdleImg, groundhogDownImg, groundhogLeftImg, groundhogRightImg;
PImage stone1, stone2;

boolean aPressed = false;
boolean sPressed = false;
boolean dPressed = false;
boolean rollingDown = false;

boolean leftPressed = false;
boolean rightPressed = false;
boolean downPressed = false;
boolean noPressed = true;


// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
	size(640, 480, P2D);
	// Enter your setup code here (please put loadImage() here or your game will lag like crazy)
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	//soil8x24 = loadImage("img/soil8x24.png");
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");
  life  = loadImage("img/life.png");
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
  soldierImg = loadImage("img/soldier.png");
  groundhogIdleImg  = loadImage("img/groundhogIdle.png"); 
  groundhogDownImg  = loadImage("img/groundhogDown.png");
  groundhogLeftImg  = loadImage("img/groundhogLeft.png");
  groundhogRightImg = loadImage ("img/groundhogRight.png");
  
  groundhogIdleX = width/2;
  groundhogIdleY = 80;
  groundhogMovingSpeed  = 80;
  groundhogMovingSpeed2 = 20;
 
  //cabbage location
  cabbageX = floor(random(0,8))*80;
  cabbageY = floor(random(2,6))*80;
  
  lifeImageX = 10;
  lifeImageY = 10;

}

void draw() {
    /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);

		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}
		}else{
			image(startNormal, START_BUTTON_X, START_BUTTON_Y);
		}
		break;

		case GAME_RUN: // In-Game

		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

    if(rollingDown){
      pushMatrix();
      translate(0,baselineY);
    }  //soil and stone will going up
    
  		// Grass
  		fill(124, 204, 25);
  		noStroke();
  		rect(0, 160 - GRASS_HEIGHT, width, GRASS_HEIGHT);
  
  		// Soil
  		//image(soil8x24, 0, 160);    
      for(int i=0; i<=width; i+=GRID){
        for(int j=2*GRID; j<=5*GRID; j+=GRID)
        image(soil0,i,j);
      }
      for(int i=0; i<=width; i+=GRID){
        for(int j=6*GRID; j<=9*GRID; j+=GRID)
        image(soil1,i,j);
      }
      for(int i=0; i<=width; i+=GRID){
        for(int j=10*GRID; j<=13*GRID; j+=GRID)
        image(soil2,i,j);
      }
      for(int i=0; i<=width; i+=GRID){
        for(int j=14*GRID; j<=17*GRID; j+=GRID)
        image(soil3,i,j);
      }
      for(int i=0; i<=width; i+=GRID){
        for(int j=18*GRID; j<=21*GRID; j+=GRID)
        image(soil4,i,j);
      }
      for(int i=0; i<=width; i+=GRID){
        for(int j=22*GRID; j<=25*GRID; j+=GRID)
        image(soil5,i,j);
      }
      
      //stone
      //1-8 layer
      for(int i=0; i<=width; i+=GRID){
        pushMatrix();
        translate(0,i);
        image(stone1, i, GRID*2);
        popMatrix();
      }
      // 9-16 layer
      for(int x =0; x<=10*GRID; x+=GRID){        
          pushMatrix();
          translate(0, 10*GRID);
          for(int y=0; y< 8*GRID; y+=GRID){
            if(x % (4*GRID) ==0){
              if(y % (4*GRID) ==0){                
                image(stone1, x+GRID, y);
                image(stone1, x+2*GRID,y);
                image(stone1, x+GRID, y+3*GRID);
                image(stone1, x+2*GRID,y+3*GRID);
                image(stone1, x, y+GRID);
                image(stone1, x+3*GRID, y+GRID);
                image(stone1, x, y+2*GRID);
                image(stone1, x+3*GRID, y+2*GRID);
              }
            }
          }
        popMatrix();
      }
      //17-24 layer
      for(int x=0; x<=8*GRID; x+=GRID){
        pushMatrix();
        translate(0,18*GRID);
        for(int y=0; y<8*GRID; y+=GRID){
          if( x %(3*GRID) == 0){
            if(y %(3*GRID) ==0){
            image(stone1, x+GRID, y);    //17
            image(stone1, x+2*GRID, y);
            image(stone1, x, y+GRID);    //18
            image(stone1, x+GRID, y+GRID);
            image(stone1, x, y+2*GRID);  //19
            image(stone1, x+2*GRID, y+2*GRID);
            
            image(stone2, x, y+2*GRID);    //19
            image(stone2, x+GRID, y+GRID); //18
            image(stone2, x+2*GRID, y);    //17
            }
          }
        }
        popMatrix();
      }
    
    if(rollingDown){
      popMatrix();
    } //soil follow the downPressed and go up
    
    //life
    for(int i=0; i<2; i++){
      image(life, lifeImageX+70*i,lifeImageY);
    }
    
    //groundhog
    if(leftPressed == false && downPressed == false && rightPressed == false){
      image(groundhogIdleImg, groundhogIdleX, groundhogIdleY);    
    }
    
    if(leftPressed){
      hogFrame++;
      if(hogFrame >0 && hogFrame <15){
        groundhogIdleX -=GRID/15.0;
        image(groundhogLeftImg, groundhogIdleX, groundhogIdleY);
      }else{
        groundhogIdleX = mainX-=GRID;
        leftPressed = false;
      }
    }
    
    if(downPressed){
      hogFrame++;
      if(hogFrame >0 && hogFrame <15){
        
        if(baselineY > -20.0*GRID){
        baselineY -= GRID/14.0;
        }else{
          groundhogIdleY += GRID/14.0;
          baselineY = -20*GRID;
        }
        image(groundhogDownImg, groundhogIdleX, groundhogIdleY);
      }else{
        //groundhogIdleY = mainY+=GRID;
        downPressed = false;
      }
    }
    
    if(rightPressed){
      hogFrame++;
      if(hogFrame >0 && hogFrame <15){
        groundhogIdleX += GRID/15.0;
        image(groundhogRightImg,groundhogIdleX, groundhogIdleY);
      }else{
        groundhogIdleX = mainX+=GRID;
        rightPressed = false;
      }
    }
    
		// Player

		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
				// Remember to initialize the game here!
			}
		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
    
  // edge limit for hog
  if (groundhogIdleX > width-GRID)  {groundhogIdleX = width-GRID;}
  if (groundhogIdleX < 0)         {groundhogIdleX = 0;}
  if (groundhogIdleY > height-GRID) {groundhogIdleY = height-GRID;}
}

void keyPressed(){
	// Add your moving input code here
  
  float oldTime = nowTime;
  float nowTime = millis();
  
  if(gameState == GAME_RUN){
    if(key ==CODED){
      switch(keyCode){
      case LEFT:
      if(leftPressed == false){ 
          leftPressed = true;
          noPressed = false;          
          if (groundhogIdleX <= 0){
            groundhogIdleX = 0;
          }
          oldTime = nowTime;
        }
        hogFrame =0;
        mainX = groundhogIdleX;
      break;
      
      case DOWN:
        if(downPressed == false){
          rollingDown = true;
          downPressed = true;
          noPressed = false;
          if (groundhogIdleY >= height){
            groundhogIdleY = GRID*5;
          }
          oldTime = nowTime;
        }
        hogFrame = 0;
        mainY = groundhogIdleY;
        if(baselineY <=-20*GRID){
          baselineY = -20*GRID;
        }       
        break;
      
      case RIGHT:
      if(rightPressed == false){ 
          rightPressed = true;
          noPressed = false;          
          if (groundhogIdleX >= width-GRID){
            groundhogIdleX = width-GRID;
          }
          oldTime = nowTime;
        }
        hogFrame =0;
        mainX = groundhogIdleX;
      break;
      }
    }
  }

	// DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      
      break;

      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;

      case 'a':
      if(playerHealth > 0) playerHealth --;
      break;

      case 'd':
      if(playerHealth < 5) playerHealth ++;
      break;
    }
}

void keyReleased(){
}
