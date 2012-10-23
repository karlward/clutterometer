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
import java.awt.*;

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
  int clutter; // percentage of sink surface obscured, range between 0-100
  //Capture v; 
  boolean calibration = false; // calibration state (indicates if we have a baseline)
  ArrayList<int[]> baseline_dframe; // a decaframe containing multiple frames, showing the empty sink
  int dframe_size = 10; // size of baseline_dframe ArrayList
  boolean capture_started = false; // whether current_frame is loaded
  int pixel_count; // number of pixels in a frame of the capture
  int current_frame[]; // the latest frame from the capture
  int diff_frame[]; // a visualization of the deviation from the baseline_frame
  int pre_frame[]; // frame with state just before entrance
  int exit_frame[]; // frame with the state at exit
  
  // a polygon that identifies the area we want the camera to view
  Polygon view;


  /**
   * Class constructor.
   * NOTE: real sink must be empty when constructor is called.
   * @param  v    a CaptureAxisCamara object
   */
  ClutterCam(Capture v) { // if using Capture, you need to change this to ClutterCam(Capture v) { 
//  ClutterCam(CaptureAxisCamera v) { // if using Capture, you need to change this to ClutterCam(Capture v) { 
    pixel_count = v.width * v.height; 
    baseline_dframe = new ArrayList<int[]>(); 
    baseline_dframe.ensureCapacity(dframe_size); // holds multiple frames instead of one
    current_frame = new int[pixel_count];
    diff_frame = new int[pixel_count]; 
    pre_frame = new int[pixel_count];
    exit_frame = new int[pixel_count];
   
    // the are we want the camera to view
    int[] x = { 20, 600, 600, 20 }; // the x coordinates of the polygon's points
    int[] y = { 20, 20, 400, 400 }; // the y coordinates of the polygon's points 
    view = new Polygon(x, y, 4); 
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
    if (!calibration && baseline_dframe.size() < dframe_size) { 
      final int[] copy_frame = new int[pixel_count]; // final because it will go into an ArrayList
      arrayCopy(current_frame, copy_frame); 
      baseline_dframe.add(copy_frame); 
      //println("trying... " + str(baseline_dframe.size()));
    }
    if (baseline_dframe.size() == dframe_size) {
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
   * Compare current frame to baseline frames, pixel by pixel, looking for deviation
   *
   *  allowing for small deviations for R, G, and B values
   * 
   * @return    number indicating the percentage of deviation from baseline
   */
  int sense_deviation() {
    int count = 0; 
    int p[] = new int[pixel_count]; 
    for (int i = 0; i < pixel_count; i++) { 
      int same_count = 0; 
      color current_pixel = current_frame[i]; 
 
      // iterate through all baseline frames, comparing R, G, and B
      boolean same = false;
      for (int[] baseline_frame : baseline_dframe) { 
        color baseline_pixel = baseline_frame[i]; 
      
        if (compare_pixel(current_pixel, baseline_pixel) == true) { 
          same_count++; // this could be optimized with a break statement 
        }
      }
      //if (same_count >= (baseline_dframe.size() / 2)) { // more than half are the same 
      if (same_count > 0) { // current pixel is same in at least 1 baseline frame 
        same = true; 
      } 
      else { same = false; } 
      if (same) { 
        p[i] = color(255, 255, 255); // set pixel to white, meaning no change
      } 
      else { 
        count++;
        p[i] = color(0, 0, 0); // set pixel to black, meaning change
      } 
      // test: discard pixels outside of the view polygon
      // for now we just mark them with color static
      int p_x = i % width; // I think this works for calculating the x coordinate
      int p_y = int(i / height); // I think this works for calculating the y coordinate 
      if (!(view.contains(p_x, p_y))) { 
        p[i] = color(int(random(0,255)), int(random(0,255)), int(random(0,255))); 
      }
    }
    arrayCopy(p, diff_frame); 
    clutter = int(count/float(pixel_count)*100); 
    return(clutter);
  }

  private boolean compare_pixel(color pixel_1, color pixel_2) { 
    boolean result = false; // will hold result of comparison
    if (pixel_1 == pixel_2) { // cheap comparison
      result = true; 
    }
    else { // do expensive comparisons 
      // Extract the red, green, and blue components from first pixel
      int r_1 = (pixel_1 >> 16) & 0xFF; // Like red(), but faster
      int g_1 = (pixel_1 >> 8) & 0xFF;
      int b_1 = pixel_1 & 0xFF;
      // Extract red, green, and blue components from second pixel
      // FIXME: make it work with range or average instead of single value
      int r_2 = (pixel_2 >> 16) & 0xFF;
      int g_2 = (pixel_2 >> 8) & 0xFF;
      int b_2 = pixel_2 & 0xFF;
      // if R, G, and B values are close, consider them the same
      // 10 is an arbitrary value
      if ( (abs(r_1 - r_2) < 10) && (abs(g_1 - g_2) < 10) && (abs(b_1 - b_2) < 10) ) { 
        result = true; 
      }
      else { 
        result = false; 
      } 
    }
    return(result); 
  }

  /** 
   * Return a frame of visualization, showing the different between current and baseline
   */
  int[] show_diff() {
    return diff_frame;
  }
}

