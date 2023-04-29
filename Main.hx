import pixi.core.renderers.webgl.State;
import js.html.Console;
import js.lib.Promise;
import pixi.core.textures.Texture;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import js.Browser;
import pixi.core.Application;

using Lambda;

// https://pixijs.download/v5.2.2/docs/index.html
class Main {
	static inline var ECRAN_LARGE:Int = 1024;
	static inline var ECRAN_HAUT:Int = 768;
	static inline var PERSO_VITESSE:Int = 8;
	static inline var PERSO_VITESSE_PLUS:Int = PERSO_VITESSE * 2;
	static inline var PERSO_STOP:Int = 0;
	static inline var PERSO_DEPART_X:Int = 50;
	static inline var PERSO_DEPART_Y:Int = 50;
	static inline var NUM_COINS:Int = 10;
	static inline var NUM_WALLS:Int = 50;
	static inline var NUM_GHOSTS:Int = 3;
	// static inline var NUM_STARS:Int = 2;
	static inline var DELAY_SPEED_BONUS_SECOND:Int = 5;

	static var screen:Sprite;

	static var perso:Sprite;
	static var star_bonus:Sprite;
	static var finish_stairs:Sprite;

	static var vitesse_perso:Int = PERSO_VITESSE;
	static var save_time:Float = 0;

	static var other_rectangle:Array<Rectangle> = [];

	static var walls:Array<Wall> = [];
	static var coins:Array<Coin> = [];
	static var ghosts:Array<Ghost> = [];

	// static var stars:Array<Star> = [];

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

		finish_stairs = Sprite.from('stairs.png');
		finish_stairs.x = (ECRAN_LARGE - finish_stairs.width);
		finish_stairs.y = (ECRAN_HAUT - finish_stairs.height);
		var finish_stairs_rectangle:Rectangle = new Rectangle(finish_stairs.x, finish_stairs.y, finish_stairs.width, finish_stairs.height);
		other_rectangle.push(finish_stairs_rectangle);
		screen.addChild(finish_stairs);

		perso = Sprite.from('perso.png');
		perso.x = 50;
		perso.y = 50;
		var perso_rectangle:Rectangle = new Rectangle(perso.x, perso.y, perso.width, perso.height);
		other_rectangle.push(perso_rectangle);
		screen.addChild(perso);

		// STAR
		star_bonus = Sprite.from('star.png');
		star_bonus.x = 80;
		star_bonus.y = 150;
		var star_bonus_rectangle:Rectangle = new Rectangle(star_bonus.x, star_bonus.y, star_bonus.width, star_bonus.height);
		other_rectangle.push(star_bonus_rectangle);
		screen.addChild(star_bonus);
		/*
			var star_sprite_template = Sprite.from('star.png');

			for (star_n in 0...NUM_STARS) {
				var star_x = Std.random(ECRAN_LARGE - Std.int(star_sprite_template.width));
				var star_y = Std.random(ECRAN_HAUT - Std.int(star_sprite_template.height));
				var star = new Star(star_x, star_y);
				var star_rectangle:Rectangle = star.getBounds();
				if (has_no_superposition(star_rectangle, stars.map(s -> s.getBounds()))
					&& has_no_superposition(star_rectangle, walls.map(w -> w.getBounds()))
					&& has_no_superposition(star_rectangle, other_rectangle)) {
					star.addToStage(screen);

					stars.push(star);
					other_rectangle.push(star_rectangle);
				}
		}*/

		// GHOST

		var ghost_sprite_template = Sprite.from('ghost.png');

		for (ghost_n in 0...NUM_GHOSTS) {
			var ghost_x = Std.random(ECRAN_LARGE - Std.int(ghost_sprite_template.width));
			var ghost_y = Std.random(ECRAN_HAUT - Std.int(ghost_sprite_template.height));
			var ghost = new Ghost(ghost_x, ghost_y);
			var ghost_rectangle:Rectangle = ghost.getBounds();
			if (has_no_superposition(ghost_rectangle, ghosts.map(g -> g.getBounds()))
				&& has_no_superposition(ghost_rectangle, walls.map(w -> w.getBounds()))
				&& has_no_superposition(ghost_rectangle, other_rectangle)) {
				ghost.addToStage(screen);

				ghosts.push(ghost);
				other_rectangle.push(ghost_rectangle);
			}
		}

