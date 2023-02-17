import pygame, sys
 
pygame.init()
 
ECRAN_LARGEUR = 320
ECRAN_HAUTEUR = 200
SCREEN = pygame.display.set_mode((ECRAN_LARGEUR, ECRAN_HAUTEUR))
 
character_image = pygame.image.load("perso.png").convert_alpha()
xperso = 100
yperso = 100
SCREEN.blit(character_image, (xperso, yperso))
 
PERSO_HAUTEUR = character_image.get_height()
PERSO_LARGEUR = character_image.get_width()
PERSO_VITESSE = 10

WALL_POS = [(10, 10), (20, 10), (30, 10), (20, 20), (50, 50), (20, 50), (100, 50), (150, 150), (90, 60), (100, 150)]

wall_image = pygame.image.load("wall.jpeg") .convert_alpha ()
MUR_HAUTEUR = wall_image.get_height()
MUR_LARGEUR = wall_image.get_width()

def draw_character(xperso, yperso):
    black = (0, 0, 0)
    SCREEN.fill(black)
    SCREEN.blit(character_image, (xperso, yperso))


def draw_wall(WALL_POS):
    SCREEN.blit(wall_image, (WALL_POS))

def collision_point (wall_rect, perso_rect):

    if (perso_rect[0]+ perso_rect[2]) < wall_rect[0] : # a gauche du mur
        return False
    if perso_rect[0] > wall_rect[0] + wall_rect[2]: # a droite du mur
        return False
    if (perso_rect[1] + perso_rect[3]) < wall_rect[1]: # en haut du mur
        return False
    if perso_rect [1]  > wall_rect[1] + wall_rect[3] : # en bas du mur
        return False
    return True

def inside_screen (perso_rect, ECRAN_LARGE, ECRAN_HAUT):
        
    if (perso_rect [0] - PERSO_VITESSE) < 0 : # a gauche de lecran 
        return False
    if (perso_rect [0] + perso_rect[2]) + PERSO_VITESSE > ECRAN_LARGE : # a droite de lecran
        return False
    if (perso_rect [1] - PERSO_VITESSE) < 0 : # en haut de lecran
        return False
    if (perso_rect [1] + perso_rect [3]) + PERSO_VITESSE > ECRAN_HAUT : # en bas de lecran
        return False
    return True

def moving_ok (m):
    for  in all_wall_rectangle:
        if collision_point (all_wall_rectangle, futur_perso_rectangle):
            return False
    if not inside_screen (perso_rect, ECRAN_LARGE, ECRAN_HAUT):
        return False
    return True
# renvoyer true quand collision point = false  and inside screen = true


all_wall_rectangle = []

continuer = True

while continuer:
    draw_character(xperso, yperso)
    for wall in WALL_POS:
        draw_wall (wall)

    for wall in WALL_POS:
        xmur = wall [0]
        ymur = wall [1] 

        wall_rectangle = (xmur,ymur, MUR_LARGEUR, MUR_HAUTEUR)

        all_wall_rectangle.append ((xmur, ymur, MUR_LARGEUR, MUR_HAUTEUR))

        
    pygame.display.flip()

 
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            continuer = False

        elif event.type == pygame.KEYDOWN:
            vitesse_x_perso = 0
            vitesse_y_perso = 0
             
            if event.key == pygame.K_RIGHT:
               vitesse_x_perso = PERSO_VITESSE
            elif event.key == pygame.K_LEFT:
                vitesse_x_perso = - PERSO_VITESSE
            elif event.key == pygame.K_UP:
                vitesse_y_perso = - PERSO_VITESSE       
            elif event.key == pygame.K_DOWN:
                vitesse_y_perso = PERSO_VITESSE


            futur_x_perso = xperso + vitesse_x_perso
            futur_y_perso = yperso + vitesse_y_perso
            futur_perso_rectangle = (futur_x_perso,futur_y_perso,PERSO_LARGEUR,PERSO_HAUTEUR)
               
            if moving_ok for walls in all_wall_rectangle :
                            xperso = futur_x_perso
                            yperso = futur_y_perso


            
        #elif event.type == pygame.KEYUP:

            #moving = pygame.key.get_pressed()
            #if moving [pygame.K_RIGHT]:
                #vitesse_x_perso = PERSO_VITESSE
                #print("right is pressed")
            #if moving [pygame.K_LEFT]:
                #print("left is pressed")

#il imprime que quand une autre touche et maintenant en meme temps ...

pygame.quit()

