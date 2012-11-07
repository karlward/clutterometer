
int fsrValue;  // int to store FSR reading
byte mappedValue; // FSR reading mapped to 0 or 1

void setup() {
  // open serial communications at 9600 bps
  Serial.begin(9600);
}

void loop() {
  // read the sensor:
  fsrValue = analogRead(A0);
  if (fsrValue <=200) {
    mappedValue = 0;
   // Serial.write(0);
  } 
  else {
    mappedValue = 1;
    //Serial.write(1);
  }
  Serial.write(mappedValue);
}




