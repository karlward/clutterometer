#include <Servo.h>      // include the servo library

Servo servoMotor;       // creates an instance of the servo object to control a servo

const int INVITATION = 127; // handshake invitation message
const int MAT = A1; // the mat sensor is connected to this pin
const int SERVO = 2; // the servo is connected to this pin

boolean myTurn = true; // whether it is my turn to write 

int clutter = 0; // the amount of clutter, sent via serial FROM Processing
int presence = 0; // whether someone is on the mat, sent via serial TO Processing
int i = 0; 

void setup() {
  pinMode(SERVO, OUTPUT);  
  // open serial communications
  Serial.begin(1200);
  servoMotor.attach(SERVO); 
  //delay(300);
  establishContact();
}

void loop() {
  presence = readMat(); 

  if (myTurn) {
    sendData();
  } 
  else {
    readData();
  }
}

void establishContact() {   
  Serial.write(INVITATION);   // send a starting message
  Serial.flush();
  myTurn = false;
  delay(10); 
}

void sendData() {
  presence = readMat(); // read the mat sensor   
  Serial.write(presence);
  myTurn = false;
}

void readData() {
  clutter = Serial.read();
  // replace digitalWrite with servo code
  if (i == 10) { 
    int servoAngle = map(clutter, 0, 100, 0, 179);
    servoMotor.write(servoAngle); 
  }
  
  i++; 
  if (i > 10) { 
    i = 0; 
  }
  myTurn = true;
}

int readMat() { 
  int matReading = analogRead(MAT); 
  //Serial.println(matReading); // remove
  if (matReading > 300) { 
    return(1); 
  } 
  else {
    return(0); 
  } 
}

