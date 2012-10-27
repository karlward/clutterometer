
const int INVITATION = 127; // handshake invitation 
boolean myTurn = true;
int send = 1; 
int clutter = 0; // the amount of clutter, sent via serial FROM Processing
int presence = 0; // whether someone is on the mat, sent via serial TO Processing

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
  clutter = Serial.read();
  // replace digitalWrite with servo code 
  if (clutter > 50) { digitalWrite(13, HIGH); }
  else { digitalWrite(13, LOW); }
  myTurn = true;
}


