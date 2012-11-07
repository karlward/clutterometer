#include <Servo.h>      // include the servo library

Servo servoMotor;       // creates an instance of the servo object to control a servo

const int SERVO = 2; // the servo is connected to this pin

int clutter = 0; // the amount of clutter, sent via serial FROM Processing
long now = 0; 

void setup() {
  pinMode(SERVO, OUTPUT);  
  // open serial communications
  Serial.begin(9600);
  servoMotor.attach(SERVO); 
  delay(300);
}

void loop() {
  now = millis(); 
  readData();
}

void readData() {
  if (Serial.available() > 0) { 
    clutter = Serial.read();
    if (now % 500 < 100) { // write servo position approx every .5 seconds
      int servoAngle = map(clutter, 0, 100, 179, 0);
      servoMotor.write(servoAngle); 
    }
  }
}


