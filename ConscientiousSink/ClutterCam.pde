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
 * @author Andrew Cerrito, Jon Wasserman, and Karl Ward
 * @version 0.1
 */
class ClutterCam { 
  // attributes 
  byte clutter; // percentage of sink surface obscured, range between 0-100
  //Capture v; 
  boolean calibration = false; // calibration state, which is false until call to calibrate()
  boolean mega_calibration = false; // new calibration code using multiple frames
  List<Integer[]> mega_baseline_frame; // will contain 10 frames
  boolean capture_started = false; // whether current_frame is loaded
  int pixel_count; // number of pixels in a frame of the capture
  int baseline_frame[]; // frame with the empty sink
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
    baseline_frame = new int[pixel_count];
    current_frame = new int[pixel_count];
    diff_frame = new int[pixel_count]; 
    pre_frame = new int[pixel_count];
    exit_frame = new int[pixel_count];
    init();
  }

  // Initialization method 
  private void init() {
    if (!calibration) { 
      //println("Need to calibrate camera before sensing...");  
      //boolean cam_calibration = this.camera_calibrate();
      calibration = false; // FIXME
    }
    else { 
      println("Calibration already complete.");
    }
  }

  /**
   * Camera calibration method 
   * 
   * Record state of sink when completely empty, setting baseline_frame
   *   FIXME: provide method to do calibration on demand 
   * 
   * @return    true/false whether calibration succeeded
   */
  private boolean calibrate() { 
    arrayCopy(current_frame, baseline_frame); 
    clutter = 0; 
    println("Camera calibration complete");
    calibration = true; // FIXME
    return(true);
  }
  
  /**
   * New calibration code, which uses multiple frames instead of one. 
   *
   * @return    true/false whether calibration succeeded
   */ 
  private boolean mega_calibrate() { 
    // store up to 10 frames in mega_baseline_frame
    // stop when 10 frames are stored 
    return(true);
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
    arrayCopy(p, diff_frame); 
    println("count: " + count + " pixel count: " + pixel_count);
    clutter = byte(count/float(pixel_count)*100); 
    return(clutter);
  }

  /** 
   * Display a frame of visualization, showing the different between current and baseline
   */
  int[] show_diff() {
    return diff_frame;
  }
}

