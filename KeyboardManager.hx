import haxe.ds.IntMap;
import js.html.KeyboardEvent;

class KeyboardManager {
	static public inline var ARROW_DOWN = 40;
	static public inline var ARROW_UP = 38;
	static public inline var ARROW_LEFT = 37;
	static public inline var ARROW_RIGHT = 39;

	static private var keyState:IntMap<Bool>;

	static public var lastDown:Int;

	static public function init() {
		keyState = new IntMap();

		js.Browser.window.addEventListener("keydown", onKeyDown);
		js.Browser.window.addEventListener("keyup", onKeyUp);
	}

	static private function onKeyUp(e:KeyboardEvent):Void {
		keyState.remove(e.keyCode);
	}

	static private function onKeyDown(e:KeyboardEvent) {
		keyState.set(e.keyCode, true);
		lastDown = e.keyCode;
	}

	static public function isDown(keyCode:Int):Bool {
		return keyState.exists(keyCode) && keyState.get(keyCode);
	}

	static public function isArrowDown():Bool {
		return isDown(ARROW_RIGHT) || isDown(ARROW_UP) || isDown(ARROW_LEFT) || isDown(ARROW_DOWN);
	}
}
