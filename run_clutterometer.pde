/*
 * Clutterometer
 * by Andrew Cerrito, Jon Wasserman, and Karl Ward
 * 2012
 *
 * We owe a creative debt to:
 * - Golan Levin for his excellent example code (e.g. FrameDifferencing) within the Processing Examples. 
 * - Melissa dela Merced, Dan O'Sullivan, and Heather Velez for their CaptureAxisCamera code
 * 
 */

import processing.video.*;

Capture video; // video stream
int array_size; // number of pixels in a frame of video stream
int current_frame[]; 
boolean capture_started = false; // whether current_frame is loaded
Clutterometer cm; // will measure amount of clutter

void setup() { 
  size(640, 480); 
  video = new Capture(this, width, height, 24); // start video stream  
  video.start();
  array_size = video.width * video.height; 
  current_frame = new int[array_size]; // frame with the current state
  loadPixels(); 
  cm = new Clutterometer();
} 

void draw() { 
  if (!capture_started) { 
    return; 
  }
  
  arrayCopy(current_frame, pixels);
  for (int i = 0; i < array_size; i++) { 
    if (current_frame[i] != cm.baseline_frame[i]) { 
      pixels[i] = current_frame[i]; 
    }
    else { 
      pixels[i] = color(int(random(255)), int(random(255)), int(random(255))); 
    }
  }
  updatePixels();
}

public void captureEvent(Capture v) {
  v.read(); 
  v.loadPixels();
  arrayCopy(v.pixels, current_frame); 
  capture_started = true;
//  image(v, 0, 0);
}

class Clutterometer { 
  // attributes 
  byte clutter; // percentage of sink surface obscured, range betwee 0-100
  boolean calibration = false; // calibration state, which is false until call to calibrate()
  int baseline_frame[] = new int[array_size]; // frame with the empty sink
  int pre_frame[] = new int[array_size]; // frame with state just before entrance
  int exit_frame[] = new int[array_size]; // frame with the state at exit

  // Constructor method
  //   NOTE: real sink must be empty, and mat must be unloaded, when constructor is called 
  //   FIXME: provide interface to do calibration on demand 
  Clutterometer() { 
    this.init();
  }

  // Initialization method 
  private void init() {
    if (!calibration) { 
      println("Need to calibrate camera before sensing...");  
      boolean cam_calibration = this.camera_calibrate();
      println("Need to calibrate mat before sensing..."); 
      boolean mat_calibration = this.mat_calibrate(); 

      // set calibration attribute to true if both camera and mat are calibrated
      calibration = (cam_calibration && mat_calibration);
    }
    else { 
      println("Calibration already complete.");
    }
  }

  // Camera calibration method 
  //   capture state of sink when completely empty, setting baseline_frame
  private boolean camera_calibrate() { 
    arrayCopy(current_frame, baseline_frame); 
    clutter = 0; 
    println("Camera calibration complete");
    return(true);
  }

  // Mat initialization method 
  //   like a "tare" of the mat, listen to its unloaded state for a bit
  private boolean mat_calibrate() { 
    // FIXME: mat calibration code here
    println("Mat calibration complete."); 
    return(true);
  }

  // compare current state to baseline and initial state
  void sense() {
  }
}

