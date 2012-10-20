const int redLED = 9;     // pin that the red LED is on
const int greenLED = 10;   // pin that the green LED is on
int rightSensorValue = 0;  // value read from the right analog sensor
int leftSensorValue = 0;   // value read from the left analog sensor

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
  // declare the led pins as outputs:
  pinMode(redLED, OUTPUT);
  pinMode(greenLED, OUTPUT);
}

void loop() {
  rightSensorValue = analogRead(A0)/4; // read the pot value
  Serial.println(rightSensorValue);   // print the sensor value back to the serial monitor
  analogWrite(redLED, rightSensorValue);

  // now do the same for the other sensor and LED:
  leftSensorValue = analogRead(A1)/4; // read the pot value
  analogWrite(greenLED, leftSensorValue);  // set the LED brightness with the result
  Serial.println(leftSensorValue);   // print the sensor value back to the serial monitor
}


