PFont font;

color[][] colorSet={
 {color(155, 89, 182),color(142, 68, 173)},  //Amethyst, wisteria
 {color(52, 152, 219),color(41, 128, 185)},  //Peter river, belize hole
 {color(46,204,133),color(39, 174, 96)},   //Emerald, nephrite
 {color(26, 188, 156),color(22,160,133)},  //Turguoise, green sea
 {color(241, 196, 15),color(243, 156, 18)},  //Sunflower, orange
 {color(230, 126, 34),color(211, 84, 0)},    //Carrot, pumpkin
 {color(231, 76, 60),color(192, 57, 43)}    //alizarin, pomegranate
};
color[][] reverseColSet={
 {color(142, 68, 173),color(155, 89, 182)},  //wisteria, amethyst(the same below)
 {color(41, 128, 185),color(52, 152, 219)},
 {color(39, 174, 96),color(46,204,133)},
 {color(22,160,133),color(26, 188, 156)},
 {color(243, 156, 18),color(241, 196, 15)},
 {color(211, 84, 0),color(230, 126, 34)},
 {color(192, 57, 43),color(231, 76, 60)}
};
color[] colSet1D={
  color(155, 89, 182),color(142, 68, 173),
  color(52, 152, 219),color(41, 128, 185),
  color(46,204,133),color(39, 174, 96),
  color(26, 188, 156),color(22,160,133),
  color(241, 196, 15),color(243, 156, 18),
  color(230, 126, 34),color(211, 84, 0),
  color(231, 76, 60),color(192, 57, 43)
};
Mosaic newMosaic=new Mosaic(0,0,600,10);

void setup(){
  size(600,600);
  background(255);
  noStroke();
  frameRate(4);
  newMosaic.init();
  newMosaic.display();
}

void draw(){
  /*
    judge which pattern should be display
  */
  //switch(newMosaic.patternSwitch){
  //  case 0: newMosaic.randomPattern();
  //          newMosaic.display();
  //          break;
  //  case 1: newMosaic.animatedOne();
  //          newMosaic.display();
  //          break;
  //  case 2: newMosaic.animatedTwo();
  //          newMosaic.display();
  //          break;
  //}
  newMosaic.display();
}
/*listens for a mouse pressed event 
  and generate a random pattern with randomPattern()
*/
//void mousePressed(){
//  newMosaic.patternSwitch=0;
//}
/* listens for which key is being pressed
  1: generate windmill pattern by calling patternOne()
  2: generate rainbow pattern by calling patternTwo()
*/
void keyPressed(){
  if(key=='1'){
    newMosaic.patternSwitch=1;
  }
  if(key=='2'){
    newMosaic.patternSwitch=2;
  }
  if(key=='w'){
    if(newMosaic.curIndexX>-1&&newMosaic.curIndexY>-1){
      newMosaic.reverseColor();
    }
  }
  if(key=='a'){
    newMosaic.changeColor(false);
  }
  if(key=='d'){
    newMosaic.changeColor(true);
  }
  if(key=='s'){
    if(newMosaic.curIndexX>-1&&newMosaic.curIndexY>-1){
      newMosaic.changeDir();
    }
  }
  if(keyCode==UP||keyCode==DOWN||keyCode==LEFT||keyCode==RIGHT){
    newMosaic.changeCur();
  }
}

void mouseClicked(){
  newMosaic.calculateIndex();
}
/*
  class mosaic
*/
class Mosaic{
  int grid=10; // the size of mosaic board (grid*grid grid)
  int mWidth; 
  int mHeight;
  int mx; //initial value of x axis
  int my; //initial point of y axis
  int bfSize=18; //basic font size, 18 point when width is 600
  color[] randomCol1;
  color[] randomCol2;
  int random7;
  int counter=0;
  int patternSwitch=-1;
  int curIndexX=-1;
  int curIndexY=-1;
  
  Pixel[][] board=new Pixel[grid][grid]; //store all the pixel on the mosaic board
  
