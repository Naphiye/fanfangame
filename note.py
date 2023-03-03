note


fswatch -o Main.hx | xargs -n1 -I{} haxe make.hxml

 python3 -m http.server



    
	static function Wall_pop(WallImage:Rectangle, perso:Rectangle) {
		if ((WallImage.x + WallImage.width) < perso.x) // mur a gauche du personnage
		{
			return false;
		}
		if (WallImage.x < perso.x) // mur a gauche du personnage
		{
			return false;
		} if ((WallImage.y + WallImage.height != perso.y))
		{
			return false
		}

	else {
		return true;
	}
	}

            


not collision_point (wall_rectangle, perso_rectangle) and inside_screen (perso_rectangle, ECRAN_LARGEUR, ECRAN_HAUTEUR):
not collision_point (wall_rectangle, perso_rectangle) and inside_screen (perso_rectangle, ECRAN_LARGEUR, ECRAN_HAUTEUR):



déplacement continu plusieurs choix :

get pressed : etat booleen de chaque touche , enfoncé = true 

event keydown acceleration and event key up acceleration 0 ?

set repeat ?