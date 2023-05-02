import pixi.core.sprites.Sprite;
import pixi.core.math.shapes.Rectangle;

class Star {
	var star_sprite:Sprite;
	var star_taken:Bool;
	var bounds:Rectangle;

	public function new(x:Int, y:Int) {
		star_sprite = Sprite.from('star.png');
		star_sprite.x = x;
		star_sprite.y = y;
		bounds = new Rectangle(star_sprite.x, star_sprite.y, star_sprite.width, star_sprite.height);

		star_taken = false;
	}

	public function getBounds() {
		return bounds;
	}

	public function isTaken() {
		return star_taken;
	}

	public function isTakable() {
		return !star_taken;
	}

	public function addToStage(screen:Sprite) {
		screen.addChild(star_sprite);
	}

	public function take() {
		star_sprite.visible = false;
		star_taken = true;
	}

	public function untake() {
		if (isTaken()) {
			star_sprite.visible = true;
			star_taken = false;
		}
	}
}
