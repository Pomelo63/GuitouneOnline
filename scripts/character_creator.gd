extends Node2D
 
@onready var player_name = ""
@onready var background1 = $ColorRect
@onready var background2 = $ColorRect3
@onready var se_click = $ChoiceSelection
@onready var se_validation = $ValidationSound

var selected_body_color = Color(0.976, 0.757, 0.616)
var selected_hair_color = Color(1.0, 0.85, 0.4)
var selected_eyes_color = Color(0.0, 0.51, 1.0)
var selected_gender = "male"

# Entrer les valeurs max de collection présentent dans le dossier relatif à cette collection
var class_collection = ["1","2"]
var front_hair_collection = ["0","1","2"]
var rear_hair_collection = ["0","1","2"]

# Définir une valeur de base pour chaque collection
var current_class = 0
var current_front_hair = 0
var current_rear_hair = 0

func _ready() -> void:
	accessories_change()
	clothing_change()
	background2.position.x = background1.texture.get_width()  # Positionner background2 à côté de background1

func _on_gender_button_pressed() -> void:
	if selected_gender == "male":
		selected_gender = "female"
	else:
		selected_gender = "male"
	
	gender_change()
	se_click.play()
	

# Changer la couleur du body
var body_colors = [
	Color(0.976, 0.757, 0.616),   # blanc d'origine (opaque)
	Color(0.722, 0.537, 0.404), # Teint mat / moyen
	Color(0.843, 0.682, 0.510),  # Teint beige / olivâtre
	Color(0.431, 0.278, 0.180)  # Teint foncé / brun profond
]

var body_base_material : ShaderMaterial = preload("res://assets/graphics/shaders/body_shader_material.tres")  # ShaderMaterial pour les autres couleurs
var body_current_color_index := 0

func _on_body_color_button_pressed() -> void:
	body_current_color_index = (body_current_color_index + 1) % body_colors.size()
	selected_body_color = body_colors[body_current_color_index]

	# Vérifie si la couleur sélectionnée est le blond
	if selected_body_color == Color(0.976, 0.757, 0.616, 1.0):
		# Appliquer le shader pour le blanc sans modification
		$Skeleton/Body.material = body_base_material
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("is_white", 1.0)  # Désactive le shader pour le blond
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("body_color", selected_body_color)
	else:
		# Appliquer le shader pour toutes les autres couleurs
		$Skeleton/Body.material = body_base_material
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("is_white", 0.0)  # Active le shader pour les autres couleurs
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("body_color", selected_body_color)
		
	se_click.play()

# Changer la couleur des yeux
var eyes_colors = [
	Color(0.0, 0.51, 1.0),   # bleu d'origine (opaque)
	Color(0.6, 1.0, 0.6), # yeux verts
	Color(0.55, 0.27, 0.07), # yeux marrons
	Color(1.0, 0.0, 0.0) # yeux rouges
]

var eyes_base_material : ShaderMaterial = preload("res://assets/graphics/shaders/eyes_shader_material.tres")  # ShaderMaterial pour les autres couleurs
var eyes_current_color_index := 0

func _on_eyes_color_button_pressed() -> void:
	eyes_current_color_index = (eyes_current_color_index + 1) % eyes_colors.size()
	selected_eyes_color = eyes_colors[eyes_current_color_index]

	# Vérifie si la couleur sélectionnée est le blond
	if selected_eyes_color == Color(0.0, 0.51, 1.0, 1.0):
		# Appliquer le shader pour le blanc sans modification
		$Skeleton/Eyes.material = eyes_base_material
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("is_blue", 1.0)  # Désactive le shader pour le blond
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("eyes_color", selected_eyes_color)
	else:
		# Appliquer le shader pour toutes les autres couleurs
		$Skeleton/Eyes.material = eyes_base_material
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("is_blue", 0.0)  # Active le shader pour les autres couleurs
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("eyes_color", selected_eyes_color)
		
	se_click.play()


func _on_front_hair_collection_button_pressed() -> void:
	# On vérifie si on est pas arrivé en fin de liste
	if current_front_hair < front_hair_collection.size() -1 :
		current_front_hair += 1
	else :
		current_front_hair = 0
	front_hair_change()
	se_click.play()

func _on_rear_hair_collection_button_2_pressed() -> void:
	# On vérifie si on est pas arrivé en fin de liste
	if current_rear_hair < rear_hair_collection.size() -1 :
		current_rear_hair += 1
	else :
		current_rear_hair = 0
	rear_hair_change()
	se_click.play()

