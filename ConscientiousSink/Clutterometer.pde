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

  // compare current state to baseline and initial state
  void sense() {
  }
}

