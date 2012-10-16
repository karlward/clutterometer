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
Clutterometer cm; // will measure amount of clutter

void setup() { 
  size(640, 480); 
  video = new Capture(this, width, height, 24); // start video stream  
  video.start();
  loadPixels(); 
  cm = new Clutterometer(video);
} 

void draw() { 
  if (!cm.capture_started) { 
    println("capture not ready yet"); 
    return;
  }

  arrayCopy(cm.sense(), pixels); 
  updatePixels();
}

public void captureEvent(Capture v) {
  v.read(); 
  v.loadPixels();
  cm.set_current_frame(v.pixels); 
}

