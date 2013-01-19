
//For storing the 2 layer images
PImage fground;
PImage mground;
PImage bground;

void initScene() {
  //initialize images

  fground = loadImage("Foreground2.png");
  mground = loadImage("Middleground2.png");
  bground = loadImage("ny-back.jpg");
}


void doSide2Side() {
  background(125);
  imageMode(CENTER);
  float fgroundHeight = height/2;
  float fgroundWidth = width+100;
  float fgroundY = height;
  float zoomFactorMid = map(zoomFactor, 1, 5, 1, 1.2);
  float zoomFactorY = map(zoomFactor, 1,5,0,200);
  float zoomFactorZoom = map(zoomFactor, 1,5, 1,2);
  float zoomFactorBack = map(zoomFactor, 1, 5, 1, 1.05);

  if (targetLocX != locX) {
    locX = lerp(locX, targetLocX, 0.1);
  }
  if (targetZoomFactor != zoomFactor) {
   zoomFactor = lerp(zoomFactor, targetZoomFactor, 0.15);
  }
  image(bground, width/2 + 15 * locX, height/2-50, 1600*zoomFactorBack, 620*zoomFactorBack);
  image(mground, width/2 + 30 * locX, height/2-10, (1507)*zoomFactorMid, 750*zoomFactorMid);
  image(fground, width/2 + 190 * locX, ((fgroundY/2)+250)+(zoomFactorY), 3110*zoomFactorZoom, 400*zoomFactorZoom);
  

}

