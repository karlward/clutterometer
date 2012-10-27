
const int INVITATION = 127; // handshake invitation 
boolean myTurn = true;
int send = 1; 
int newByte;
int presence = 0; 

void setup() {
  pinMode(13, OUTPUT); // for blink test 
  // open serial communications at 9600 bps
  Serial.begin(9600);
  delay(300);
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
  Serial.write(INVITATION);   // send a starting message
  Serial.flush();
  myTurn = false;
  delay(10); 
}

void sendData() {
  if (presence == 0) { presence = 1; } 
  else { presence = 0; }
  Serial.write(presence);
  myTurn = false;
}

void readData() {
  newByte = Serial.read();
  if (newByte > 50) { 
    digitalWrite(13, HIGH);
  }
  else { 
    digitalWrite(13, LOW);
  }
  myTurn = true;
}