# Changer la couleur des cheveux
var hair_colors = [
	Color(1.0, 0.85, 0.4),   # Blond doré chaud (opaque)
	Color(0.66, 0.45, 0.43),  # Châtain clair (opaque)
	Color(0.3, 0.25, 0.30),  # Brun foncé (opaque)
	Color(1.0, 0.5, 0.2),     # Roux (opaque)
	Color(0.4, 0.7, 1.0),     # Bleu ciel (opaque)
	Color(1.0, 0.6, 0.8),     # Rose clair (opaque)
	Color(0.9, 0.2, 0.2),     # Rouge (opaque)
	Color(0.6, 0.4, 1.0),     # Violet (opaque)
	Color(0.6, 1.0, 0.6),     # Vert clair (opaque)
	Color(1.0, 1.0, 1.0),     # Platine (blanc pur) (opaque)
]

var base_material : ShaderMaterial = preload("res://assets/graphics/shaders/hair_shader_material.tres")  # ShaderMaterial pour les autres couleurs
var current_color_index := 0

func _on_hair_color_button_pressed() -> void:
	current_color_index = (current_color_index + 1) % hair_colors.size()
	selected_hair_color = hair_colors[current_color_index]

	# Vérifie si la couleur sélectionnée est le blond
	if selected_hair_color == Color(1.0, 0.85, 0.4, 1.0): # Blond doré chaud
		# Appliquer le shader pour le blond sans modification
		$Skeleton/FrontHair.material = base_material
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("is_blond", 1.0)  # Désactive le shader pour le blond
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("hair_color", selected_hair_color)
	else:
		# Appliquer le shader pour toutes les autres couleurs
		$Skeleton/FrontHair.material = base_material
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("is_blond", 0.0)  # Active le shader pour les autres couleurs
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("hair_color", selected_hair_color)
	se_click.play()

func _on_line_edit_text_changed(_new_text: String) -> void:
	var input_name = $CreatorScreen/ColorRect/InputName/LineEdit
	player_name = input_name.text
	
func _on_class_collection_button_pressed() -> void:
	# On vérifie si on est pas arrivé en fin de liste
	if current_class < class_collection.size() -1 :
		current_class += 1
	else :
		current_class = 0
	clothing_change()
	accessories_change()
	class_description_change()
	se_click.play()

func _on_confirm_button_pressed() -> void:
	se_validation.play()
	await get_tree().create_timer(0.4).timeout  # 0.5 secondes de délai (à ajuster selon la durée du son)
	on_confirmation()
	
func on_confirmation() -> void :
	if player_name == "":
		$CreatorScreen/SnackBar.text = "Choisissez un nom pour votre personnage."
		$CreatorScreen/SnackBar.visible = true
	else:
		Global.player["skin"]["body"]["gender"] = selected_gender
		Global.player["skin"]["body"]["color"] = selected_body_color
		Global.player["skin"]["eyes"]["color"] = selected_eyes_color
		Global.player["skin"]["hair"]["front"] = current_front_hair
		Global.player["skin"]["hair"]["rear"] = current_rear_hair
		Global.player["skin"]["hair"]["color"] = selected_hair_color
		Global.player["skin"]["clothing"]["sprite"] = current_class +1
		Global.player["skin"]["accessory"]["sprite"] = current_class +1
		Global.player["name"] = player_name
		Global.player["class"] = current_class+1
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func accessories_change() :
	var accessory_to_load = load("res://assets/graphics/sprites_frame/accessory/" + selected_gender + "_"  +  class_collection[current_class] +"_animation.tres" )
	var accessory_sprite = $Skeleton/Accessory
	accessory_sprite.sprite_frames = accessory_to_load
	accessory_sprite.play("idle_down")
	
func rear_hair_change() :
	var rear_hair_to_load = load("res://assets/graphics/sprites_frame/rear_hair/" + selected_gender + "_"  +  rear_hair_collection[current_rear_hair] +"_animation.tres" )
	var rear_hair_sprite = $Skeleton/RearHair
	rear_hair_sprite.sprite_frames = rear_hair_to_load
	rear_hair_sprite.play("idle_down")
	
func front_hair_change() :
	var front_hair_to_load = load("res://assets/graphics/sprites_frame/front_hair/" + selected_gender + "_"  +  front_hair_collection[current_front_hair] +"_animation.tres" )
	var front_hair_sprite = $Skeleton/FrontHair
	front_hair_sprite.sprite_frames = front_hair_to_load
	front_hair_sprite.play("idle_down")
	
func clothing_change() :
	var clothing_to_load = load("res://assets/graphics/sprites_frame/clothing/" + selected_gender + "_" + class_collection[current_class] +"_animation.tres" )
	var clothing_sprite = $Skeleton/Clothing
	clothing_sprite.sprite_frames = clothing_to_load
	clothing_sprite.play("idle_down")
	
