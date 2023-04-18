import js.lib.Promise;
import pixi.core.textures.Texture;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import js.Browser;
import pixi.core.Application;

// https://pixijs.download/v5.2.2/docs/index.html
class Main {
	static inline var ECRAN_LARGE:Int = 1024;
	static inline var ECRAN_HAUT:Int = 768;
	static inline var PERSO_VITESSE:Int = 3;
	static inline var PERSO_VITESSE_PLUS:Int = PERSO_VITESSE * 2;
	static inline var PERSO_STOP:Int = 0;
	static inline var DELAY_SPEED_BONUS_SECOND:Int = 5;

	static var screen:Sprite;

	static var perso:Sprite;
	static var star_bonus:Sprite;
	static var finish_stairs:Sprite;
	static var ghost:Sprite;
	static var coin_image:Sprite;

	static var total_coin:Int = 0;
	static var vitesse_perso:Int = PERSO_VITESSE;
	static var save_time:Float = 0;

	static var other_rectangle:Array<Rectangle> = [];
	static var all_wall_rectangle:Array<Rectangle> = [];
	static var all_coin_rectangle:Array<Rectangle> = [];
	static var COIN_POS:Array<Array<Int>> = [];

	static function main() {
		// Preload
		var persoProm = Texture.fromURL('perso.png');
		var murProm = Texture.fromURL('wall.jpeg');
		var starProm = Texture.fromURL('star.png');
		var stairsProm = Texture.fromURL('stairs.png');
		var ghostProm = Texture.fromURL('ghost.png');
		var coinProm = Texture.fromURL('coin.png');
		Promise.all([persoProm, murProm, starProm, stairsProm, ghostProm, coinProm]).then(startGame);
	}

	static function startGame(_) {
		KeyboardManager.init();

		var app = new Application({backgroundColor: 0x000000, width: ECRAN_LARGE, height: ECRAN_HAUT});
		Browser.document.body.appendChild(app.view);

		screen = new Sprite();
		app.stage.addChild(screen);
		var screen_rectangle:Rectangle = new Rectangle(screen.x, screen.y, screen.width, screen.height);

		finish_stairs = Sprite.from('stairs.png');
		finish_stairs.x = (ECRAN_LARGE - finish_stairs.width);
		finish_stairs.y = (ECRAN_HAUT - finish_stairs.height);
		var finish_stairs_rectangle:Rectangle = new Rectangle(finish_stairs.x, finish_stairs.y, finish_stairs.width, finish_stairs.height);
		other_rectangle.push(finish_stairs_rectangle);
		screen.addChild(finish_stairs);

		star_bonus = Sprite.from('star.png');
		star_bonus.x = 80;
		star_bonus.y = 150;
		var star_bonus_rectangle:Rectangle = new Rectangle(star_bonus.x, star_bonus.y, star_bonus.width, star_bonus.height);
		other_rectangle.push(star_bonus_rectangle);
		screen.addChild(star_bonus);

		perso = Sprite.from('perso.png');
		perso.x = 50;
		perso.y = 50;
		var perso_rectangle:Rectangle = new Rectangle(perso.x, perso.y, perso.width, perso.height);
		other_rectangle.push(perso_rectangle);
		screen.addChild(perso);

		ghost = Sprite.from('ghost.png');
		ghost.x = 350;
		ghost.y = 90;
		var ghost_rectangle:Rectangle = new Rectangle(ghost.x, ghost.y, ghost.width, ghost.height);
		other_rectangle.push(ghost_rectangle);
		screen.addChild(ghost);

		var wall_image = Sprite.from('wall.jpeg');

		var WALL_POS:Array<Array<Int>> = [];

		// nombre de murs / position aléatoire / sans superposition avec autres murs
		for (i in 0...10) {
			var position = [Std.random(ECRAN_LARGE), Std.random(ECRAN_HAUT)];
			if (can_place_object(position, WALL_POS, wall_image.width, wall_image.height)) {
				WALL_POS.push(position);
			}
		}
		for (wall in WALL_POS) {
			wall_image = Sprite.from('wall.jpeg');
			wall_image.x = wall[0];
			wall_image.y = wall[1];
			var wall_rectangle:Rectangle = new Rectangle(wall_image.x, wall_image.y, wall_image.width, wall_image.height);
			// sans superosition sur d'autres objets
			if (no_superposition(wall_rectangle, other_rectangle)) {
				screen.addChild(wall_image);

				all_wall_rectangle.push(wall_image.getBounds());
			}
		}

		coin_image = Sprite.from('coin.png');

		for (i in 0...16) {
			var position = [Std.random(ECRAN_LARGE), Std.random(ECRAN_HAUT)];
			if (can_place_object(position, COIN_POS, coin_image.width, coin_image.height)
				&& can_place_object(position, WALL_POS, wall_image.width, wall_image.height)) {
				COIN_POS.push(position);
			}
		}
		for (coin in COIN_POS) {
			coin_image = Sprite.from('coin.png');
			coin_image.x = coin[0];
			coin_image.y = coin[1];
			var coin_rectangle:Rectangle = new Rectangle(coin_image.x, coin_image.y, coin_image.width, coin_image.height);

			if (no_superposition(coin_rectangle, other_rectangle)) {
				screen.addChild(coin_image);

				all_coin_rectangle.push(coin_image.getBounds());
			}
		}

		Browser.window.requestAnimationFrame(update);
	}

	static function no_superposition(object:Rectangle, others:Array<Rectangle>) {
		for (n in others) {
			if (!collision_point(object, n)) {
				return true;
			}
		}
		return false;
	}

