class Ghost extends ScreenItem {
	var ghost_taken:Bool;

	public function new(x:Int, y:Int) {
		super("images/ghost.png", x, y);

		ghost_taken = false;
	}

	public function isTaken() {
		return ghost_taken;
	}

	public function isTakable() {
		return !ghost_taken;
	}

	public function take() {
		ghost_taken = true;
	}
}
