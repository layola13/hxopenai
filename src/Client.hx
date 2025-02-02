import openai.openai.chat.completions.ChatCompletionChunk;
import js.node.stream.Readable;
import openai.openai.chat.completions.ChatCompletionCreateParamsStreaming;
import openai.streaming.Stream as OpenAIStream;
import openai.openai.chat.completions.ChatCompletionChunk;
import openai.OpenAI;
import jsasync.IJSAsync;
import js.lib.Promise;

using jsasync.JSAsyncTools;
using Lambda;

import js.Node; // Add Node.js support

@:expose
class Client implements IJSAsync {
	var openai:OpenAI;

	public function new() {
		final configuration = {
			apiKey: Sys.getEnv("API_KEY_GUIJI"),
			baseURL: Sys.getEnv("BASE_URL"),
		};

		openai = new OpenAI(configuration);
	}

	@:jsasync
	public function processPrompt(txtContent:String) {
		try {
			final params:ChatCompletionCreateParamsStreaming = {
				model: "gpt-4o-mini",
				messages: [{role: "user", content: txtContent}],
				max_tokens: 1024 * 200,
				temperature: 0.8,
				stream: true
			};

			var result:String = "";
			final stream = @await cast openai.chat.completions.create(params);

			js.Syntax.code("
				for await (const chunk of {0}) {
					const content = chunk.choices[0]?.delta?.content || '';
					process.stdout.write(content);
					{1}+=(content);
				}
			", stream, result);

			// var iterator = JSAsyncTools.getAsyncIterator(stream);
			// while (true) {
			// 	var next = @await iterator.next();
			// 	if (next.done)
			// 		break;
			// 	final content = next.value.choices[0]?.delta?.content;
			// 	if (content != null) {
			// 		js.Node.process.stdout.write(content);
			// 	}
			// }

			return (result.toString());
		} catch (e:Dynamic) {
			trace(e);
			return e.toString();
		}
	}
}
