class Star extends ScreenItem {
	var star_taken:Bool;
	var took_time:Float;

	static inline var DELAY_SPEED_SECOND:Int = 5;

	public function new(x:Int, y:Int) {
		super("images/star.png", x, y);

		star_taken = false;
	}

	public function isTaken() {
		return star_taken;
	}

	public function isOver(time:Float) {
		return star_taken && took_time + (DELAY_SPEED_SECOND * 1000) < time;
	}

	public function isTakable() {
		return !star_taken;
	}

	public function take(time:Float) {
		item_sprite.visible = false;
		star_taken = true;
		took_time = time;
	}

	public function untake() {
		item_sprite.visible = true;
		star_taken = false;
	}
}
