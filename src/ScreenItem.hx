import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;

class ScreenItem {
	var item_sprite:Sprite;
	var bounds:Rectangle;

	public function new(imageName:String, x:Int, y:Int) {
		item_sprite = Sprite.from(imageName);
		item_sprite.x = x;
		item_sprite.y = y;
		bounds = new Rectangle(item_sprite.x, item_sprite.y, item_sprite.width, item_sprite.height);
	}

	public function getBounds() {
		return bounds;
	}

	public function addToStage(screen:Sprite) {
		screen.addChild(item_sprite);
	}
}
