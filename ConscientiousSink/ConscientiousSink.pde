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
    println("capture not ready yet"); 
    return;
  }

//  arrayCopy(cm.baseline_frame, pixels);
  for (int i = 0; i < array_size; i++) { 
//    if (current_frame[i] != cm.baseline_frame[i]) { 
//      pixels[i] = current_frame[i];
//    }
    color current_pixel = current_frame[i]; 
    color baseline_pixel = cm.baseline_frame[i]; 
    // Extract the red, green, and blue components from current pixel
    int current_r = (current_pixel >> 16) & 0xFF; // Like red(), but faster
    int current_g = (current_pixel >> 8) & 0xFF;
    int current_b = current_pixel & 0xFF;
    // Extract red, green, and blue components from previous pixel
    int baseline_r = (baseline_pixel >> 16) & 0xFF;
    int baseline_g = (baseline_pixel >> 8) & 0xFF;
    int baseline_b = baseline_pixel & 0xFF;
    if ( (abs(current_r - baseline_r) < 10) && (abs(current_g - baseline_g) < 10) && (abs(current_b - baseline_b) < 10) ) { 
      pixels[i] = color(int(random(255)),int(random(255)),int(random(255)));
      //pixels[i] = current_frame[i]; 
    }
    else { 
      pixels[i] = color(0,0,0); 
    }
  }
  updatePixels();
}

public void captureEvent(Capture v) {
  v.read(); 
  v.loadPixels();
  arrayCopy(v.pixels, current_frame); 
  capture_started = true;
  if (!cm.calibration) { // set baseline_frame 
    cm.camera_calibrate();
  }
  //println("capture ready"); 
  //image(v, 0, 0);
}

