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

/** 
 * ClutterCam interprets video data to determine how cluttered a scene is.
 * 
 * "Clutter" is considered deviation from baseline.  We'll see how well 
 * that works. 
 * 
 * @author Andrew Cerrito, Jon Wasserman, and Karl Ward
 * @version 0.1
 */
class ClutterCam { 
  // attributes 
  byte clutter; // percentage of sink surface obscured, range between 0-100
  //Capture v; 
  boolean calibration = false; // calibration state (indicates if we have a baseline)
  ArrayList<int[]> baseline_dframe; // a decaframe containing 10 frames, showing the empty sink
  boolean capture_started = false; // whether current_frame is loaded
  int pixel_count; // number of pixels in a frame of the capture
  int current_frame[]; // the latest frame from the capture
  int diff_frame[]; // a visualization of the deviation from the baseline_frame
  int pre_frame[]; // frame with state just before entrance
  int exit_frame[]; // frame with the state at exit

  /**
   * Class constructor.
   * NOTE: real sink must be empty when constructor is called.
   * @param  v    a Capture (or CaptureAxis later) object
   */
  ClutterCam(Capture v) {
    pixel_count = v.width * v.height; 
    baseline_dframe = new ArrayList<int[]>(); 
    baseline_dframe.ensureCapacity(10); // decaframe, holding 10 frames instead of one
    current_frame = new int[pixel_count];
    diff_frame = new int[pixel_count]; 
    pre_frame = new int[pixel_count];
    exit_frame = new int[pixel_count];
    //init();
  }

  // Initialization method 
//  private void init() {
//    if (!calibration) { 
//      //println("Need to calibrate camera before sensing...");  
//      //boolean cam_calibration = this.camera_calibrate();
//      calibration = false; // FIXME
//    }
//    else { 
//      println("Calibration already complete.");
//    }
//  }

  /**
   * Camera calibration method 
   * 
   * Record state of sink when completely empty, setting baseline_frame
   *   FIXME: provide method to do calibration on demand 
   * 
   * @return    true/false whether calibration succeeded
   */
  private boolean calibrate() { 
    // store 10 frames in baseline_frame
    if (!calibration && baseline_dframe.size() < 10) { 
      final int[] copy_frame = new int[pixel_count]; // final because it will go into an ArrayList
      arrayCopy(current_frame, copy_frame); 
      baseline_dframe.add(copy_frame); 
      println("trying... " + str(baseline_dframe.size()));
    }
    if (baseline_dframe.size() == 10) {
      calibration = true; 
      println("Camera calibration complete"); 
    }
    return(calibration);
  }

  /** 
   * Set the object's current_frame attribute to a pixel array
   *
   * @param  p    pixel array (array of int)
   */
  void set_current_frame(int p[]) { 
    arrayCopy(p, current_frame); 
    capture_started = true; 
    if (!calibration) { 
      calibrate();
    }
  }

  /**
   * Compare current frame to baseline frame, pixel by pixel
   *
   *  allowing for small deviations for R, G, and B values
   * 
   * @return    number indicating the percentage of deviation from baseline
   */
  byte sense() {
    int count = 0; 
    int p[] = new int[pixel_count]; 
    for (int i = 0; i < pixel_count; i++) { 
      color current_pixel = current_frame[i]; 
      color baseline_pixel = baseline_dframe.get(0)[i]; 
      // Extract the red, green, and blue components from current pixel
      int current_r = (current_pixel >> 16) & 0xFF; // Like red(), but faster
      int current_g = (current_pixel >> 8) & 0xFF;
      int current_b = current_pixel & 0xFF;
      // Extract red, green, and blue components from previous pixel
      // FIXME: make it work with range or average instead of single value
      int baseline_r = (baseline_pixel >> 16) & 0xFF;
      int baseline_g = (baseline_pixel >> 8) & 0xFF;
      int baseline_b = baseline_pixel & 0xFF;
      if ( (abs(current_r - baseline_r) < 10) 
           && (abs(current_g - baseline_g) < 10) 
           && (abs(current_b - baseline_b) < 10) ) { 
        p[i] = color(255, 255, 255); // set pixel to white, meaning no change
      }
      else { 
        count += 1; 
        p[i] = color(0, 0, 0); // set pixel to black, meaning change
      }
    }
    arrayCopy(p, diff_frame); 
    clutter = byte(count/float(pixel_count)*100); 
    return(clutter);
  }

  /** 
   * Return a frame of visualization, showing the different between current and baseline
   */
  int[] show_diff() {
    return diff_frame;
  }
}

