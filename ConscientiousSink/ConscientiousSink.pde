
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
import ddf.minim.*;

Minim minim;
AudioPlayer whisperingclean;
AudioPlayer ambientsink;

Serial servoPort;
Serial matPort;

//Capture video; // video stream (using Capture instead of CaptureAxisCamera
CaptureAxisCamera video; // video stream
ClutterCam cam; // will measure amount of clutter
ClutterMat mat; // will measure presence in front of sink
int clutter; 
int entrance_clutter; 
boolean old_presence; 

void setup() { 
  size(640, 480); 
  minim = new Minim(this);
  whisperingclean = minim.loadFile("whisperingclean.mp3");
  ambientsink = minim.loadFile("ambientsink.mp3");
  //video = new Capture(this, width, height, 24); // use this line if you want to use Capture  
  video = new CaptureAxisCamera(this, "128.122.151.82", width, height, false);
  //video.start();  // you need this line if you want to use Capture
  cam = new ClutterCam(video); // create a ClutterCam associated with the video Capture
  mat = new ClutterMat(); 

  //presence = false; 

  // List all the available serial ports:
  println(Serial.list());

  // open two serial ports, one for reading, one for writing
  String servoPortName = Serial.list()[4];
  servoPort = new Serial(this, servoPortName, 9600); // open 1 serial port for writing
  String matPortName = Serial.list()[6]; 
  matPort = new Serial(this, matPortName, 9600); // open another serial port for reading
} 

void draw() { 
  if (!mat.calibration) { 
    println("Mat not calibrated yet."); 
    return;
  }


  if (!cam.calibration) { // wait until the camera is ready
    println("Camera not calibrated yet."); 
    return;
  }
  else { // sense the deviation and display a visualization
    clutter = cam.sense_deviation();
    //println("clutter is " + str(clutter));
    // write to serial port for Arduino 
    servoPort.write(clutter); // commented out while we test ClutterMat

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

void serialEvent (Serial matPort) {
  // get the byte:
  int inByte = matPort.read();
  //println("mat inByte = " + str(inByte)); 
  mat.set_current_value(inByte);

  if (mat.presence == true) { 
    if (old_presence != mat.presence) { // state transition on mat from false to true 
      entrance_clutter = clutter; // record state of clutter at start of interaction
      println("stepped on mat, trigger intro sound");
      if (whisperingclean.isPlaying() == false) {
        whisperingclean.play(0); // plays "cleeeaaan" whisper
        // whisperingclean = minim.loadFile("whisperingclean.mp3"); // reloads for next playback
      }
    }
  } 
  else if (mat.presence == false) { 
    if (old_presence != mat.presence) { // state transition on mat from true to false 
      println("stepped off mat"); 
      if (entrance_clutter < clutter) { // clutter is worse than it was at beginning of interaction
        println("trigger exit sound for increased clutter");
        if (whisperingclean.isPlaying()) {
          whisperingclean.rewind();
          whisperingclean.pause();
        }
        if (ambientsink.isPlaying() == false) {
          ambientsink.play(0); // plays ambient dishes noise
          ambientsink = minim.loadFile("ambientsink.mp3"); // reloads for next playback
        }
      }
      else if (entrance_clutter > clutter) { // clutter is better than it was at beginning of interaction
        println("trigger exit sound for decreased clutter"); // FIXME: put real sound code here
        if (whisperingclean.isPlaying()) {   
          whisperingclean.rewind();
          whisperingclean.pause();
        }
        if (ambientsink.isPlaying() == false) {
          ambientsink.play(0); // plays ambient dishes noise
          ambientsink = minim.loadFile("ambientsink.mp3"); // reloads for next playback
        }
      }
      else { 
        println("no change in clutter at exit");
        if (whisperingclean.isPlaying()) {
          whisperingclean.pause();
          whisperingclean.rewind();
        }
        if (ambientsink.isPlaying() == false) {
          ambientsink.play(0); // plays ambient dishes noise
          ambientsink = minim.loadFile("ambientsink.mp3"); // reloads for next playback
        }
      }
    }
  }
  old_presence = mat.presence;
}

