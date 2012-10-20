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

CaptureAxisCamera video; // video stream
ClutterCam cam; // will measure amount of clutter

void setup() { 
  size(640, 480); 
  //video = new Capture(this, width, height, 24); // use this line if you want to use Capture  
  video = new CaptureAxisCamera(this, "128.122.151.82", width, height, false);
  //video.start();  // you need this line if you want to use Capture
  cam = new ClutterCam(video); // create a ClutterCam associated with the video Capture
} 

void draw() { 
  if (!cam.calibration) { // wait until the camera is ready
    println("Camera not calibrated yet."); 
    return;
  }
  else { // sense the clutter and display a visualization
    byte clutter = cam.sense();
    println(clutter);
    for (int[] frame : cam.baseline_dframe) { // iterate through each frame in baseline_dframe
      loadPixels(); 
      arrayCopy(cam.show_diff(), pixels); // FIXME: need to fix sense() and show_diff()
      updatePixels();
    }
  }
}

public void captureEvent(CaptureAxisCamera v) {
  v.read(); 
  v.loadPixels();
  cam.set_current_frame(v.pixels);
}