		// MURS

		var wall_sprite_template = Sprite.from('wall.jpeg');

		for (wall_n in 0...NUM_WALLS) {
			var wall_x = Std.random(ECRAN_LARGE - Std.int(wall_sprite_template.width));
			var wall_y = Std.random(ECRAN_HAUT - Std.int(wall_sprite_template.height));
			var wall = new Wall(wall_x, wall_y);
			var wall_rectangle:Rectangle = wall.getBounds();
			if (has_no_superposition(wall_rectangle, walls.map(w -> w.getBounds()))
				&& has_no_superposition(wall_rectangle, other_rectangle)) {
				wall.addToStage(screen);

				walls.push(wall);
			}
		}

		// MURAILLE DU HAUT

		var wall_x = -(ECRAN_LARGE);
		var wall_y = -(ECRAN_HAUT);
		var wall = new Wall(wall_x, wall_y);
		wall.addToStage(screen);
		for (i in 0...103) {
			if (wall_x < ((ECRAN_LARGE * 2) - Std.int(wall_sprite_template.width))) {
				wall_x += 30;
				var wall = new Wall(wall_x, wall_y);
				wall.addToStage(screen);
				walls.push(wall);
			}
		}

		// MURAILLE DU BAS
		var wall_x = -(ECRAN_LARGE);
		var wall_y = ((ECRAN_HAUT * 2) - Std.int(wall_sprite_template.height));
		var wall = new Wall(wall_x, wall_y);
		wall.addToStage(screen);
		for (i in 0...103) {
			if (wall_x < ((ECRAN_LARGE * 2) - Std.int(wall_sprite_template.width))) {
				wall_x += 30;
				var wall = new Wall(wall_x, wall_y);
				wall.addToStage(screen);
				walls.push(wall);
			}
		}

		// MURAILLE DE GAUCHE
		var wall_x = -(ECRAN_LARGE);
		var wall_y = -(ECRAN_HAUT);
		var wall = new Wall(wall_x, wall_y);
		wall.addToStage(screen);
		for (i in 0...77) {
			if (wall_y < ((ECRAN_HAUT * 2) - Std.int(wall_sprite_template.height))) {
				wall_y += 30;
				var wall = new Wall(wall_x, wall_y);
				wall.addToStage(screen);
				walls.push(wall);
			}
		}

		// MURAILLE DE DROITE
		var wall_x = ((ECRAN_LARGE * 2) - Std.int(wall_sprite_template.width));
		var wall_y = -(ECRAN_HAUT);
		var wall = new Wall(wall_x, wall_y);
		wall.addToStage(screen);
		for (i in 0...77) {
			if (wall_y < ((ECRAN_HAUT * 2) - Std.int(wall_sprite_template.height))) {
				wall_y += 30;
				var wall = new Wall(wall_x, wall_y);
				wall.addToStage(screen);
				walls.push(wall);
			}
		}

		// COINS

		var coin_sprite_template = Sprite.from('coin.png');

		for (coin_n in 0...NUM_COINS) {
			var coin_x = Std.random(ECRAN_LARGE - Std.int(coin_sprite_template.width));
			var coin_y = Std.random(ECRAN_HAUT - Std.int(coin_sprite_template.height));
			var coin = new Coin(coin_x, coin_y);
			var coin_rectangle:Rectangle = coin.getBounds();
			if (has_no_superposition(coin_rectangle, coins.map(c -> c.getBounds()))
				&& has_no_superposition(coin_rectangle, walls.map(w -> w.getBounds()))
				&& has_no_superposition(coin_rectangle, other_rectangle)) {
				coin.addToStage(screen);

				coins.push(coin);
			}
		}

		trace('Nombre de coins affichés ${coins.length}');
		trace('Nombre de murs affichés ${walls.length}');

