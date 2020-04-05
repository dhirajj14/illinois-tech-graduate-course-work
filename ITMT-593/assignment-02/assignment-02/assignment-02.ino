#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
const char* ssid     = "APT 1915";
const char* password = "nahidenge";


ESP8266WebServer server(80);

// Variable to store the HTTP request
String header;
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

// Current time
unsigned long currentTime = millis();
// Previous time
unsigned long previousTime = 0; 
// Define timeout time in milliseconds (example: 2000ms = 2s)
const long timeoutTime = 2000;

String Status = "main";
void setup() {
  // put your setup code here, to run once:
pinMode(12, OUTPUT); //Blue Led Pin 
pinMode(13, OUTPUT); //Red Led Pin
pinMode(14, OUTPUT); //Green Led Pin
pinMode(15, INPUT); //Blue Button Pin 
pinMode(5, INPUT); //Red Button Pin
pinMode(4, INPUT); //Green Button Pin
pinMode(buzzer, OUTPUT); //pin 16 - Buzzer Pin
Serial.begin(115200);
// Connect to Wi-Fi network with SSID and password
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  // Print local IP address and start web server
  Serial.println("");
  Serial.println("WiFi connected.");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  delay(100);
  server.on("/",OnConnect);
  Serial.println("HTTP server started");
  server.begin();
}

void loop() {
  // put your main code here, to run repeatedly:

  server.handleClient();
  
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
       Status = "blue"; 
       OnConnect();
       glowLed(14);
       delay(300);
    } 
    if (digitalRead(5) == HIGH) {
      guessArray[turnCounter]= "red";
      turnCounter++;
      Serial.println(turnCounter); 
       Serial.println("red"); 
       Status = "red"; 
        glowLed(13);
        delay(300);
    } 
    if (digitalRead(4) == HIGH) {
      guessArray[turnCounter]= "green";
      turnCounter++;
      Serial.println(turnCounter); 
       Serial.println("green"); 
       Status = "green"; 
        glowLed(12);
        delay(300);
    } 

if(turnCounter == 3){
  OnConnect();
 delay(200);
for (int x = 0; x < 3; x++) {
     if (answerArray[x]==guessArray[x]) { 
       victoryFlag=true;
     } else {
        Status = "main";
        OnConnect();
        delay(2000);
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
  Status = "main";
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
OnConnect();
delay(2000);
flag = 0;
turnCounter = 0;
} 
}
void OnConnect() {
  Serial.println("Home Page");
  if(Status == "green"){
  Serial.println("green");
  server.send(200, "text/html", SendHTML("green", score)); 
}else if(Status == "red"){
  Serial.println("red");
  server.send(200, "text/html", SendHTML("red", score)); 
  }else if(Status == "blue"){
    Serial.println("blue");
  server.send(200, "text/html", SendHTML("blue", score)); 
    }
else if(Status == "main"){
   server.send(200, "text/html", SendHTML("grey", score)); 
}
}
void gamePlay(int roundDelay){
     Status = "main";
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



String SendHTML(String ledColor, int S){
  String ptr = "<!DOCTYPE html> <html>\n";
  ptr +="<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><meta http-equiv='refresh' content='0.5'>\n";
  ptr +="<title>Simon Game</title>\n";
  ptr +="<style>html { font-family: Helvetica; display: inline-block; margin: 0px auto; text-align: center;}\n";
  ptr +="body{margin-top: 50px;} h1 {color: #444444;margin: 50px auto 30px;} h3 {color: #444444;margin-bottom: 50px;}\n";
  ptr +=".dot { height: 40px; width: 40px; background-color: #bbb; border-radius: 50%; display: inline-block;}\n";
  ptr +="</style>\n";
  ptr +="</head>\n";
  ptr +="<body>\n";
  ptr +="<h1>Simon Game</h1>\n";
  ptr +="<h3>Led Pushed</h3>\n";
  ptr +="<div style='text-align:center'>\n";
  ptr += "<span style='background-color:"+ledColor+";' id='led' class='dot'></span>\n";
  ptr += "<h1>Score : "+String(S);+"</h1>\n";
  ptr += "</div>\n";
  //ptr += "<script>setInterval(function() {getData();}, 10); function getData() {var xhttp = new XMLHttpRequest();xhttp.onreadystatechange = function() {if (this.readyState == 4 && this.status == 200) {document.getElementById('led').style.backgroundColor = this.responseText;}};xhttp.open('GET', '/blueLed', true);xhttp.send();}</script>";
  ptr +="</body>\n";
  ptr +="</html>\n";
  return ptr;
}
