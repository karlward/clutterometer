
int leftSensor, rightSensor;  // ints for left and right FSR

void setup() {
  // open serial communications at 9600 bps
  Serial.begin(9600);
  establishContact();
}

void loop() {
  if (Serial.available() > 0) {
     // read the incoming byte:
    int inByte =Serial.read();
    
   // read the sensor:
   leftSensor =analogRead(A0)/4;
   // print the results:
  Serial.print(leftSensor, DEC);
  Serial.print(",");

   // read the sensor:
  rightSensor =analogRead(A1)/4;
   // print the results:
  Serial.println(rightSensor, DEC);
   }
}


void establishContact() {
 while (Serial.available() <= 0) {
      Serial.println("hello");   // send a starting message
      delay(300);
   }
 }


