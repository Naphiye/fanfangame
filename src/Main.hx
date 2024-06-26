import js.html.MediaDeviceInfo;
import js.html.Text;
import pixi.core.math.Point;
import js.lib.Promise;
import pixi.core.textures.Texture;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.text.TextStyle;
import js.Browser;
import pixi.core.Application;

using Lambda;

// https://pixijs.download/v5.2.2/docs/index.html
class Main {
	static inline var ECRAN_LARGE:Int = 1024;
	static inline var ECRAN_HAUT:Int = 768;
	static inline var PERSO_VITESSE:Int = 6;
	static inline var PERSO_VITESSE_PLUS:Int = PERSO_VITESSE * 2;
	static inline var PERSO_STOP:Int = 0;
	static inline var PERSO_DEPART_X:Int = 50;
	static inline var PERSO_DEPART_Y:Int = 50;
	static inline var NUM_COINS:Int = 0;
	static inline var NUM_WALLS:Int = 50;
	static inline var NUM_GHOSTS:Int = 0;
	static inline var NUM_STARS:Int = 10;

	static var screen:Sprite;

	static var perso:Perso;

	static var vitesse_perso:Int = PERSO_VITESSE;

	static var other_rectangle:Array<Rectangle> = [];

	static var walls:Array<Wall> = [];
	static var coins:Array<Coin> = [];
	static var ghosts:Array<Ghost> = [];
	static var stars:Array<Star> = [];
	static var stairs:Stairs;

	static var finish_timer:Float;

	static function main() {
		// Preload
		var persoProm = Texture.fromURL('images/perso.png');
		var murProm = Texture.fromURL('images/wall.jpeg');
		var starProm = Texture.fromURL('images/star.png');
		var stairsProm = Texture.fromURL('images/stairs.png');
		var ghostProm = Texture.fromURL('images/ghost.png');
		var coinProm = Texture.fromURL('images/coin.png');

		Promise.all([persoProm, murProm, starProm, stairsProm, ghostProm, coinProm]).then(startGame);
	}

	static function startGame(_) {
		KeyboardManager.init();

		var app = new Application({backgroundColor: 0x000000, width: ECRAN_LARGE, height: ECRAN_HAUT});
		Browser.document.body.appendChild(app.view);

		screen = new Sprite();
		app.stage.addChild(screen);

		// PERSO
		var perso_x = 0;
		var perso_y = 0;
		perso = new Perso(perso_x, perso_y);
		var perso_rectangle:Rectangle = perso.getBounds();
		other_rectangle.push(perso_rectangle);
		perso.addToStage(screen);

		// MURS
		var wall_sprite_template = Sprite.from('images/wall.jpeg');

		var maze_width = 78;
		var maze_height = 58;

		var maze = new Maze(maze_width, maze_height);
		var path = maze.generate();

		function sur_path(grille_x:Int, grille_y:Int) {
			for (p in path) {
				if (grille_x == p.x && grille_y == p.y) {
					return true;
				}
			}

			return false;
		}

		for (grille_x in 0...maze_width) {
			for (grille_y in 0...maze_height) {
				if (!sur_path(grille_x, grille_y)) {
					var wall_x = Std.int(grille_x * wall_sprite_template.width);
					var wall_y = Std.int(grille_y * wall_sprite_template.height);
					var wall = new Wall(wall_x, wall_y);
					wall.addToStage(screen);
					walls.push(wall);
				}
			}
		}

		// draw_wall_fence(wall_sprite_template);

		// STAIRS
		var stairs_number = 0;
		while (stairs_number < 1) {
			var stairs_x = Std.random(ECRAN_LARGE * 3);
			var stairs_y = Std.random(ECRAN_HAUT * 3);
			stairs = new Stairs(stairs_x, stairs_y);
			var stairs_rectangle:Rectangle = stairs.getBounds();
			if (has_no_superposition(stairs_rectangle, walls.map(w -> w.getBounds()))
				&& has_no_superposition(stairs_rectangle, other_rectangle)) {
				stairs.addToStage(screen);

				other_rectangle.push(stairs_rectangle);
				stairs_number += 1;
			}
		}

		// STAR
		var star_number = 0;
		while (star_number < NUM_STARS) {
			var star_x = Std.random(ECRAN_LARGE * 3);
			var star_y = Std.random(ECRAN_HAUT * 3);
			var star = new Star(star_x, star_y);
			var star_rectangle:Rectangle = star.getBounds();

			if (has_no_superposition(star_rectangle, walls.map(w -> w.getBounds()))
				&& has_no_superposition(star_rectangle, other_rectangle)) {
				star_number += 1;
				star.addToStage(screen);
				stars.push(star);
				other_rectangle.push(star_rectangle);
			}
		}

		// GHOST
		/*var ghost_sprite_template = Sprite.from('images/ghost.png');

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
		}*/

		// COINS
		var coin_number = 0;
		while (coin_number < NUM_COINS) {
			var coin_x = Std.random(ECRAN_LARGE * 3);
			var coin_y = Std.random(ECRAN_HAUT * 3);

			var coin = new Coin(coin_x, coin_y);
			var coin_rectangle:Rectangle = coin.getBounds();
			if (has_no_superposition(coin_rectangle, coins.map(c -> c.getBounds()))
				&& has_no_superposition(coin_rectangle, walls.map(w -> w.getBounds()))
				&& has_no_superposition(coin_rectangle, other_rectangle)) {
				coin_number += 1;
				coin.addToStage(screen);
				coins.push(coin);
			}
		}

		Browser.window.requestAnimationFrame(update);
	}

