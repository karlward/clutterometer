import processing.serial.*;

Serial servoPort;
Serial matPort;

void setup () {
  size(300, 300);
  background(12, 23, 82);
  // List all available serial ports
  println(Serial.list()); 
  String servoPortName = Serial.list()[4];
  servoPort = new Serial(this, servoPortName, 9600); // open 1 serial port for writing
  String matPortName = Serial.list()[6]; 
  matPort = new Serial(this, matPortName, 9600); // open another serial port for reading
}

void draw() {
  int percentage = int(random(100)); 
  servoPort.write(percentage); 
  println("sending clutterometer percentage " + str(percentage));
}

// whenever data comes from mat board, it gets read here
void serialEvent(Serial matPort) { 
  int inByte = matPort.read();
  // should be 0 or 1
  println(inByte);
}