  /*
    constructor, parameters are 
    1. initial value of x axis
    2. initial value of y axis
    3. width of the mosaic board
    4. the amount of pixels in a side
  */
  Mosaic(int x,int y, int w, int g){
    mx=x;
    my=y;
    mWidth=w;
    mHeight=w;
    randomCol1=getRandomCol();
    //prevent two random color generated is the same
    do{
      randomCol2=getRandomCol();
    }while(randomCol2[0]==randomCol1[0]||randomCol2[0]==randomCol1[1]);
    random7=int(random(7));
    bfSize=bfSize*mWidth/600;
    grid=g;
    //the value of grid must be even for loading two existed pattern
    if(grid%2!=0){
      grid++;
    }
  }
  /*
    initialization of mosaic board, 
    display a random pattern,
    title of work and instruction on the screen
  */
  void init(){
    randomPattern();
    display();
    //Title and instruction
    fill(255);
    rect(mWidth/3,mHeight/2-50,mWidth*2/3,100);
    font=loadFont("AppleBraille-48.vlw");
    textFont(font);
    fill(255);
    textSize(2.6*bfSize);
    text("DIGITAL MOSAIC",mWidth/3,mHeight/2-50);
    textSize(1.6*bfSize);
    fill(52, 73, 94);
    text("Instructions",mWidth/3+15,mHeight/2-15);
    textSize(bfSize);
    text("- Click to generate random pattern",mWidth/3+15,mHeight/2+13);
    text("- Press 1, 2 to view preset patterns", mWidth/3+15,mHeight/2+38);
  
  }
  /*
    display the pixels to the screen
  */
  void display(){
    for(int i=0; i<grid; i++){
      for(int j=0; j<grid; j++){
        pushMatrix();
          translate(mx+i*mWidth/grid, my+j*mHeight/grid);
          board[i][j].display();
        popMatrix();
      }
    }
  }
  
