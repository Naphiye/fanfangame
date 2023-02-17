note


 if not collision_point (all_wall_rectangle[0], futur_perso_rectangle) and not collision_point (all_wall_rectangle[1], futur_perso_rectangle) and not collision_point (all_wall_rectangle[2], futur_perso_rectangle) and not collision_point (all_wall_rectangle[3], futur_perso_rectangle) and not collision_point (all_wall_rectangle[4], futur_perso_rectangle) and not collision_point (all_wall_rectangle[5], futur_perso_rectangle) and not collision_point (all_wall_rectangle[6], futur_perso_rectangle) and not collision_point (all_wall_rectangle[7], futur_perso_rectangle) and not collision_point (all_wall_rectangle[8], futur_perso_rectangle) and not collision_point (all_wall_rectangle[9], futur_perso_rectangle)  and  inside_screen (futur_perso_rectangle, ECRAN_LARGEUR, ECRAN_HAUTEUR):


and (xperso, yperso) != (xmur + LARGMUR, ymur) and yperso + HAUTPERSO < ymur or yperso > ymur + HAUTMUR or ( yperso == ymur and xperso != xmur + LARGMUR ):


and (xperso , yperso) != (xmur, ymur + HAUTMUR) and xperso + HAUTPERSO < xmur or xperso > xmur + HAUTMUR

and (xperso + HAUTPERSO, yperso) != (xmur, ymur) and xperso + HAUTPERSO < xmur or xperso > xmur + HAUTMUR


or ( xperso > xmur + LARGMUR and xperso + LARGPERSO < xmur) or ( )



and (xperso , yperso) != (xmur, ymur + HAUTMUR) and (xperso + HAUTPERSO < xmur or xperso > xmur + HAUTMUR) or ( yperso + HAUTPERSO > ymur  or yperso < ymur + HAUTMUR) 





and ((yperso + PERSO_HAUTEUR < ymur or yperso > ymur + MUR_HAUTEUR) or (xperso + PERSO_VITESSE > xmur + MUR_LARGEUR or xperso + PERSO_VITESSE + PERSO_LARGEUR < xmur) or (yperso + PERSO_HAUTEUR == ymur) or (yperso == ymur + MUR_HAUTEUR)):




    


            


not collision_point (wall_rectangle, perso_rectangle) and inside_screen (perso_rectangle, ECRAN_LARGEUR, ECRAN_HAUTEUR):
not collision_point (wall_rectangle, perso_rectangle) and inside_screen (perso_rectangle, ECRAN_LARGEUR, ECRAN_HAUTEUR):



déplacement continu plusieurs choix :

get pressed : etat booleen de chaque touche , enfoncé = true 

event keydown acceleration and event key up acceleration 0 ?

set repeat ?