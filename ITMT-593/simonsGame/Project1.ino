int buzzer = 16;
long ran;
void setup() {
  // put your setup code here, to run once:

pinMode(12, OUTPUT); //Blue Led Pin 
pinMode(13, OUTPUT); //Red Led Pin
pinMode(14, OUTPUT); //Green Led Pin
pinMode(buzzer, OUTPUT); //pin 16 - Buzzer Pin
}

void loop() {
  // put your main code here, to run repeatedly:
  ran = random(12,15); //Random fuction to generate numbers between 12 to 15 randomly
  digitalWrite(ran, HIGH); //Makes LED glow
  tone(buzzer, 1000); //Makes Buzzer to produce tone at 1000
  delay(500); //Delay 0f 5ms
  digitalWrite(ran, LOW); //Makes LED off
  delay(200); //Delay for the transition between LEDs
  ran = random(12,15); //Random fuction to generate numbers between 12 to 15 randomly
  digitalWrite(ran, HIGH); //Makes LED glow
  tone(buzzer, 2000); //Makes Buzzer to produce tone at 2000
  delay(500); //Delay 0f 5ms
  digitalWrite(ran, LOW);
  delay(200); //Delay for the transition between LEDs
  ran = random(12,15); //Random fuction to generate numbers between 12 to 15 randomly
  digitalWrite(ran, HIGH); //Makes LED glow
  tone(buzzer, 3000); //Makes Buzzer to produce tone at 3000
  delay(500);//Delay 0f 5ms
  digitalWrite(ran, LOW); //Makes LED glow
  delay(200); //Delay for the transition between LEDs
}
