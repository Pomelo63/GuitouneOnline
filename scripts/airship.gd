extends CharacterBody2D

@export var speed: float = 200.0
@onready var airship_sprite = $AnimatedSprite2D

# Mouvements
var last_direction: String = "down"

func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * speed

	if input_vector != Vector2.ZERO:
		move_and_slide()
		update_animation(input_vector)
	else:
		play_idle_animation()

# Animations de marche
func update_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			airship_sprite.play("walk_right")
			last_direction = "right"
		else:
			airship_sprite.play("walk_left")
			last_direction = "left"
	else:
		if direction.y > 0:
			airship_sprite.play("walk_down")
			last_direction = "down"
		else:
			airship_sprite.play("walk_up")
			last_direction = "up"

func play_idle_animation() -> void:
	airship_sprite.play("idle_" + last_direction)
