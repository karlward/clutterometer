
int fsrValue;  // int to store FSR reading
byte mappedValue; // FSR reading constrained to 0-255, safeguard against overflow
void setup() {
  // open serial communications at 9600 bps
  Serial.begin(9600);
}

void loop() {
  // read the sensor:
  fsrValue = analogRead(A0)/4; // divide to 0-255 range
  mappedValue = byte(constrain(fsrValue,0,255)); // extra measure against overflow
//  if (fsrValue <=200) {
//    mappedValue = 0;
//   // Serial.write(0);
//  } 
//  else {
//    mappedValue = 1;
//    //Serial.write(1);
//  }
//  Serial.write(fsrValue);
Serial.write(mappedValue);
}




