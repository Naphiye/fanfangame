import pixi.core.sprites.Sprite;

class Wall {
	var wall_sprite:Sprite;

	public function new(x:Int, y:Int) {
		wall_sprite = Sprite.from('wall.jpeg');
		wall_sprite.x = x;
		wall_sprite.y = y;
	}

	public function getBounds() {
		return wall_sprite.getBounds(false);
	}

	public function addToStage(screen:Sprite) {
		screen.addChild(wall_sprite);
	}
}
