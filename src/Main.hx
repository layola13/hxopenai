import openai.OpenAI;

#if js
@:jsRequire("dotenv")
extern class Dotenv {
    public static function config():Void;
}
#end
class Main{

    

    public static function main(){

        Dotenv.config();
        trace("Hello World");
      


       var client:Client = new Client();

       client.processPrompt("Hello World,who are you?").then(function(response:String){

        trace('-------------');
           trace(response);
       });


        
    }
} 