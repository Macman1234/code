const int GREEN_LED_PIN = 9;
const int RED_LED_PIN = 10;
const int BLUE_LED_PIN = 11;

const int RED_SENSOR_PIN = A0;
const int GREEN_SENSOR_PIN = A1;
const int BLUE_SENSOR_PIN = A2;

int redValue, greenValue, blueValue;
int redSensorValue, greenSensorValue, blueSensorValue;

void setup() {
  Serial.begin(9600);
  redValue = greenValue = blueValue = 0;
  redSensorValue = greenSensorValue = blueSensorValue = 0;
  
  pinMode(GREEN_LED_PIN, OUTPUT);
  pinMode(RED_LED_PIN, OUTPUT);
  pinMode(BLUE_LED_PIN, OUTPUT);
}

void loop() {
  const int DELAY = 5;
  
  redSensorValue = analogRead(RED_SENSOR_PIN);
  delay(DELAY);
  
  greenSensorValue = analogRead(GREEN_SENSOR_PIN);
  delay(DELAY);
  
  blueSensorValue = analogRead(BLUE_SENSOR_PIN);
  
  Serial.print("Raw sensor values red: ");
  Serial.print(redSensorValue);
  
  Serial.print(", green: ");
  Serial.print(greenSensorValue);
  
  Serial.print(", blue: ");
  Serial.print(blueSensorValue);
  
  
  redValue = max(0, min(redSensorValue * 1.4 - 840, 255));
  greenValue = max(0, min(greenSensorValue * 0.9 - 400, 255));
  blueValue = max(0, min(blueSensorValue * 0.8 - 250, 255));

  Serial.print(". Mapped to red: ");
  Serial.print(redValue);

  Serial.print(", green: ");
  Serial.print(greenValue);

  Serial.print(", blue: ");
  Serial.println(blueValue);
  
  analogWrite(RED_LED_PIN, redValue);
  analogWrite(GREEN_LED_PIN, greenValue);
  analogWrite(BLUE_LED_PIN, blueValue);
}
  