  boolean isInside(){
    if(mouseX>mx&&mouseX<(mx+mWidth)&&mouseY>my&&mouseY<(my+mHeight)){
      return true;
    } 
    else{
      curIndexX=-1;
      curIndexY=-1;
      return false;
    }
  }
  void calculateIndex(){
    if(isInside()){
      curIndexX=(mouseX-mx)/(mWidth/grid);
      curIndexY=(mouseY-my)/(mHeight/grid);
      //print(curIndexX);
      //print(curIndexY);
    }
  }
  void changeCur(){
    if(keyCode==UP){
      curIndexY=(curIndexY-1)%grid;
    }else if(keyCode==DOWN){
      curIndexY=(curIndexY+1)%grid;
    }else if(keyCode==LEFT){
      curIndexX=(curIndexX-1)%grid;
    }else{
      curIndexX=(curIndexX+1)%grid;
    }
    
  }
  void changeColor(boolean dir){
    for(int i=0; i<7; i++){
      if(board[curIndexX][curIndexY].pColor[0]==colorSet[i][0]){
        if(dir){
          board[curIndexX][curIndexY].pColor[0]=colorSet[(i+1)%7][0];
          board[curIndexX][curIndexY].pColor[1]=colorSet[(i+1)%7][1];
        }else{
          if(i==0){
            board[curIndexX][curIndexY].pColor[0]=reverseColSet[6][0];
            board[curIndexX][curIndexY].pColor[1]=reverseColSet[6][1];

          }else{
            board[curIndexX][curIndexY].pColor[0]=reverseColSet[(i-1)%7][0];
            board[curIndexX][curIndexY].pColor[1]=reverseColSet[(i-1)%7][1];
          }
        }
        return;
      }
    }
    for(int i=0; i<7; i++){
      if(board[curIndexX][curIndexY].pColor[0]==reverseColSet[i][0]){
        if(dir){
          board[curIndexX][curIndexY].pColor[0]=reverseColSet[(i+1)%7][0];
          board[curIndexX][curIndexY].pColor[1]=reverseColSet[(i+1)%7][1];
        }else{
          if(i==0){
            board[curIndexX][curIndexY].pColor[0]=reverseColSet[6][0];
            board[curIndexX][curIndexY].pColor[1]=reverseColSet[6][1];

          }else{
            board[curIndexX][curIndexY].pColor[0]=reverseColSet[(i-1)%7][0];
            board[curIndexX][curIndexY].pColor[1]=reverseColSet[(i-1)%7][1];
          }
        }
        return;
      }
    }
  }
  void reverseColor(){
    color temp=board[curIndexX][curIndexY].pColor[0];
    board[curIndexX][curIndexY].pColor[0]=board[curIndexX][curIndexY].pColor[1];
    board[curIndexX][curIndexY].pColor[1]=temp;
  }
  void changeDir(){
    board[curIndexX][curIndexY].cuttingLine=1-board[curIndexX][curIndexY].cuttingLine;
  }
  /*
    get a random color group(two similar color)
  */
  color[] getRandomCol(){
    int randomColR=int(random(7));
    int randomColC=int(random(2));
    color[] ranCol= {colorSet[randomColR][randomColC],colorSet[randomColR][1-randomColC]};
    return ranCol;
  }
  /*
    generate random pattern, 
    every pixel is generated with random color and direction
  */
  void randomPattern(){
    for(int i=0; i<grid; i++){
     for(int j=0; j<grid; j++){
       board[i][j]=new Pixel(int(random(2)), getRandomCol());
     }
    }
  }
  /*
    animation of pattern one
    two pattern appear alternately
  */
  void animatedOne(){
    counter=(counter+1)%7;
    if(counter%2==0){
      patternOne(randomCol1,randomCol2);
    }else{
      patternOne(randomCol2, randomCol1);
    }
  }
  /*
    the first preset pattern----Windmill,
    every windmill consist of 4 pixels,
    call windmill() in a loop to fill the screen
  */
  void patternOne(color[] col1, color[] col2){
    for(int i=0; i<grid/2; i++){
      for(int j=0; j<grid/2; j++){
        if(i%2==0&&j%2==0){
          windmill(2*i, 2*j, col1);
        }else if(i%2!=0&&j%2!=0){
          windmill(2*i, 2*j, col1);
        }else{
          windmill(2*i, 2*j, col2);
        }
      }
    }
  }
  /*
    generate a windmill with given the coordinate of origin and color,
    consist of 4 pixel with the colors in the same color group
  */
  void windmill(int origX, int origY, color[] col){
    color[] reverseCol={col[1],col[0]};
    board[origX][origY]=new Pixel(1, col);
    board[origX+1][origY]=new Pixel(0,col);
    board[origX][origY+1]=new Pixel(0,reverseCol);
    board[origX+1][origY+1]=new Pixel(1,reverseCol);
  }
  /*
    animation of pattern two
    change start color in turn to create animated effect
  */
  void animatedTwo(){
    patternTwo(random7);
    random7=(random7+1)%7;
  }
  /*
    the second preset pattern----Rainbow
    call rainbow() in a for loop to fill the screen
  */
  void patternTwo(int startColor){
     for(int i=0; i<grid/2; i++){
       rainbow(i*2, startColor);
       startColor++;
     } 
  }
  /* 
    a rainbow is a 2*10 pixel group
    pixel in the same row have the same color but different direction
    the color of rows is in an particular order, refer to rainbow colors
  */
  void rainbow(int origX, int startColor){
    for(int j=0; j<grid; j++){
      color[] col={colorSet[(startColor+j)%7][0],colorSet[(startColor+j)%7][1]};
      color[] reverseCol={col[1],col[0]};
      board[origX][j]=new Pixel(0,col);
      board[origX+1][j]=new Pixel(1,reverseCol);
    }
  }
  /*
    class pixel is inside the class mosaic
  */
  class Pixel{
    int pWidth=mWidth/grid;
    int pHeight=mHeight/grid;
    int cuttingLine; //0: left-top/right-bottom; 1: left-bottom/right-top
    color[] pColor;
    
   /*
     constructor, parameters are
     1. the direction of cutting line, 0 or 1
     2. the color group
   */
    Pixel(int cl, color[] pc){
      cuttingLine=cl;
      pColor=pc;
    }
  /*
    draw the pixel to the screen
  */
    void display(){
      //cut to left-top and right-bottom
      if(cuttingLine==0){
        fill(pColor[0]);
        // left-top triangle
        triangle(0,0,0,pHeight,pWidth,0);
        fill(pColor[1]);
        //right-bottom triangle
        triangle(pWidth,0,0,pHeight,pWidth,pHeight);
      }else{ //cut to left-bottom and right-top
        fill(pColor[0]);
        //left-bottom triangle
        triangle(0,0,0,pHeight,pWidth,pHeight);
        fill(pColor[1]);
        //right-top triangle
        triangle(pWidth, 0,0,0,pWidth,pWidth);
      }
    }
  }
}