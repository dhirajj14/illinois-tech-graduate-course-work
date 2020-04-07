#include <ESP8266WiFi.h>
#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>

const char* ssid     = "APT 1915";
const char* password = "nahidenge";


String header;
int buzzer = 0;
long ran;
int gameStart = 0;
int buzzTone;
String answerArray[3];
String guessArray[3];
boolean victoryFlag = false; // flag to check victory condition
int flag = 0;
int score = 0;
String statusWL = "null";
int turnCounter = 0;
// end of item setup
String buttonAnsArray[] = {"blue", "red", "green"};

// Current time
unsigned long currentTime = millis();
// Previous time
unsigned long previousTime = 0; 
// Define timeout time in milliseconds (example: 2000ms = 2s)
const long timeoutTime = 2000;

String Status = "reset";

// Create AsyncWebServer object on port 80
AsyncWebServer server(80);

const char index_html[] PROGMEM = R"=====(
<!DOCTYPE html> 
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css' integrity='sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh' crossorigin='anonymous'>
<title>Simon Game</title>
<style>html 
{ font-family: Helvetica; 
display: inline-block; 
margin: 0px auto; 
text-align: center;
}
 body{margin-top: 50px;} 
 h1 {color: #444444;margin: 50px auto 30px;} 
 h3 {color: #444444;margin-bottom: 50px;}
 .row{padding: 10px;}
 .dot { height: 40px; width: 40px; border-radius: 50%; display: inline-block;}
 </style>
 </head>
 <body>
     <div class="container text-center card">
          <h1>Simon Game</h1>
          <div class="row">
            <div class="input-group mb-3">
                <input type="text" class="form-control" placeholder="Player Name" id="userName">
                <div class="input-group-append">
                  <button class="btn btn-outline-secondary" onClick="start();" type="button">Start Game!</button>
                </div>
              </div>
          </div>
          <div class="row ">
              <div class="col-md-5">
                <h3>Computer Pattern</h3>
                <div class="text-center">
                    <span style="background-color:#66ff66;" id="GGled" class="dot"></span>
                    <span style="background-color:#FF6666;" id="GRled" class="dot"></span>
                    <span style="background-color:#6666ff;" id="GBled" class="dot"></span>
                </div>
              </div>
              <div class="col-md-2">
                  <div class="align-middle" style="margin-top: 30%;">
                    <h3>Vs</h3>
                  </div>
              </div>
              <div class="col-md-5">
                <h3>User Pattern</h3>
                <div class="text-center">
                    <span style="background-color:#66ff66;" id="Gled" class="dot"></span>
                    <span style="background-color:#FF6666;" id="Rled" class="dot"></span>
                    <span style="background-color:#6666ff;" id="Bled" class="dot"></span>
                </div>
              </div>
          </div>
          <div class="row justify-content-center">
            <h3 >Score: <span id="score"></span></h3>
          </div>
          <div class="row justify-content-center">
            <h3 >Win/Lose: <span id="wl"></span></h3>
          </div>
          <div class="row justify-content-center">
            <table class="table table-striped table-dark">
                    <thead>
                      <tr>
                        <th scope="col">Name</th>
                        <th scope="col">Score</th>
                      </tr>
                    </thead>
                    <tbody id="mytable">
                    </tbody>
                  </table>
          </div>
    </div>
  </body>
 <script>
    var score = 0;
  var lflag = 0;
  var counter = 0;
  var fscore = 0;
  var name = "";
    setInterval(function ( ) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        if(this.responseText == "gred"){
            document.getElementById("GRled").style.backgroundColor = "red";
            document.getElementById("GGled").style.backgroundColor = "#66FF66";
            document.getElementById("GBled").style.backgroundColor = "#6666FF";
            
          }
  
         if(this.responseText == "ggreen"){
  
            document.getElementById("GGled").style.backgroundColor = "green";
            document.getElementById("GRled").style.backgroundColor = "#FF6666";
            document.getElementById("GBled").style.backgroundColor = "#6666FF";
          }
  
          if(this.responseText == "gblue"){
          
            document.getElementById("GBled").style.backgroundColor = "blue";
            document.getElementById("GRled").style.backgroundColor = "#FF6666";
            document.getElementById("GGled").style.backgroundColor = "#66FF66";
          }
  
          if(this.responseText == "red"){
  
            document.getElementById("Rled").style.backgroundColor = this.responseText;
            document.getElementById("Gled").style.backgroundColor = "#66FF66";
            document.getElementById("Bled").style.backgroundColor = "#6666FF";
            
          }
  
         if(this.responseText == "green"){
  
            document.getElementById("Gled").style.backgroundColor = this.responseText;
            document.getElementById("Rled").style.backgroundColor = "#FF6666";
            document.getElementById("Bled").style.backgroundColor = "#6666FF";
          }
  
          if(this.responseText == "blue"){
          
            document.getElementById("Bled").style.backgroundColor = this.responseText;
            document.getElementById("Rled").style.backgroundColor = "#FF6666";
            document.getElementById("Gled").style.backgroundColor = "#66FF66";
          }
  
           if(this.responseText == "reset"){
            lfag = 0;
            counter = 0;
            document.getElementById("Bled").style.backgroundColor = "#6666FF";
            document.getElementById("Rled").style.backgroundColor = "#FF6666";
            document.getElementById("Gled").style.backgroundColor = "#66FF66";
            document.getElementById("GBled").style.backgroundColor = "#6666FF";
            document.getElementById("GRled").style.backgroundColor = "#FF6666";
            document.getElementById("GGled").style.backgroundColor = "#66FF66";
          }
      }
    };
    xhttp.open("GET", "/color", true);
    xhttp.send();
  }, 50 ) ;
  
  
   setInterval(function ( ) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
         if(lfag == 0){
          if(this.responseText == "win"){
              document.getElementById("wl").innerHTML = "Win";
              lfag=1; 
            }
         
          if(this.responseText == "lose"){
            if(counter == 0){
              document.getElementById("mytable").innerHTML += "<tr><td>"+name+"</td><td>"+fscore+"</td></tr>";
              document.getElementById("userName").disabled = false;
              document.getElementById("wl").innerHTML = "lose";
              fscore= 0;
              lfag == 1;
              counter++;
            }
          }
          }
      }
    };
    xhttp.open("GET", "/wl", true);
    xhttp.send();
  }, 50 ) ;
  
  setInterval(function ( ) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
              score = this.responseText;
              if(score != 0){
                fscore = score;
                }
              document.getElementById("score").innerHTML = score; 
            }
    };
    xhttp.open("GET", "/score", true);
    xhttp.send();
  }, 50 ) ;
  
  function start(){
     score = 0;
     counter = 0;
    name = document.getElementById("userName").value;
    if(name != ""){
        document.getElementById("userName").disabled = true;
        var xhttp = new XMLHttpRequest();
        xhttp.open("GET", "/start", true);
        xhttp.send();
    }else{
        alert("Please Enter Player Name");
    }
    
    }
