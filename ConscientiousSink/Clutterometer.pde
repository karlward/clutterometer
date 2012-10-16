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

class Clutterometer { 
  // attributes 
  byte clutter; // percentage of sink surface obscured, range between 0-100
  //Capture v; 
  boolean calibration = false; // calibration state, which is false until call to calibrate()
  boolean capture_started = false; // whether current_frame is loaded
  int array_size; // number of pixels in a frame of the capture
  int baseline_frame[]; // frame with the empty sink
  int current_frame[]; // the latest frame from the capture
  int diff_frame[]; // a visualization of the deviation from the baseline_frame
  int pre_frame[]; // frame with state just before entrance
  int exit_frame[]; // frame with the state at exit

  // Constructor method
  //   NOTE: real sink must be empty, and mat must be unloaded, when constructor is called 
  //   FIXME: provide interface to do calibration on demand 
  Clutterometer(Capture v) {
    array_size = v.width * v.height; 
    baseline_frame = new int[array_size];
    current_frame = new int[array_size];
    diff_frame = new int[array_size]; 
    pre_frame = new int[array_size];
    exit_frame = new int[array_size];
    this.init();
  }

  // Initialization method 
  private void init() {
    if (!calibration) { 
      //println("Need to calibrate camera before sensing...");  
      //boolean cam_calibration = this.camera_calibrate();
      boolean cam_calibration = false; // FIXME
      println("Need to calibrate mat before sensing..."); 
      boolean mat_calibration = this.mat_calibrate(); 

      // set calibration attribute to true if both camera and mat are calibrated
      //calibration = (cam_calibration && mat_calibration);
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
    calibration = true; // FIXME
    return(true);
  }

  // Mat initialization method 
  //   like a "tare" of the mat, listen to its unloaded state for a bit
  private boolean mat_calibrate() { 
    // FIXME: mat calibration code here
    println("Mat calibration complete."); 
    return(true);
  }

  void set_current_frame(int p[]) { 
    arrayCopy(p, current_frame); 
    capture_started = true; 
    if (!calibration) { 
      camera_calibrate();
    }
  }

  // Compare current frame to baseline frame, pixel by pixel
  //  allowing for small deviations for R, G, and B values
  byte cam_sense() {
    int count = 0; 
    int p[] = new int[array_size]; 
    for (int i = 0; i < array_size; i++) { 
      color current_pixel = current_frame[i]; 
      color baseline_pixel = baseline_frame[i]; 
      // Extract the red, green, and blue components from current pixel
      int current_r = (current_pixel >> 16) & 0xFF; // Like red(), but faster
      int current_g = (current_pixel >> 8) & 0xFF;
      int current_b = current_pixel & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int baseline_r = (baseline_pixel >> 16) & 0xFF;
      int baseline_g = (baseline_pixel >> 8) & 0xFF;
      int baseline_b = baseline_pixel & 0xFF;
      if ( (abs(current_r - baseline_r) < 10) && (abs(current_g - baseline_g) < 10) && (abs(current_b - baseline_b) < 10) ) { 
        p[i] = color(255, 255, 255); 
        //p[i] = color(int(random(255)),int(random(255)),int(random(255)));
        //p[i] = current_frame[i];
      }
      else { 
        count += 1; 
        p[i] = color(0, 0, 0);
      }
    }
    arrayCopy(p, cm.diff_frame); 
    println("count: " + count + ", array_size: " + array_size);
    clutter = byte(count/float(array_size)*100); 
    return(clutter);
  }

  int[] show_diff() {
    return diff_frame;
  }
}

