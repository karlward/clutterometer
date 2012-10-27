
import processing.serial.*;

boolean myTurn = false;
boolean firstContact = false; // Have we heard from the microcontroller

Serial myPort;

void setup () {
  size(300, 300);
  background(12, 23, 82);
  // List all available serial ports
  println(Serial.list()); 
  String portName = Serial.list()[4];
  myPort = new Serial(this, portName, 9600); //opens the serial port
  // read bytes into a buffer until you get a linefeed (ASCII 10):
}

void draw() {
}


void serialEvent(Serial myPort) { 
  if (!myTurn) {
    int myByte = myPort.read();
    myTurn = true;
    // checks if there's actual data there
    if (myByte >= 0) {

      // if you haven't heard from the microncontroller yet, listen:
      if (firstContact == false) {
        if (myByte == 'a') { 
          myPort.clear();          // clear the serial port buffer
          firstContact = true;     // you've had first contact from the microcontroller
          myPort.write('b');       // ask for more
          println(myByte);
          myTurn = false;
        }
      }
    }
    // if you have heard from the microcontroller, proceed:
    else if (myTurn) {
      println(myByte);
    }
  }
}

