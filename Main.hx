import js.lib.intl.Collator.CollatorSupportedLocalesOfOptions;
import js.lib.Promise;
import pixi.core.textures.Texture;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import js.Browser;
import pixi.core.Application;

// https://pixijs.download/v5.2.2/docs/index.html
class Main {
	static var perso:Sprite;

	static var ECRAN_LARGE:Int = 800;
	static var ECRAN_HAUT:Int = 600;
	static var PERSO_VITESSE:Int = 10;
	static var WALL_POS:Array<Array<Int>> = [];
	static var all_wall_rectangle:Array<Rectangle> = [];
	static var vitesse_x_perso:Int = 0;
	static var vitesse_y_perso:Int = 0;

	static function main() {
		// Preload
		var persoProm = Texture.fromURL('perso.png');
		var murProm = Texture.fromURL('wall.jpeg');

		Promise.all([persoProm, murProm]).then(startGame);
	}

	static function startGame(_) {
		KeyboardManager.init();

		var app = new Application({backgroundColor: 0x000000});
		Browser.document.body.appendChild(app.view);

		perso = Sprite.from('perso.png');
		perso.x = 50;
		perso.y = 50;
		var perso_rectangle:Rectangle = new Rectangle(perso.x, perso.y, perso.width, perso.height);
		app.stage.addChild(perso);

		var wall_image = Sprite.from('wall.jpeg');

		for (i in 0...200) {
			var position = [Std.random(ECRAN_LARGE), Std.random(ECRAN_HAUT)];
			if (can_place_wall(position, WALL_POS, wall_image.width, wall_image.height)) {
				WALL_POS.push(position);
			}
		}
		for (wall in WALL_POS) {
			wall_image = Sprite.from('wall.jpeg');
			wall_image.x = wall[0];
			wall_image.y = wall[1];
			var wall_rectangle:Rectangle = new Rectangle(wall_image.x, wall_image.y, wall_image.width, wall_image.height);

			if (!collision_point(wall_rectangle, perso_rectangle)) {
				app.stage.addChild(wall_image);

				all_wall_rectangle.push(wall_image.getBounds());
			}
		}
		Browser.window.requestAnimationFrame(update);
	}

	static function can_place_wall(wall_position:Array<Int>, walls_already_placed:Array<Array<Int>>, wall_width:Float, wall_height:Float) {
		var wall_position_rect:Rectangle = new Rectangle(wall_position[0], wall_position[1], wall_width, wall_height);
		for (walls in walls_already_placed) {
			var wall_already_placed_rect:Rectangle = new Rectangle(walls[0], walls[1], wall_width, wall_height);
			if (collision_point(wall_position_rect, wall_already_placed_rect)) {
				return false;
			}
		}
		return true;
	}

	static function inside_screen(perso_rect:Rectangle) {
		if ((perso_rect.x) < 0) { // a gauche de lecran
			return false;
		}
		if ((perso_rect.x + perso_rect.width) > ECRAN_LARGE) { // a droite de lecran
			return false;
		}
		if ((perso_rect.y) < 0) { // en haut de lecran
			return false;
		}
		if ((perso_rect.y + perso_rect.height) > ECRAN_HAUT) { // en bas de lecran
			return false;
		}

		return true;
	}

	static function collision_point(wall_rect:Rectangle, perso_rect:Rectangle) {
		if ((perso_rect.x + perso_rect.width) < wall_rect.x) { // a gauche du mur
			return false;
		}
		if (perso_rect.x > (wall_rect.x + wall_rect.width)) { // a droite du mur
			return false;
		}
		if ((perso_rect.y + perso_rect.height) < wall_rect.y) { // en haut du mur
			return false;
		}
		if (perso_rect.y > (wall_rect.y + wall_rect.height)) { // en bas du mur
			return false;
		}

		return true;
	}

	static function moving_ok(wall_rects:Array<Rectangle>, perso_futur:Rectangle) {
		for (rects in wall_rects) {
			if (collision_point(rects, perso_futur)) {
				return false;
			}
			if (!inside_screen(perso_futur)) {
				return false;
			}
		}
		return true;
	}

	static function update(f:Float) {
		if (KeyboardManager.isDown(KeyboardManager.ARROW_LEFT)) {
			vitesse_x_perso = -PERSO_VITESSE;
		} else if (KeyboardManager.isDown(KeyboardManager.ARROW_RIGHT)) {
			vitesse_x_perso = PERSO_VITESSE;
		} else {
			vitesse_x_perso = 0;
		}

		if (KeyboardManager.isDown(KeyboardManager.ARROW_DOWN)) {
			vitesse_y_perso = PERSO_VITESSE;
		} else if (KeyboardManager.isDown(KeyboardManager.ARROW_UP)) {
			vitesse_y_perso = -PERSO_VITESSE;
		} else {
			vitesse_y_perso = 0;
		}
		var futur_x_perso = perso.x + vitesse_x_perso;
		var futur_y_perso = perso.y + vitesse_y_perso;
		var futur_perso_rectangle:Rectangle = new Rectangle(futur_x_perso, futur_y_perso, perso.width, perso.height);

		if (moving_ok(all_wall_rectangle, futur_perso_rectangle)) {
			perso.x = futur_x_perso;
			perso.y = futur_y_perso;
		} else {
			// déplacement diagonale pas possible
			if (vitesse_x_perso != 0 && vitesse_y_perso != 0) {
				// déplacement diagonale

				// est ce que je peux me déplacer à l'horizontale
				var futur_perso_rectangle_horizontale:Rectangle = new Rectangle(futur_x_perso, perso.y, perso.width, perso.height);
				var futur_perso_rectangle_verticale:Rectangle = new Rectangle(perso.x, futur_y_perso, perso.width, perso.height);
				if (moving_ok(all_wall_rectangle, futur_perso_rectangle_horizontale)) {
					perso.x = futur_x_perso;
				}
				// sinon est ce que je peux me deplacer à la verticale
				else if (moving_ok(all_wall_rectangle, futur_perso_rectangle_verticale)) {
					perso.y = futur_y_perso;
				}
			}
		}

		Browser.window.requestAnimationFrame(update);
	}
}
