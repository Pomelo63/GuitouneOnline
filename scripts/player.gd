extends CharacterBody2D

@export var speed: float = 200.0
@onready var body_sprite = $Skeleton/Body
@onready var eyes_sprite = $Skeleton/Eyes
@onready var front_hair_sprite = $Skeleton/FrontHair
@onready var rear_hair_sprite = $Skeleton/RearHair
@onready var clothing_sprite = $Skeleton/Clothing
@onready var accessory_sprite = $Skeleton/Accessory
@onready var attack_sound = $AttackSound
@onready var skill_animation = $Skeleton/SkillAnimation
@onready var weapon_animation = $Skeleton/WeaponAnimation

var is_attacking = false

func _ready() -> void:
	initialize_player()
	skill_animation.animation_finished.connect(_on_skill_animation_finished)
	
# Définir l'apparence du perso en fonction des valeurs entrées dans le character_creator
func initialize_player() :

	var player_name = $Skeleton/Name
	player_name.text = Global.player["name"]
	
	var body_to_load = load("res://assets/graphics/sprites_frame/body/%s_animation.tres" % Global.player["skin"]["body"]["gender"])
	weapon_animation.sprite_frames = load("res://assets/graphics/sprites_frame/skill/%s.tres" % Global.classes[Global.player["class"]]["name"])
	skill_animation.sprite_frames = load("res://assets/graphics/sprites_frame/skill/%s_animation.tres" % Global.classes[Global.player["class"]]["name"])

	# Vérifie si la couleur sélectionnée est le blond
	if Global.player["skin"]["body"]["color"] == Color(0.976, 0.757, 0.616, 1.0):
		# Appliquer le shader pour le blanc sans modification
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("is_white", 1.0)  # Désactive le shader pour le blond
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("body_color", Global.player["skin"]["body"]["color"])
	else:
		# Appliquer le shader pour toutes les autres couleurs
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("is_white", 0.0)  # Active le shader pour les autres couleurs
		($Skeleton/Body.material as ShaderMaterial).set_shader_parameter("body_color", Global.player["skin"]["body"]["color"])

	body_sprite.sprite_frames = body_to_load
	body_sprite.play("idle_down")

	# Vérifie si la couleur sélectionnée est le blond
	if Global.player["skin"]["eyes"]["color"] == Color(0.0, 0.51, 1.0, 1.0):
		# Appliquer le shader pour le blanc sans modification
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("is_blue", 1.0)  # Désactive le shader pour le blond
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("eyes_color", Global.player["skin"]["eyes"]["color"])
	else:
		# Appliquer le shader pour toutes les autres couleurs
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("is_blue", 0.0)  # Active le shader pour les autres couleurs
		($Skeleton/Eyes.material as ShaderMaterial).set_shader_parameter("eyes_color", Global.player["skin"]["eyes"]["color"])
	
	var front_hair_to_load = load("res://assets/graphics/sprites_frame/front_hair/"+Global.player["skin"]["body"]["gender"]+"_%d_animation.tres" % Global.player["skin"]["hair"]["front"])
	front_hair_sprite.sprite_frames = front_hair_to_load
	front_hair_sprite.play("idle_down")
	
	var rear_hair_to_load = load("res://assets/graphics/sprites_frame/rear_hair/"+Global.player["skin"]["body"]["gender"]+"_%d_animation.tres" % Global.player["skin"]["hair"]["rear"])
	rear_hair_sprite.sprite_frames = rear_hair_to_load
	rear_hair_sprite.play("idle_down")
	
	# Vérifie si la couleur sélectionnée est le blond
	if Global.player["skin"]["hair"]["color"] == Color(1.0, 0.85, 0.4, 1.0):
		# Appliquer le shader pour le blanc sans modification
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("is_blond", 1.0)  # Désactive le shader pour le blond
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("hair_color", Global.player["skin"]["hair"]["color"])
	else:
		# Appliquer le shader pour toutes les autres couleurs
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("is_blond", 0.0)  # Active le shader pour les autres couleurs
		($Skeleton/FrontHair.material as ShaderMaterial).set_shader_parameter("hair_color", Global.player["skin"]["hair"]["color"])
	
	var clothing_to_load = load("res://assets/graphics/sprites_frame/clothing/"+Global.player["skin"]["body"]["gender"]+"_%d_animation.tres" % Global.player["skin"]["clothing"]["sprite"])
	clothing_sprite.sprite_frames = clothing_to_load
	clothing_sprite.play("idle_down")
	
	var accessory_to_load = load("res://assets/graphics/sprites_frame/accessory/"+Global.player["skin"]["body"]["gender"]+"_%d_animation.tres" % Global.player["skin"]["accessory"]["sprite"])
	accessory_sprite.sprite_frames = accessory_to_load
	accessory_sprite.play("idle_down")

