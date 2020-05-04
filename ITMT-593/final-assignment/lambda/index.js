// This sample demonstrates handling intents from an Alexa skill using the Alexa Skills Kit SDK (v2).
// Please visit https://alexa.design/cookbook for additional examples on implementing slots, dialog management,
// session persistence, api calls, and more.
const Alexa = require('ask-sdk-core');
var name ="";
var colors = ['red', 'green', 'blue', 'yellow'];
var ans = new Array(4);
var ques = new Array(4);
var score = 0;
const LaunchRequestHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'LaunchRequest';
    },
    handle(handlerInput) {
        const speakOutput = 'Welcome to Simon Game, what is your name ?';
        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    }
};
const NameIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && Alexa.getIntentName(handlerInput.requestEnvelope) === 'NameIntent';
    },
    handle(handlerInput) {
        const slots = handlerInput.requestEnvelope.request.intent.slots;
        name = slots['name'].value;
        const speakOutput = `Thank you ${name}. Say Start to start the game`;
        if(name == "start"){
            return handlerInput.responseBuilder
            .speak("sorry!Please tell me your name")
            .reprompt("Please tell me your name")
            .getResponse();
        }else{
            return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt("Please tell me your name")
            .getResponse();
        }
        
    }
};
const StartIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && Alexa.getIntentName(handlerInput.requestEnvelope) === 'StartIntent';
    },
    handle(handlerInput) {
        return handlerInput.responseBuilder
        .speak(`${name}, Before we start the game here are the rules of the game. I will read out the the four color pattern, and you have to repeat it to earn one point towards winning. Say Okay to Continue`)
        .reprompt("Please say Okay")
        .getResponse();
    }
};
const PatternIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && Alexa.getIntentName(handlerInput.requestEnvelope) === 'PatternIntent';
    },
    handle(handlerInput) {
        var patternString = "";
        for(i = 0; i< colors.length; i++){
            var random = Math.floor(Math.random() * Math.floor(4));
            ques[i] = colors[random];
            patternString += ques[i] + " ";
        }
        return handlerInput.responseBuilder
            .speak(`Your pattern is ${patternString}. Your turn, Match it if you can!`)
            .reprompt(`Your pattern is ${patternString}`)
            .getResponse();
    }
};

const MatchPatternHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && Alexa.getIntentName(handlerInput.requestEnvelope) === 'MatchPattern';
    },
    handle(handlerInput) {
        var flag = 0;
        var patternString = "";
        var status = "";
        const slots = handlerInput.requestEnvelope.request.intent.slots;
        ans[0] = slots['colone'].value;
        ans[1] = slots['coltwo'].value;
        ans[2] = slots['colthree'].value;
        ans[3] = slots['colfour'].value;
        
        for(i = 0; i< 4; i++){
            if(flag == 0){
                if(ans[i] == ques[i]){
                    flag = 0;
                }else{
                    flag = 1;
                    var finalscore = score;
                    score = 0;
                    status = `And it is wrong, you Lose. Your score was ${finalscore}`;
                }
            }
            patternString += ans[i] + " ";
        }
        if(flag == 0){
            score = score + 1;
            status = `And it is correct, you Win. Your score is ${score}`;
        }
        return handlerInput.responseBuilder
            .speak(`Your answer is ${patternString}. ${status}. say okay to continue`)
            .reprompt(`Your answer is ${patternString}. ${status}. say okay to continue`)
            .getResponse()
    }

};
const HelpIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.HelpIntent';
    },
    handle(handlerInput) {
        const speakOutput = 'You can say hello to me! How can I help?';

        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    },
};
const CancelAndStopIntentHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest'
            && (Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.CancelIntent'
                || Alexa.getIntentName(handlerInput.requestEnvelope) === 'AMAZON.StopIntent');
    },
    handle(handlerInput) {
        const speakOutput = 'Goodbye!';
        return handlerInput.responseBuilder
            .speak(speakOutput)
            .getResponse();
    }
};
const SessionEndedRequestHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'SessionEndedRequest';
    },
    handle(handlerInput) {
        // Any cleanup logic goes here.
        return handlerInput.responseBuilder.getResponse();
    }
};

// The intent reflector is used for interaction model testing and debugging.
// It will simply repeat the intent the user said. You can create custom handlers
// for your intents by defining them above, then also adding them to the request
// handler chain below.
const IntentReflectorHandler = {
    canHandle(handlerInput) {
        return Alexa.getRequestType(handlerInput.requestEnvelope) === 'IntentRequest';
    },
    handle(handlerInput) {
        const intentName = Alexa.getIntentName(handlerInput.requestEnvelope);
        const speakOutput = `You just triggered ${intentName}`;

        return handlerInput.responseBuilder
            .speak(speakOutput)
            //.reprompt('add a reprompt if you want to keep the session open for the user to respond')
            .getResponse();
    }
};

// Generic error handling to capture any syntax or routing errors. If you receive an error
// stating the request handler chain is not found, you have not implemented a handler for
// the intent being invoked or included it in the skill builder below.
const ErrorHandler = {
    canHandle() {
        return true;
    },
    handle(handlerInput, error) {
        console.log(`~~~~ Error handled: ${error.stack}`);
        const speakOutput = `Sorry, I had trouble doing what you asked. Please try again.`;

        return handlerInput.responseBuilder
            .speak(speakOutput)
            .reprompt(speakOutput)
            .getResponse();
    }
};

// The SkillBuilder acts as the entry point for your skill, routing all request and response
// payloads to the handlers above. Make sure any new handlers or interceptors you've
// defined are included below. The order matters - they're processed top to bottom.
exports.handler = Alexa.SkillBuilders.custom()
    .addRequestHandlers(
        LaunchRequestHandler,
        NameIntentHandler,
        StartIntentHandler,
        PatternIntentHandler,
        MatchPatternHandler,
        HelpIntentHandler,
        CancelAndStopIntentHandler,
        SessionEndedRequestHandler,
        IntentReflectorHandler, // make sure IntentReflectorHandler is last so it doesn't override your custom intent handlers
    )
    .addErrorHandlers(
        ErrorHandler,
    )
    .lambda();