	static function edge_of_the_screen(perso_rect:Rectangle) {
		if ((perso_rect.x) < screen.x) { // a gauche de lecran
			return true;
		}
		if ((perso_rect.x + perso_rect.width) > (screen.x + ECRAN_LARGE)) { // a droite de lecran
			return true;
		}
		if ((perso_rect.y) < screen.y) { // en haut de lecran
			return true;
		}
		if ((perso_rect.y + perso_rect.height) > (screen.y + ECRAN_HAUT)) { // en bas de lecran
			return true;
		}

		return false;
	}

	static function move_screen(perso_rect:Rectangle) {
		if ((perso_rect.x) < (-screen.x)) { // a gauche de lecran
			screen.x += ECRAN_LARGE;
		}

		if ((perso_rect.x + perso_rect.width) > ((-screen.x) + ECRAN_LARGE)) { // a droite de lecran
			screen.x -= ECRAN_LARGE;
		}
		if ((perso_rect.y) < (-screen.y)) { // en haut de lecran
			screen.y += ECRAN_HAUT;
		}
		if ((perso_rect.y + perso_rect.height) > ((-screen.y) + ECRAN_HAUT)) { // en bas de lecran
			screen.y -= ECRAN_HAUT;
		}
	}

	static function can_place_object(object_position:Array<Int>, objects_already_placed:Array<Array<Int>>, object_width:Float, object_height:Float) {
		var object_position_rect:Rectangle = new Rectangle(object_position[0], object_position[1], object_width, object_height);
		for (objects in objects_already_placed) {
			var object_already_placed_rect:Rectangle = new Rectangle(objects[0], objects[1], object_width, object_height);
			if (collision_point(object_position_rect, object_already_placed_rect)) {
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

	static function collision_point(object_rect:Rectangle, perso_rect:Rectangle) {
		if ((perso_rect.x + perso_rect.width) < object_rect.x) { // a gauche de l'objet
			return false;
		}
		if (perso_rect.x > (object_rect.x + object_rect.width)) { // a droite de l'objet
			return false;
		}
		if ((perso_rect.y + perso_rect.height) < object_rect.y) { // en haut de l'objet
			return false;
		}
		if (perso_rect.y > (object_rect.y + object_rect.height)) { // en bas de l'objet
			return false;
		}

		return true;
	}

	static function moving_ok(wall_rects:Array<Rectangle>, perso_futur:Rectangle) {
		for (rects in wall_rects) {
			if (collision_point(rects, perso_futur)) {
				return false;
			}
			/*if (!inside_screen(perso_futur)) {
				return false;
			}*/
		}
		return true;
	}

	static function update(time:Float) {
		var vitesse_x_perso;
		var vitesse_y_perso;

		var perso_rectangle:Rectangle = new Rectangle(perso.x, perso.y, perso.width, perso.height);

		var star_bonus_rectangle:Rectangle = new Rectangle(star_bonus.x, star_bonus.y, star_bonus.width, star_bonus.height);
		var finish_stairs_rectangle:Rectangle = new Rectangle(finish_stairs.x, finish_stairs.y, finish_stairs.width, finish_stairs.height);
		var ghost_rectangle:Rectangle = new Rectangle(ghost.x, ghost.y, ghost.width, ghost.height);

		// LES DEPLACEMENTS

		if (KeyboardManager.isDown(KeyboardManager.ARROW_LEFT)) {
			vitesse_x_perso = -vitesse_perso;
		} else if (KeyboardManager.isDown(KeyboardManager.ARROW_RIGHT)) {
			vitesse_x_perso = vitesse_perso;
		} else {
			vitesse_x_perso = 0;
		}

		if (KeyboardManager.isDown(KeyboardManager.ARROW_DOWN)) {
			vitesse_y_perso = vitesse_perso;
		} else if (KeyboardManager.isDown(KeyboardManager.ARROW_UP)) {
			vitesse_y_perso = -vitesse_perso;
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
			// DEPLACEMENTS DIAGONALES
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

		// INTERACTIONS AVEC OBJETS

		// COINS
		for (n in all_coin_rectangle) {
			if (collision_point(n, perso_rectangle)) {
				for (coin in COIN_POS) {
					if (coin_image.visible = true) {
						total_coin += 1;
						trace('Gling gling');
						coin_image.visible = false;
					}
				}
			}
		}

		// STAR FOR FAST SPEED

		if (collision_point(perso_rectangle, star_bonus_rectangle) && star_bonus.visible) {
			vitesse_perso = PERSO_VITESSE_PLUS;
			trace('BONUS VITESSE');
			star_bonus.visible = false;
			save_time = time;
		}
		if (vitesse_perso == PERSO_VITESSE_PLUS && save_time + (DELAY_SPEED_BONUS_SECOND * 1000) < time) {
			vitesse_perso = PERSO_VITESSE;
			star_bonus.visible = true;
			trace('Fin du bonus');
		}

		// STAIRS FOR FINISH
		if (collision_point(finish_stairs_rectangle, perso_rectangle)) {
			perso.x = finish_stairs.x;
			perso.y = finish_stairs.y;
			vitesse_perso = PERSO_STOP;
			trace('Gagné !!!!');
		}

		// GHOST TRAP
		if (collision_point(perso_rectangle, ghost_rectangle)) {
			perso.x = 50;
			perso.y = 50;
			trace('perdu !!!! bouhouuu !!');
		}

		// SUIVIE DE LECRAN
		if (edge_of_the_screen(perso_rectangle)) {
			move_screen(perso_rectangle);
		}

		Browser.window.requestAnimationFrame(update);
	}
}
