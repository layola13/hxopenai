package jsasync;

import haxe.display.Protocol;
import js.lib.Promise;
import jsasync.AwaitIterator;
import haxe.Timer;

class JSAsyncTools {
	/** Awaits a JS Promise. (only valid inside an async function) */
	@:deprecated("JSAsyncTools.await is deprecated, use JSAsyncTools.jsawait instead")
	@:noCompletion
	public static extern inline function await<T>(promise: js.lib.Promise<T>): T {
		return js.Syntax.code("(await {0})", promise);
	}

	/** Awaits a JS Promise. (only valid inside an async function) */
	public static extern inline function jsawait<T>(promise: js.lib.Promise.Thenable<T>): T {
		return js.Syntax.code("(await {0})", promise);
	}

	public static function getAsyncIterator<T>(obj:Dynamic):AsyncIterator<T> {
        if (obj == null) return null;
        return js.Syntax.code("(({0})[Symbol.asyncIterator]())", obj);
    }

	// public static function makeAsyncIterator<T>(items:Array<T>, ?delayMs:Int = 1000):Dynamic {
	// 	var index = 0;
	// 	var iterator = {
	// 		next: () -> {
	// 			return new Promise((resolve, _) -> {
	// 				if (index >= items.length) {
	// 					resolve({done: true, value: null});
	// 				} else {
	// 					Timer.delay(() -> {
	// 						resolve({
	// 							done: false, 
	// 							value: items[index++]
	// 						});
	// 					}, delayMs);
	// 				}
	// 			});
	// 		}
	// 	};
		
	// 	// Use js.Syntax.code to create object with Symbol.asyncIterator
	// 	return js.Syntax.code("({ [Symbol.asyncIterator]: function() { return {0}; } })", iterator);
	// }

	public static function makeAsyncIterator<T>(items:Array<T>, ?delayMs:Int = 1000):AsyncIterable<T> {
        var index = 0;
        var iterator = {
            next: () -> {
                return new Promise((resolve, _) -> {
                    if (index >= items.length) {
                        resolve({done: true, value: null});
                    } else {
                        Timer.delay(() -> {
                            resolve({
                                done: false, 
                                value: items[index++]
                            });
                        }, delayMs);
                    }
                });
            }
        };
        
        // Create object with Symbol.asyncIterator
       // return js.Syntax.code("({ [Symbol.asyncIterator]: () => {0} })", iterator);
	   return js.Syntax.code("({ [Symbol.asyncIterator]: function() { return {0}; } })", iterator);
    }
	
	
}
