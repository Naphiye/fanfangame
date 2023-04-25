import pixi.core.sprites.Sprite;

class Coin {
	static var BLINK_COUNT:Int = 6;

	var coin_sprite:Sprite;
	var coin_taken:Bool;
	var save_time:Float;
	var total_blink:Int;

	public function new(x:Int, y:Int) {
		coin_sprite = Sprite.from('coin.png');
		coin_sprite.x = x;
		coin_sprite.y = y;

		coin_taken = false;
		save_time = 0;
		total_blink = 0;
	}

	public function getBounds() {
		return coin_sprite.getBounds(false);
	}

	public function isTaken() {
		return coin_taken;
	}

	public function isTakable() {
		return !coin_taken;
	}

	public function take() {
		coin_taken = true;
	}

	public function addToStage(screen:Sprite) {
		screen.addChild(coin_sprite);
	}

	public function update(time:Float) {
		if (isTaken()) {
			if (total_blink < BLINK_COUNT) {
				if (save_time + 50 < time) {
					coin_sprite.visible = !coin_sprite.visible;
					total_blink += 1;
					save_time = time; // 10540
				}
			} else {
				coin_sprite.visible = false;
			}
		}
	}
}
