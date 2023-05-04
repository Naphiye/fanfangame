import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;

class Perso {
	var perso_sprite:Sprite;

	var bounds:Rectangle;

	public function new(x:Int, y:Int) {
		perso_sprite = Sprite.from('images/perso.png');
		perso_sprite.x = x;
		perso_sprite.y = y;
		bounds = new Rectangle(perso_sprite.x, perso_sprite.y, perso_sprite.width, perso_sprite.height);
	}

	public function getBounds() {
		return bounds;
	}

	public function addToStage(screen:Sprite) {
		screen.addChild(perso_sprite);
	}

	public function getX() {
		return perso_sprite.x;
	}

	public function getY() {
		return perso_sprite.y;
	}

	public function changeX(change:Float) {
		perso_sprite.x = change;
		bounds.x = change;
	}

	public function changeY(change:Float) {
		perso_sprite.y = change;
		bounds.y = change;
	}
}
