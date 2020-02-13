int buzzer = 16;
long ran;
int buzzTone;
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
  switch(ran){
    case 12:
      buzzTone = 1000;
      break;
    case 13:
      buzzTone = 500;
    case 14:
      buzzTone = 3000;  
    }
  digitalWrite(ran, HIGH); //Makes LED glow
  tone(buzzer, buzzTone); //Makes Buzzer to produce tone at 1000
  delay(500); //Delay 0f 5ms
  tone(buzzer, 0);
  digitalWrite(ran, LOW); //Makes LED off
  delay(200); //Delay for the transition between LEDs
  
}
