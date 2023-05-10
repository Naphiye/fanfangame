import pixi.core.math.Point;

using Lambda;

enum Direction {
	LEFT;
	RIGHT;
	UP;
	DOWN;
}

class Maze {
	var maze_width:Int;
	var maze_height:Int;

	public function new(width:Int, height:Int) {
		this.maze_width = width;
		this.maze_height = height;
	}

	public function generate() {
		var start_point = new Point(0, 0);

		var path:Array<Point> = [start_point];
		var open_nodes:Array<Point> = [];

		var current_point = new Point(start_point.x, start_point.y);
		while (true) {
			var current_directions = random_directions(current_point, path);

			while (current_directions.length == 0) {
				if (open_nodes.length == 0) {
					return path;
				}
				current_point = open_nodes.pop();
				current_directions = random_directions(current_point, path);
			}

			if (current_directions.length > 1) {
				open_nodes.push(new Point(current_point.x, current_point.y));
			}

			var current_direction = current_directions[Std.random(current_directions.length)];

			move_point(current_point, current_direction);
			path.push(new Point(current_point.x, current_point.y));

			move_point(current_point, current_direction);
			path.push(new Point(current_point.x, current_point.y));
		}
	}

	static function move_point(p:Point, dir:Direction) {
		switch (dir) {
			case LEFT:
				p.x -= 1;
			case RIGHT:
				p.x += 1;
			case UP:
				p.y -= 1;
			case DOWN:
				p.y += 1;
		}
	}

	// on test les directions possible

	function random_directions(pt:Point, path:Array<Point>) {
		var possible_directions = [LEFT, RIGHT, UP, DOWN];

		if (pt.x == 0) {
			possible_directions.remove(LEFT);
		}
		if (pt.x == maze_width - 2) {
			possible_directions.remove(RIGHT);
		}
		if (pt.y == 0) {
			possible_directions.remove(UP);
		}
		if (pt.y == maze_height - 2) {
			possible_directions.remove(DOWN);
		}

		// Si on va aller dans un endroit où on est déjà allé, on retire
		for (dir in possible_directions.copy()) {
			var future_point = new Point(pt.x, pt.y);
			move_point(future_point, dir);
			move_point(future_point, dir);

			if (path.exists(p -> p.x == future_point.x && p.y == future_point.y)) {
				possible_directions.remove(dir);
			}
		}

		return possible_directions;
	}
}
