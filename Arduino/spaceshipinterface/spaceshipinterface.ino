int switchState = 0;
int timeInterval = 100;

void setup() {
  for(int i = 3; i < 6;++i)
    pinMode(i, OUTPUT);
  pinMode(2, INPUT);
}

void loop() {
  switchState = digitalRead(2);

  for(int j = 3; j < 6;++j){
    digitalWrite(j, (switchState == LOW)? HIGH : LOW);
  }
  
  if(switchState == HIGH) {
    for(int i = 3; i < 6;++i) {
      for(int j = 3; j < 6;++j){
        digitalWrite(j, LOW);
      }
      digitalWrite(i, HIGH);
      delay(timeInterval);
    }
  }
}






