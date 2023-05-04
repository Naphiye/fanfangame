import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;

class Stairs {
	var stairs_sprite:Sprite;
	var bounds:Rectangle;

	public function new(x:Int, y:Int) {
		stairs_sprite = Sprite.from('images/stairs.png');
		stairs_sprite.x = x;
		stairs_sprite.y = y;
		bounds = new Rectangle(stairs_sprite.x, stairs_sprite.y, stairs_sprite.width, stairs_sprite.height);
	}

	public function getBounds() {
		return bounds;
	}

	public function getX() {
		return stairs_sprite.x;
	}

	public function getY() {
		return stairs_sprite.y;
	}

	public function addToStage(screen:Sprite) {
		screen.addChild(stairs_sprite);
	}
}
