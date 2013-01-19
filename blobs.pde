
void doBackgroundSubtraction() {

  // OpenCV has 3 images you can access, 
  // the SOURCE (original image from camera or movie)
  // the BUFFER (image after any operations like convert, brightness, threshold, etc...)
  // the MEMORY (the image stored when OpenCV.remember(..) is called)
  //image( cv.image(OpenCV.SOURCE), 0, 0 );
  //text( "original source image", 10, 10 );

  // use the OpenCV function convert to convert 
  // the source image to grayscale and store in the
  // OpenCV.BUFFER
  cv.convert(OpenCV.GRAY);

  //image( cv.image(OpenCV.BUFFER), capture_width, 0 );
  //text( "grayscale buffer image", capture_width+10, 10);

  // Calculate the absolute difference between the 
  // image in the OpenCV Memory and the current image
  cv.absDiff();
  // Create a binary matrix in the OpenCV.BUFFER that 
  // has values >= threshold set to 1, 
  // and values < threshold set to 0
  cv.threshold(threshold);
  textSize(10);
  text( "threshold: " + threshold, capture_width+10, capture_height+10 );

  // Blur the image in the OpenCV.BUFFER
  cv.blur(OpenCV.GAUSSIAN, 11);

  if (show_difference)
  {
    image( cv.image(OpenCV.BUFFER), 0, 0 );
    textSize(10);
    fill(125);
    text( "absoulte-difference image", 10, 10 );
  }

  image( cv.image(OpenCV.MEMORY), capture_width, 0 );
  textSize(10);
  text( "memory image", capture_width+10, 10 );
}

void doBlobDetection() {

  // Do the blob detection
  Blob[] blobs = cv.blobs(100, capture_width*capture_height/3, 1, false);
  /* public Blob[] blobs(int minArea,
   int maxArea,
   int maxBlobs,
   boolean findHoles) */

  // Pushing a matrix allows any transformations such as rotate, translate, or scale,
  // to stay within the same matrix.  once we "popMatrix()", then all the commands for that matrix
  // are gone for any subsequent drawing.
  pushMatrix();
  // since we translate after we pushed a matrix, every drawing command afterwards will be affected
  // up until we popMatrix().  then this translate will have no effect on drawing commands after
  // the popMatrix().
  translate(capture_width, 0);

  // We are going to keep track of the total x,y centroid locations to find
  // an average centroid location of all blobs
  int total_x = 0;
  int total_y = 0;		

  // we loop through all of the blobs found by cv.blobs(..)
  for ( int blob_num = 0; blob_num < blobs.length; blob_num++ ) {

    if (draw_blobs)
    {
      // get the bounding box from the blob detection and draw it
      Rectangle bounding_box = blobs[blob_num].rectangle;
      noFill();
      stroke(128);
      this.rect( bounding_box.x, bounding_box.y, bounding_box.width, bounding_box.height );
    }

    // accumulate the centroids
    Point centroid = blobs[blob_num].centroid;
    total_x += centroid.x;
    total_y += centroid.y;
    
    //Move image
    float track = map(total_x, capture_width, 0, -10, 10);   //used to be 0,10

//  EXPERIMENT
if (track<-6) {
  targetLocX = -3;
}
else if (track >=-6 && track < -4) {
  targetLocX = -2;
}
else if (track >=-4 && track < -2) {
  targetLocX = -1;
}
else if (track >=-2 && track < 2) {
  targetLocX = 0;
}
else if (track >=2 && track < 4) {
  targetLocX = 1;
}
else if (track >=4 && track < 6) {
  targetLocX = 2;
}
else if (track>6) {
  targetLocX = 3;
}

println("track: " + track);   
   
    
// PUT BACK IN
//    if (track>5.5) {
//      if (targetLocX >= -3) {
//        targetLocX = -3;
//      }
//      else {
//        targetLocX = targetLocX + 1;
//      }
//    }
//    else if (track<4.5) {
//      if (targetLocX <= 3) {
//        targetLocX = 3;
//      }
//      else {
//        targetLocX = targetLocX - 1;
//     }
//    }
// PUT BACK IN


   // else if (total_x = null){
   //   targetLocX = 0;
  //   }
    
    //Display the center value
    if (draw_centroid)
    {
    textSize(64);
    fill(255,255,0);
    text("Center: " + (capture_width - total_x), -capture_width+100, capture_height+140);
    //println("Center x" + total_x);
    text("track: " + (track), -capture_width+100, capture_height+199);
    }
  }

  if (blobs.length > 0)
  {
    // by keeping the previous centroid, we can do an interpolation between
    // the current centroid and the previous one.  this will make any tracking results
    // seem smoother.  a better way would be to use a low pass filter over a vector
    // of centroid locations.  i.e. keep more than just 1 previous location and 
    // find a better way of interpolating the current centroid from them.
    previous_centroid_x = current_centroid_x;
    previous_centroid_y = current_centroid_y;

    current_centroid_x = (total_x/blobs.length + previous_centroid_x) / 2;
    current_centroid_y = (total_y/blobs.length + previous_centroid_x) / 2;
  }

//  if (draw_centroid)
//  {
//    // draw a crosshair at the centroid location
//    this.ellipse(current_centroid_x, current_centroid_y, 5, 5);
//    this.line( current_centroid_x-5, current_centroid_y, current_centroid_x+5, current_centroid_y );
//    this.line( current_centroid_x, current_centroid_y-5, current_centroid_x, current_centroid_y+5 );
//  }
  popMatrix();
}
