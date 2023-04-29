import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;

class Ghost {
	var ghost_sprite:Sprite;
	var ghost_taken:Bool;
	var bounds:Rectangle;

	public function new(x:Int, y:Int) {
		ghost_sprite = Sprite.from('ghost.png');
		ghost_sprite.x = x;
		ghost_sprite.y = y;

		ghost_taken = false;

		bounds = new Rectangle(ghost_sprite.x, ghost_sprite.y, ghost_sprite.width, ghost_sprite.height);
	}

	public function getBounds() {
		return bounds;
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

	public function addToStage(screen:Sprite) {
		screen.addChild(ghost_sprite);
	}
}
