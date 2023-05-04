class Coin extends ScreenItem {
	static var BLINK_COUNT:Int = 6;

	var coin_taken:Bool;
	var save_time:Float;
	var total_blink:Int;

	public function new(x:Int, y:Int) {
		super("images/coin.png", x, y);

		coin_taken = false;
		save_time = 0;
		total_blink = 0;
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

	public function update(time:Float) {
		if (isTaken()) {
			if (total_blink < BLINK_COUNT) {
				if (save_time + 50 < time) {
					item_sprite.visible = !item_sprite.visible;
					total_blink += 1;
					save_time = time; // 10540
				}
			} else {
				item_sprite.visible = false;
			}
		}
	}
}