</script>
  </html>
)=====";

String processor(const String& var){
  Serial.println(var);
  if(var == "COLOR"){
    return String(Status);
  }
  return String();
}

void setup() {
  pinMode(12, OUTPUT); //Blue Led Pin 
pinMode(13, OUTPUT); //Red Led Pin
pinMode(14, OUTPUT); //Green Led Pin
pinMode(15, INPUT); //Blue Button Pin 
pinMode(5, INPUT); //Red Button Pin
pinMode(4, INPUT); //Green Button Pin
pinMode(buzzer, OUTPUT); //pin 16 - Buzzer Pin
  // put your setup code here, to run once:
  // Serial port for debugging purposes
  Serial.begin(115200);

  
  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println(".");
  }

  // Print ESP8266 Local IP Address
  Serial.println(WiFi.localIP());

  // Route for root / web page
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", index_html, processor);
  });

 server.on("/color", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/plain", String(Status).c_str());
  });

   server.on("/wl", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/plain", String(statusWL).c_str());
  });

   server.on("/score", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/plain", String(score).c_str());
  });

 server.on("/start", HTTP_GET, [](AsyncWebServerRequest *request){
  startGame();
});
  // Start server
  server.begin();
}

void startGame(){
 gameStart = 1;
 }
void loop() {
  if(gameStart == 1){
  // put your main code here, to run repeatedly:
   statusWL = "null";
   Status = "reset";
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
for (int x = 0; x < 3; x++) {
     if (answerArray[x]==guessArray[x]) { 
       victoryFlag=true;
     } else {
        
        Serial.println("you lose!");
        statusWL = "lose";
        gameStart = 0 ;
        score=0;
        tone(buzzer,4000);
        delay(1000);
        tone(buzzer,0);
        delay(300);
       victoryFlag=false;
       statusWL = "null";
       break; 
     } // end of else;
} // end of for

if (victoryFlag) {
  Status = "reset";
  Serial.println("You win!");
  statusWL = "win";
 
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
}
}

void gamePlay(int roundDelay){
     for(int i=0; i<3;i++){
        ran = random(12,15); //Random fuction to generate numbers between 12 to 15 randomly
        switch(ran){
          case 12:
            answerArray[i] = "green";
            Status = "ggreen"; 
            buzzTone = 4000;
            break;
          case 13:
            buzzTone = 8000;
            answerArray[i] = "red";
            Status = "gred";
            break;
          case 14:
            buzzTone = 1000;  
            Status = "gblue"; 
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