	static function draw_wall_fence(wall_sprite_template:Sprite) {
		// MURAILLE DU HAUT
		var wall_x = -60;
		var wall_y = -60;
		var wall = new Wall(wall_x, wall_y);
		wall.addToStage(screen);
		for (i in 0...103) {
			if (wall_x < ((ECRAN_LARGE * 3) - Std.int(wall_sprite_template.width))) {
				wall_x += 30;
				var wall = new Wall(wall_x, wall_y);

				wall.addToStage(screen);
				walls.push(wall);
			}
		}

		// MURAILLE DE GAUCHE
		var wall_x = -60;
		var wall_y = -60;
		var wall = new Wall(wall_x, wall_y);
		wall.addToStage(screen);
		for (i in 0...77) {
			if (wall_y < ((ECRAN_HAUT * 3) - Std.int(wall_sprite_template.height))) {
				wall_y += 30;
				var wall = new Wall(wall_x, wall_y);

				wall.addToStage(screen);
				walls.push(wall);
			}
		}
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
		var perso_sprite_template = Sprite.from('images/perso.png');
		var vitesse_x_perso;
		var vitesse_y_perso;

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

		var futur_x_perso = (perso.getX() + vitesse_x_perso);
		var futur_y_perso = (perso.getY() + vitesse_y_perso);
		var futur_perso_rectangle:Rectangle = new Rectangle(futur_x_perso, futur_y_perso, perso_sprite_template.width, perso_sprite_template.height);

		if (moving_ok(walls, futur_perso_rectangle)) {
			perso.changeX(futur_x_perso);
			perso.changeY(futur_y_perso);
		} else {
			// DEPLACEMENTS DIAGONALES
			if (vitesse_x_perso != 0 && vitesse_y_perso != 0) {
				// déplacement diagonale

				// est ce que je peux me déplacer à l'horizontale
				var futur_perso_rectangle_horizontale:Rectangle = new Rectangle(futur_x_perso, perso.getY(), perso_sprite_template.width,
					perso_sprite_template.height);
				var futur_perso_rectangle_verticale:Rectangle = new Rectangle(perso.getX(), futur_y_perso, perso_sprite_template.width,
					perso_sprite_template.height);
				if (moving_ok(walls, futur_perso_rectangle_horizontale)) {
					perso.changeX(futur_x_perso);
				}
				// sinon est ce que je peux me deplacer à la verticale
				else if (moving_ok(walls, futur_perso_rectangle_verticale)) {
					perso.changeY(futur_y_perso);
				}
			}
		}

		// INTERACTIONS AVEC OBJETS

		// COINS OBLIGATOIRES
		// Pour chaque coin dans le tableau coins
		for (coin in coins) {
			coin.update(time);
			// Si ça collisionne avec le personnage
			if (coin.isTakable() && collision_point(coin.getBounds(), perso.getBounds())) {
				// le coin n'est plus visible et plus collisionnable
				coin.take();
			}
		}
		// GHOSTS PIEGES
		// Pour chaque ghost dans le tableau ghosts
		for (ghost in ghosts) {
			// Si ça collisionne avec le personnage
			if (ghost.isTakable() && collision_point(ghost.getBounds(), perso.getBounds())) {
				// le perso retourne au départ
				perso.changeX(PERSO_DEPART_X);
				perso.changeY(PERSO_DEPART_Y);
				trace('perdu !!!! bouhouuu !!OK');
			}
		}

		// STAR FOR FAST SPEED

		// Pour chaque star dans le tableau stars
		for (star in stars) {
			// Si ça collisionne avec le personnage
			if (star.isTakable() && collision_point(star.getBounds(), perso.getBounds())) {
				// Le personnage accélère.
				vitesse_perso = PERSO_VITESSE_PLUS;
				// l'étoile n'est plus visible et plus collisionable
				star.take(time);
				// Informations de l'Acceleration
				var startext = new pixi.core.text.Text('Accélération !', {
					fontFamily: 'Verdana',
					fontSize: 55,
					fill: 0xc1e8e7,
					align: 'center',
				});

				screen.addChild(startext);

				startext.x = -screen.x;
				startext.y = -screen.y;
			}
			// si le personnage est rapide depuis un certain delay
			if (star.isOver(time)) {
				// le personnage reprend sa vitesse normal
				vitesse_perso = PERSO_VITESSE;
				star.untake();
			}
		}

		// STAIRS FOR FINISH

		if (collision_point(perso.getBounds(), (stairs.getBounds()))) {
			finish_timer = (time / 1000);

			finish();
			if (perso.getX() == stairs.getX() && perso.getY() == stairs.getY()) {
				return;
			}
		}

		// SUIVIE DE LECRAN
		if (edge_of_the_screen(perso.getBounds())) {
			move_screen(perso.getBounds());
		}

		Browser.window.requestAnimationFrame(update);
	}

	static public function finish() {
		// Si on a pris toutes les pièces
		if (coins.exists(c -> return !c.isTaken()))
			return;

		perso.changeX(stairs.getX());
		perso.changeY(stairs.getY());
		vitesse_perso = PERSO_STOP;

		var finishtext = new pixi.core.text.Text('Labyrinthe réalisé en  ${Std.int(finish_timer)} secondes!', {
			fontFamily: 'Verdana',
			fontSize: 55,
			fill: 0xead3eb,
			align: 'center',
		});

		screen.addChild(finishtext);

		finishtext.x = -screen.x;
		finishtext.y = -screen.y;
	}
}
