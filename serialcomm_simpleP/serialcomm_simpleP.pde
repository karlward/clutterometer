import processing.serial.*;

boolean myTurn = false;
final int INVITATION = 127; // what we listen for during the handshake 
final int REPLY = 126; // what we reply with when we see the handshake invitation

Serial myPort;

void setup () {
  size(300, 300);
  background(12, 23, 82);
  // List all available serial ports
  println(Serial.list()); 
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 1200); //opens the serial port
}

void draw() {
}


void serialEvent(Serial myPort) { 
  if (myTurn) { // write clutterometer position to serial
    int percentage = int(random(100)); 
    myPort.write(percentage); 
    //println("sending clutterometer percentage " + str(percentage)); 
    myTurn = false;
  }
  else { // not my turn, so listen to serial port
    // listen for handshake invitation
    int inByte = myPort.read(); 

    // if handshake received, transmit handshake reply 
    if (inByte == INVITATION) { 
      println("I got an INVITATION"); 
      myTurn = true; 
      myPort.write(REPLY); 
      println("I sent a REPLY"); 
      myTurn = false;
    }
    else { // not handshake, listen for floormat value 
      if (inByte == 0) { 
        //println("nobody on the mat");
      } 
      else if (inByte == 1) { 
        println("somebody on the mat");
      }
      else { 
        println("garbage data: " + str(inByte));
      }
      myTurn = true; 
    }
  }
}

