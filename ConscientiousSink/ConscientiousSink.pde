/*
 * Clutterometer
 * Copyright 2012 Andrew Cerrito, Jon Wasserman, and Karl Ward
 * See the file CREDITS for details on external code referenced/incorporated 
 * See the file COPYING for details on software licensing 
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import processing.video.*;
import processing.serial.*; 

Serial myPort;       

//Capture video; // video stream (using Capture instead of CaptureAxisCamera
CaptureAxisCamera video; // video stream
ClutterCam cam; // will measure amount of clutter
int clutter; 
boolean presence; 

void setup() { 
  size(640, 480); 
  //video = new Capture(this, width, height, 24); // use this line if you want to use Capture  
  video = new CaptureAxisCamera(this, "128.122.151.82", width, height, false);
  //video.start();  // you need this line if you want to use Capture
  cam = new ClutterCam(video); // create a ClutterCam associated with the video Capture
  presence = false; 

  // List all the available serial ports:
  println(Serial.list());

  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[4], 9600);
} 

void draw() { 
  if (!cam.calibration) { // wait until the camera is ready
    println("Camera not calibrated yet."); 
    return;
  }
  else { // sense the deviation and display a visualization
    clutter = cam.sense_deviation();
    println(clutter);
    // write to serial port for Arduino 
    //myPort.write(clutter); // commented out while we test ClutterMat

    loadPixels(); 
    arrayCopy(cam.show_diff(), pixels); // FIXME: need to fix sense() and show_diff()
    updatePixels();
    // draw the polygon used in ClutterCam to restrict view to sink, this is a test 
    noFill(); 
    beginShape(); 
    vertex(cam.x[0], cam.y[0]);
    vertex(cam.x[1], cam.y[1]);
    vertex(cam.x[2], cam.y[2]);
    vertex(cam.x[3], cam.y[3]);
    vertex(cam.x[0], cam.y[0]);
    endShape();
  }
}

//public void captureEvent(Capture v) { // need this line if using Capture instead of CaptureAxisCamera
public void captureEvent(CaptureAxisCamera v) { // need if you want to use CaptureAxisCamera
  v.read(); 
  v.loadPixels();
  cam.set_current_frame(v.pixels);
}

void serialEvent (Serial s) {
  // get the byte:
  int inByte = s.read();

  int baseline_mat = 50; // mat should output between 0-255

  // set a variable that indicates presence at the mat 
  if (inByte > baseline_mat) { 
    if (presence == false) { // state transition from false to true 
      presence = true;
      println("setting presence to true");
    } 
  }
  else { 
    if (presence == true) { // state transition from true to false 
      presence = false;
      println("presence is false, the killer is outside the house!");
    }
  }
}

