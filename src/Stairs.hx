class Stairs extends ScreenItem {
	public function new(x:Int, y:Int) {
		super("images/stairs.png", x, y);
	}

	public function getX() {
		return item_sprite.x;
	}

	public function getY() {
		return item_sprite.y;
	}

	public function changeX(change:Float) {
		item_sprite.x = change;
		bounds.x = change;
	}

	public function changeY(change:Float) {
		item_sprite.y = change;
		bounds.y = change;
	}
}
