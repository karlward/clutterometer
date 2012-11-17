
import ddf.minim.*;
import processing.serial.*;

Minim minim;
AudioPlayer clean;


int leftSensor = 0;
int rightSensor = 0;     // FSR readings will get assigned to these
boolean firstContact = false; // Have we heard from the microcontroller

Serial myPort;

void setup () {
  size(100, 100);
   minim = new Minim(this);
  clean = minim.loadFile("whisperingclean.wav");

  // List all available serial ports
  println(Serial.list()); 
  String portName = Serial.list()[4];
  myPort = new Serial(this, portName, 9600); //opens the serial port
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
}

void draw() {
  if (firstContact == true) {
    soundCheck();
  }
}

void soundCheck() {
  if (leftSensor >= 100 || rightSensor >= 100) {
    if (clean.isPlaying() == false) {
     clean.play(0);
    }
  }
}

void serialEvent(Serial myPort) { 
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
  if (myString != null) {

    myString = trim(myString);

    // if you haven't heard from the microncontroller yet, listen:
    if (firstContact == false) {
      if (myString.equals("hello")) { 
        myPort.clear();          // clear the serial port buffer
        firstContact = true;     // you've had first contact from the microcontroller
        myPort.write('A');       // ask for more
      }
    } 
    // if you have heard from the microcontroller, proceed:
    else {
      // split the string at the commas
      // and convert the sections into integers:
      int sensors[] = int(split(myString, ','));

      // print out the values you got:
      for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
        print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
      }
      // add a linefeed after all the sensor values are printed:
      println();
      if (sensors.length > 1) {
        leftSensor = sensors[0];
        rightSensor = sensors[1];
      }
     // leftSensor = 0; 
      //rightSensor = 255;
    }
    // when you've parsed the data you have, ask for more:
    myPort.write("A");
  }
}

