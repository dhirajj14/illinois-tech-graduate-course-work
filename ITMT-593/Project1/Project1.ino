int bLedPin = 12;
int rLedPin = 13;
int gLedPin = 14;
int buzzer = 16;

void setup() {
  // put your setup code here, to run once:

pinMode(bLedPin, OUTPUT);
pinMode(rLedPin, OUTPUT);
pinMode(gLedPin, OUTPUT);
pinMode(buzzer, OUTPUT); 
}

void loop() {
  // put your main code here, to run repeatedly:
digitalWrite(bLedPin, HIGH);
tone(buzzer, 1000);
  delay(500);
  digitalWrite(bLedPin, LOW);
  digitalWrite(rLedPin, HIGH);
  tone(buzzer, 2000);
  delay(500);
  digitalWrite(rLedPin, LOW);
  digitalWrite(gLedPin, HIGH);
  tone(buzzer, 3000);
  delay(500);
  digitalWrite(gLedPin, LOW);
}
