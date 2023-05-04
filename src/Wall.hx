import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;

class Wall {
	var wall_sprite:Sprite;
	var bounds:Rectangle;

	public function new(x:Int, y:Int) {
		wall_sprite = Sprite.from('images/wall.jpeg');
		wall_sprite.x = x;
		wall_sprite.y = y;
		bounds = new Rectangle(wall_sprite.x, wall_sprite.y, wall_sprite.width, wall_sprite.height);
	}

	public function getBounds() {
		return bounds;
	}

	public function addToStage(screen:Sprite) {
		screen.addChild(wall_sprite);
	}
}