# Mouvements
var last_direction: String = "down"

func _physics_process(_delta: float) -> void:
		# Si le joueur est en train de discuter, on empêche tout mouvement
	if Global.on_cutscene:
		velocity = Vector2.ZERO
		move_and_collide(velocity)  # Assurez-vous qu'il ne se déplace pas
		play_idle_animation()
		return  # On arrête ici l'exécution du code pour empêcher les mouvements
		
	if is_attacking:
		# On bloque tout mouvement et animation pendant l'attaque
		return
	
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Empêche les diagonales
	if input_vector.x != 0:
		input_vector.y = 0
	elif input_vector.y != 0:
		input_vector.x = 0

	velocity = input_vector * speed

	if input_vector != Vector2.ZERO:
		move_and_slide()

		update_animation(input_vector)
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		play_idle_animation()
		
	if Input.is_action_just_pressed("ui_attack") and not is_attacking:
		attack_animation()
		
# Animations de marche
func update_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			body_sprite.play("walk_right")
			eyes_sprite.play("walk_right")
			clothing_sprite.play("walk_right")
			front_hair_sprite.play("walk_right")
			rear_hair_sprite.play("walk_right")
			accessory_sprite.play("walk_right")
			last_direction = "right"
		else:
			body_sprite.play("walk_left")
			eyes_sprite.play("walk_left")
			clothing_sprite.play("walk_left")
			front_hair_sprite.play("walk_left")
			rear_hair_sprite.play("walk_left")
			accessory_sprite.play("walk_left")
			last_direction = "left"
	else:
		if direction.y > 0:
			body_sprite.play("walk_down")
			eyes_sprite.play("walk_down")
			clothing_sprite.play("walk_down")
			front_hair_sprite.play("walk_down")
			rear_hair_sprite.play("walk_down")
			accessory_sprite.play("walk_down")
			last_direction = "down"
		else:
			body_sprite.play("walk_up")
			eyes_sprite.play("walk_up")
			clothing_sprite.play("walk_up")
			front_hair_sprite.play("walk_up")
			rear_hair_sprite.play("walk_up")
			accessory_sprite.play("walk_up")
			last_direction = "up"

func play_idle_animation() -> void:
	body_sprite.play("idle_" + last_direction)
	eyes_sprite.play("idle_" + last_direction)
	clothing_sprite.play("idle_" + last_direction)
	front_hair_sprite.play("idle_" + last_direction)
	rear_hair_sprite.play("idle_" + last_direction)
	accessory_sprite.play("idle_" + last_direction)
	skill_animation.play("idle")
	weapon_animation.play("idle")
	
func attack_animation() -> void:
	is_attacking = true
	skill_animation.play("attack_" + last_direction)
	# Les autres éléments (yeux, vêtements) ne changent pas pour l'instant
	# On pourra les animer si tu veux plus tard
	weapon_animation.play("attack_" + last_direction)
	attack_sound.pitch_scale = randf_range(0.9, 1.1) # Varie un peu la hauteur du son
	attack_sound.play()

func _on_skill_animation_finished() -> void:
	if skill_animation.animation.begins_with("attack_"):
		is_attacking = false
		play_idle_animation()
