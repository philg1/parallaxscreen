import hypermedia.video.*;              // Open CV library
import java.awt.*;			// java awt library
import processing.serial.*;
import fullscreen.*; 

OpenCV cv = null;
Serial myPort;
FullScreen fs; 

// camera width/height
int capture_width = 160;
int capture_height = 120;
int inByte;

// threshold for background subtraction
int threshold = 100;

// some variables to control the contrast/brightness of the camera image
int contrast = 0, brightness = 0;

// for drawing text
PFont font;

float locX = 0;
float targetLocX = 0;
float zoomFactor = 1;
float targetZoomFactor = 1;

// these boolean values will be used to trigger parts of the code - we
// can use the keyPressed method to set these boolean values with the keyboard
boolean draw_blobs=true, draw_centroid=true, show_difference=true, side_move=false;

// we are going to track the centroid of all blobs and keep the previous
// and current estimate
int previous_centroid_x = capture_width / 2;
int previous_centroid_y = capture_height / 2;
int current_centroid_x = capture_width / 2;
int current_centroid_y = capture_height / 2;

void setup() {
  // Size of the window
  size(capture_width*8, capture_height*6 );
  
     //open serial port
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);

  // open video stream
  cv = new OpenCV( this );

  //cv.capture( 640, 480 );
  // Setup our capture device using opencv
  cv.capture(capture_width, capture_height, 0);

  // Setup font to use the Andale Mono type font (this file is in the data folder)
  font = loadFont("AndaleMono.vlw");
  textFont(font);

  //Initialize scene/images
  initScene();
  
   // Create the fullscreen object
  fs = new FullScreen(this); 

  // enter fullscreen mode
 // fs.enter();
}

void draw() {
  // set the background color to black
  background(0);
  imageMode(CORNER);

  // display the frame per second of our program. if this gets too low,
  // our program will appear less interactive as the latency will be higher
  textSize(10);
  fill(125);
  text("fps: " + frameRate, 10, capture_height+10);

  cv.read();           // grab frame from camera
  //cv.threshold(80);    // set black & white threshold 

    // adjust the Contrast/Brightness (stored in OpenCV.BUFFER)
  cv.contrast(contrast);
  cv.brightness(brightness);

  // call the method for background subtraction
  doBackgroundSubtraction();

  // and blob detection
  doBlobDetection();

  //move side to side
  if (side_move) {
    doSide2Side();
  }
}

// keyPressed is a processing function that lets us know when a user
// has pressed a key.  the variable, key, will be set to a character of the keyboard.
void keyPressed() {
  if ( key == ' ' ) {
    //cv.flip(cv.FLIP_HORIZONTAL);	
    cv.remember(OpenCV.SOURCE);
  }
  if ( key == '+') {
    if (threshold >= 255) threshold = 255;
    else threshold++;
  }
  if ( key == '-' ) {
    if (threshold <= 0) threshold = 0;
    else threshold--;
  }
  if (key == 'b' ) {
    draw_blobs = !draw_blobs;
  }
  if (key == 'c' ) {
    draw_centroid = !draw_centroid;
  }
  if (key == 'd') {
    show_difference = !show_difference;
  }
   if (key == 's') {
    side_move = !side_move;
  }
}

void serialEvent (Serial myPort) {
  // get the byte:
  inByte = myPort.read(); 
  // print it:
  println(inByte);
  
  if (inByte <= 10) {
    targetZoomFactor = 5;
  }
  else if (inByte > 10 && inByte <= 30) {
  targetZoomFactor = 4;
}
else if (inByte >30 && inByte <=60) {
  targetZoomFactor = 3;
}
else if (inByte > 60 && inByte <= 80) {
  targetZoomFactor = 2;
}
else if (inByte > 80) {
  targetZoomFactor = 1;
}
}
  
