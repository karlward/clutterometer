
boolean myTurn = true;
int send = 1; 
int newByte;


void setup() {
  // open serial communications at 9600 bps
  Serial.begin(9600);
  establishContact();
}

void loop() {
  if (myTurn) {
    sendData();
  } 
  else {
    readData();
  }

}


void establishContact() {   
  Serial.write('a');   // send a starting message
  Serial.flush();
  myTurn = false;

}

void sendData() {
  Serial.write(newByte);
myTurn = false;
}

void readData() {
  newByte = Serial.read();
  myTurn = true;
}