func body_change() :
	var body_to_load = load("res://assets/graphics/sprites_frame/body/" + selected_gender + "_animation.tres" )
	var body_sprite = $Skeleton/Body
	body_sprite.sprite_frames = body_to_load
	body_sprite.play("idle_down")
	
func gender_change() :
	body_change()
	accessories_change()
	rear_hair_change()
	front_hair_change()
	clothing_change()

func _on_gender_previous_pressed() -> void:
	if selected_gender == "male":
		selected_gender = "female"
	else:
		selected_gender = "male"
	
	gender_change()
	se_click.play()

func _on_body_color_previous_pressed() -> void:
	body_current_color_index = (body_current_color_index - 1) % body_colors.size()
	selected_body_color = body_colors[body_current_color_index]

	# Vérifie si la couleur sélectionnée est le blond
	if selected_body_color == Color(0.976, 0.757, 0.616, 1.0):
		# Appliquer le shader pour le blanc sans modification
		$Skeleton/Body.material = body_base_material
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("is_white", 1.0)  # Désactive le shader pour le blond
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("body_color", selected_body_color)
	else:
		# Appliquer le shader pour toutes les autres couleurs
		$Skeleton/Body.material = body_base_material
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("is_white", 0.0)  # Active le shader pour les autres couleurs
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("body_color", selected_body_color)
	
	se_click.play()


func _on_front_hair_collection_previous_pressed() -> void:
	# On vérifie si on est pas arrivé en fin de liste
	if current_front_hair == 0:
		current_front_hair = front_hair_collection.size() -1
	else :
		current_front_hair = current_front_hair -1
	front_hair_change()
	se_click.play()


func _on_rear_hair_collection_previous_pressed() -> void:
	# On vérifie si on est pas arrivé en fin de liste
	if current_rear_hair == 0:
		current_rear_hair = rear_hair_collection.size() -1
	else :
		current_rear_hair = current_rear_hair -1
	rear_hair_change()
	se_click.play()


func _on_hair_color_previous_pressed() -> void:
	current_color_index = (current_color_index - 1) % hair_colors.size()
	selected_hair_color = hair_colors[current_color_index]

	# Vérifie si la couleur sélectionnée est le blond
	if selected_hair_color == Color(1.0, 0.85, 0.4, 1.0): # Blond doré chaud
		# Appliquer le shader pour le blond sans modification
		$Skeleton/FrontHair.material = base_material
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("is_blond", 1.0)  # Désactive le shader pour le blond
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("hair_color", selected_hair_color)
	else:
		# Appliquer le shader pour toutes les autres couleurs
		$Skeleton/FrontHair.material = base_material
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("is_blond", 0.0)  # Active le shader pour les autres couleurs
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("hair_color", selected_hair_color)
	se_click.play()


func _on_eyes_color_previous_pressed() -> void:
	eyes_current_color_index = (eyes_current_color_index - 1) % eyes_colors.size()
	selected_eyes_color = eyes_colors[eyes_current_color_index]

	# Vérifie si la couleur sélectionnée est le blond
	if selected_eyes_color == Color(0.0, 0.51, 1.0, 1.0):
		# Appliquer le shader pour le blanc sans modification
		$Skeleton/Eyes.material = eyes_base_material
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("is_blue", 1.0)  # Désactive le shader pour le blond
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("eyes_color", selected_eyes_color)
	else:
		# Appliquer le shader pour toutes les autres couleurs
		$Skeleton/Eyes.material = eyes_base_material
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("is_blue", 0.0)  # Active le shader pour les autres couleurs
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("eyes_color", selected_eyes_color)
	se_click.play()


func _on_class_collection_previous_pressed() -> void:
	if current_class == 0:
		current_class = class_collection.size() -1
	else :
		current_class = current_class -1
	accessories_change()
	clothing_change()
	class_description_change()
	se_click.play()

func class_description_change():
	$ColorRect2/ClassName.text = Global.classes[current_class +1]["name"]
	$ColorRect2/TextureRect.texture = load("res://assets/graphics/icons/class/" + Global.classes[current_class +1]["name"] + ".png")
	$ColorRect2/ClassDescription.text = Global.classes[current_class +1]["description"]


var speed = 10  # Vitesse de défilement

func _process(delta):
	# Déplacer les deux fonds sur l'axe X
	background1.position.x -= speed * delta
	background2.position.x -= speed * delta

	# Si le premier fond (background1) est complètement hors de l'écran, le repositionner après background2
	if background1.position.x <= -background1.texture.get_width():
		background1.position.x = background2.position.x + background2.texture.get_width()

	# Si le deuxième fond (background2) est complètement hors de l'écran, le repositionner après background1
	if background2.position.x <= -background2.texture.get_width():
		background2.position.x = background1.position.x + background1.texture.get_width()
