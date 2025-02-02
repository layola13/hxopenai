package jsasync;

using jsasync.JSAsyncTools;
import js.lib.Promise;

typedef AsyncIteratorResult<T> = {
    done:Bool,
    ?value:T
}

typedef AsyncIterator<T> = {
    next:() -> Promise<AsyncIteratorResult<T>>
}

typedef AsyncIterable<T> = {
    @:keep
    @:native('Symbol.asyncIterator')
    function asyncIterator():AsyncIterator<T>;
    function iterator():AsyncHaxeIterator<T>;
}

@:allow(jsasync.JSAsyncTools)
private class AsyncHaxeIterator<T> implements IJSAsync {
    final asyncIter:AsyncIterator<T>;
    var current:T;
    var isDone:Bool = false;
    var nextResult:AsyncIteratorResult<T>;
    var isIterating:Bool = false;

    public function new(asyncIter:AsyncIterator<T>) {
        this.asyncIter = asyncIter;
    }

    private function prepareNext():Void {
        js.Syntax.code("
            if (this.isIterating) return;
            this.isIterating = true;
            (async () => {
                this.nextResult = await this.asyncIter.next();
                this.isDone = this.nextResult.done;
                if (!this.isDone) this.current = this.nextResult.value;
                this.isIterating = false;
            })();
        ");
    }

    public function hasNext():Bool {
        if (isDone) return false;
        js.Syntax.code("
            if (!this.isIterating) {
                (async () => {
                    await this.prepareNext();
                })();
            }
        ");
        return !isDone;
    }

    public function next():T {
        return current;
    }
}