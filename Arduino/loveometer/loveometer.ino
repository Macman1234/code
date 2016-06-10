const int SENSOR_PIN = A0;
const float BASELINETEMP = 25;

void setup() {
  Serial.begin(9600);

  for(int pin = 2; pin < 5; pin++) {
    pinMode(pin, OUTPUT);
    digitalWrite(pin, LOW);
  }
}

void loop() {
  int sensorValue = analogRead(SENSOR_PIN);
  Serial.print("sensor value: ");
  Serial.print(sensorValue);  

  //Convert ADC value to voltage
  float voltage = sensorValue / 1024.0 * 5;
  Serial.print(", voltage: ");
  Serial.print(voltage);

  //Convert ADC value to voltage
  float temp = (voltage - 0.5) * 100;
  Serial.print(", temp: ");
  Serial.println(temp);

  for(int pin = 2; pin < 5; pin++) {
    digitalWrite(pin, (temp > BASELINETEMP + (pin - 2) * 2) ? HIGH : LOW );
  }

  delay(50);
}

