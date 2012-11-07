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

class ClutterMat { 
  boolean presence; 
  boolean calibration; 
  int current_value; 
  int sample_size; 
  int avg_value; 
  ArrayList<Integer> latest_values;  

  ClutterMat() { 
    presence = false; 
    calibration = false; 
    sample_size = 20; // how many values of the mat reading we will use in the average
    latest_values = new ArrayList<Integer>();
    latest_values.ensureCapacity(sample_size); 
  }

  void set_current_value (int value) { 
    current_value = value; 
    if (latest_values.size() == sample_size) { // keep up to sample_size number of values 
      calibration = true; 
      //println("Mat calibration complete."); 
      latest_values.remove(9); // remove last item from end of array
    } 
    latest_values.add(0, value); // add latest value at the beginning of array

    // calculate average of latest values 
    int sum = 0; 
    for (int this_value : latest_values) {
      sum += this_value; // add them all up
    }
    avg_value = int(sum / latest_values.size()); // divide by number of values to get average
    if (avg_value > 90) { // someone is standing on the mat 
      presence = true; 
    } 
    else { 
      presence = false; 
    }
  }

  

  int get_current_value() { 
    if (latest_values.size() == 0) { // no values yet, so no average 
      return(0);
    } 
    return avg_value;
  }

  private boolean calibrate() { 
    boolean cal_status; 
    cal_status = false;  // FIXME: implement a real calibration method and cal_status value
    return cal_status;
  }
}

