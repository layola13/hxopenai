import openai.OpenAI;

class Main{

    

    public static function main(){

        trace("Hello World");
      


       var client:Client = new Client();

       client.processPrompt("Hello World,who are you?").then(function(response:String){

        trace('-------------');
           trace(response);
       });


        
    }
} 