//CLUTTER SERVO

#include <Servo.h>      // include the servo library

Servo servoMotor;       // creates an instance of the servo object to control a servo
int servoPin = 2;       // Control pin for servo motor
int servoAngle;

void setup() {
  Serial.begin(9600);       // initialize serial communications
  servoMotor.attach(servoPin);  // attaches the servo on pin 2 to the servo object
}

void loop()
{
  if (Serial.available() > 0) {
    // read the incoming byte:
    int inByte =Serial.read();
    // then map the inByte to an int 0-180
    // then analogWrite that value to whichever pin is connecting the servo to the arduino
    servoAngle = map(inByte,0,100,0,180);
   
  


  }

  // if your sensor's range is less than 0 to 1023, you'll need to
  // modify the map() function to use the values you discovered:
  //int servoAngle = map(analogValue, 200, 300, 0, 180);


  // move the servo using the angle from the sensor:
  servoMotor.write(servoAngle); 

}