		Browser.window.requestAnimationFrame(update);
	}

	static function has_no_superposition(object:Rectangle, others:Array<Rectangle>) {
		for (n in others) {
			if (collision_point(object, n)) {
				return false;
			}
		}

		return true;
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

	static function moving_ok(wall_rects:Array<Wall>, perso_futur:Rectangle) {
		for (wall in wall_rects) {
			if (collision_point(wall.getBounds(), perso_futur)) {
				return false;
			}
		}
		return true;
	}

	static function update(time:Float) {
		var vitesse_x_perso;
		var vitesse_y_perso;

		var perso_rectangle:Rectangle = new Rectangle(perso.x, perso.y, perso.width, perso.height);
		var star_bonus_rectangle:Rectangle = new Rectangle(star_bonus.x, star_bonus.y, star_bonus.width, star_bonus.height);
		var finish_stairs_rectangle:Rectangle = new Rectangle(finish_stairs.x, finish_stairs.y, finish_stairs.width, finish_stairs.height);

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

		if (moving_ok(walls, futur_perso_rectangle)) {
			perso.x = futur_x_perso;
			perso.y = futur_y_perso;
		} else {
			// DEPLACEMENTS DIAGONALES
			if (vitesse_x_perso != 0 && vitesse_y_perso != 0) {
				// déplacement diagonale

				// est ce que je peux me déplacer à l'horizontale
				var futur_perso_rectangle_horizontale:Rectangle = new Rectangle(futur_x_perso, perso.y, perso.width, perso.height);
				var futur_perso_rectangle_verticale:Rectangle = new Rectangle(perso.x, futur_y_perso, perso.width, perso.height);
				if (moving_ok(walls, futur_perso_rectangle_horizontale)) {
					perso.x = futur_x_perso;
				}
				// sinon est ce que je peux me deplacer à la verticale
				else if (moving_ok(walls, futur_perso_rectangle_verticale)) {
					perso.y = futur_y_perso;
				}
			}
		}

		// INTERACTIONS AVEC OBJETS

		// COINS OBLIGATOIRES
		// Pour chaque coin dans le tableau coins
		for (coin in coins) {
			coin.update(time);
			// Si ça collisionne avec le personnage
			if (coin.isTakable() && collision_point(coin.getBounds(), perso_rectangle)) {
				// le coin n'est plus visible et plus collisionnable
				coin.take();
			}
		}
		// GHOSTS PIEGES
		// Pour chaque ghost dans le tableau ghosts
		for (ghost in ghosts) {
			// Si ça collisionne avec le personnage
			if (ghost.isTakable() && collision_point(ghost.getBounds(), perso_rectangle)) {
				// le perso retourne au départ
				perso.x = PERSO_DEPART_X;
				perso.y = PERSO_DEPART_Y;
				trace('perdu !!!! bouhouuu !!OK');
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
		/*
			// Pour chaque star dans le tableau stars
			for (star in stars) {
				star.update(time);
				// Si ça collisionne avec le personnage
				if (star.isTakable() && collision_point(star.getBounds(), perso_rectangle)) {
					// Le personnage accélère pendant 5 secondes
					vitesse_perso = PERSO_VITESSE_PLUS;
					trace('BONUS VITESSE');
				}
				if (vitesse_perso == PERSO_VITESSE_PLUS && save_time + (DELAY_SPEED_BONUS_SECOND * 1000) < time) {
					vitesse_perso = PERSO_VITESSE;
					trace('Fin du bonus');
				}
		}*/

		// STAIRS FOR FINISH
		if (collision_point(finish_stairs_rectangle, perso_rectangle)) {
			finish();
		}
		// SUIVIE DE LECRAN
		if (edge_of_the_screen(perso_rectangle)) {
			move_screen(perso_rectangle);
		}
		Browser.window.requestAnimationFrame(update);
	}

	static public function finish() {
		// Si on a pris toutes les pièces
		if (coins.exists(c -> return !c.isTaken()))
			return;

		perso.x = finish_stairs.x;
		perso.y = finish_stairs.y;
		vitesse_perso = PERSO_STOP;
		trace('Gagné !!!!');
	}
}
