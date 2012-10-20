//const int redLED = 10;     // pin that the red LED is on
const int greenLED = 9;   // pin that the green LED is on
int rightSensorValue = 0;  // value read from the right analog sensor
//int leftSensorValue = 0;   // value read from the left analog sensor

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
  // declare the led pins as outputs:
 // pinMode(redLED, OUTPUT);
  pinMode(greenLED, OUTPUT);
}

void loop() {
  rightSensorValue = analogRead(A0)/10; // read the pot value

  analogWrite(greenLED, rightSensorValue);  // set the LED brightness with the result
  Serial.println(rightSensorValue);   // print the sensor value back to the serial monitor
}


