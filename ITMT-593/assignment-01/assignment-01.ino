int buzzer = 16;
long ran;
int buzzTone;
String answerArray[3];
String guessArray[3];
boolean victoryFlag = false; // flag to check victory condition
int flag = 0;
int score = 0;
int turnCounter = 0;
// end of item setup
String buttonAnsArray[] = {"blue", "red", "green"};


void setup() {
  // put your setup code here, to run once:
pinMode(12, OUTPUT); //Blue Led Pin 
pinMode(13, OUTPUT); //Red Led Pin
pinMode(14, OUTPUT); //Green Led Pin
pinMode(15, INPUT); //Blue Button Pin 
pinMode(5, INPUT); //Red Button Pin
pinMode(4, INPUT); //Green Button Pin
pinMode(buzzer, OUTPUT); //pin 16 - Buzzer Pin
Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

  
  if(flag == 0){
     if(score <= 5){
      gamePlay(500);
     }

     if(score > 5 && score<=10){
      gamePlay(300);
     }

     if(score > 10 && score<=15){
      gamePlay(200);
     }
  }

    if (digitalRead(15) == HIGH) {
      guessArray[turnCounter]= "blue";
      turnCounter++;
      Serial.println(turnCounter); 
       Serial.println("blue"); 
       glowLed(14);
       delay(300);
    } 
    if (digitalRead(5) == HIGH) {
      guessArray[turnCounter]= "red";
      turnCounter++;
      Serial.println(turnCounter); 
       Serial.println("red"); 
        glowLed(13);
        delay(300);
    } 
    if (digitalRead(4) == HIGH) {
      guessArray[turnCounter]= "green";
      turnCounter++;
      Serial.println(turnCounter); 
       Serial.println("green"); 
        glowLed(12);
        delay(300);
    } 

if(turnCounter == 3){
for (int x = 0; x < 3; x++) {
     if (answerArray[x]==guessArray[x]) { 
       victoryFlag=true;
     } else {
        Serial.println("you lose!");
        score=0;
        tone(buzzer,4000);
        delay(1000);
        tone(buzzer,0);
        delay(300);
       victoryFlag=false;
       break;
     } // end of else;
} // end of for

if (victoryFlag) {
  
  Serial.println("You win!");
  score++;
  if(score == 15){
    score = 0;
    }
  tone(buzzer, 4000);
  delay(300);
  tone(buzzer, 4500);
  delay(200);
  tone(buzzer, 4000);
  delay(300);
  tone(buzzer, 0);
  delay(300);
}
flag = 0;
turnCounter = 0;
}
// compare guess to answer array


     
 
}

void gamePlay(int roundDelay){

     for(int i=0; i<3;i++){
        ran = random(12,15); //Random fuction to generate numbers between 12 to 15 randomly
        switch(ran){
          case 12:
            answerArray[i] = "green";
            buzzTone = 4000;
            break;
          case 13:
            buzzTone = 8000;
            answerArray[i] = "red";
            break;
          case 14:
            buzzTone = 1000;  
            answerArray[i] = "blue";
            break;
        }
        digitalWrite(ran, HIGH); //Makes LED glow
        tone(buzzer, buzzTone); //Makes Buzzer to produce tone at 1000
        delay(roundDelay); //Delay 0f 5ms
        tone(buzzer, 0);
        digitalWrite(ran, LOW); //Makes LED off
        delay(200); //Delay for the transition between LEDs
    }
    for(int i=0;i<3;i++){
        Serial.println(answerArray[i]); 
      }
      flag = 1;
  
  }
   
void glowLed(int lPin){
  digitalWrite(lPin, HIGH); //Makes LED glow
        tone(buzzer, buzzTone); //Makes Buzzer to produce tone at 1000
        delay(300); //Delay 0f 5ms
        tone(buzzer, 0);
        digitalWrite(lPin, LOW); //Makes LED off
  }
