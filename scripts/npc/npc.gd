extends CharacterBody2D

@export var npc_id : String
@export var npc_name : String

const SPEED = 30
enum State { IDLE, NEW_DIR, MOVE }

var state = State.IDLE
var dir = Vector2.DOWN
var is_roaming = true
var is_chatting = false
var has_quest = true

var speach = [
	"Salut je suis une vielle Bergogne de bas étage sale comme le cul d'un nourrisson", 
	"verge", 
	"princesse mononoke la belle zaccari issue d'une étuve"
	]
var current_sentence = 0
var dialog_box_scene := preload("res://scenes/npc/dialog_box.tscn")
var dialog_box: Node = null

var player_in_chat_zone = false

func _ready():
	randomize()
	$Timer.start()
	$QuestIcon.visible = false
	$Name.text = npc_name

func _physics_process(_delta):  # Note: _physics_process pour move_and_slide
	
	if is_chatting or player_in_chat_zone:
		velocity = Vector2.ZERO
		move_and_collide(velocity)
		play_idle_animation()
		return

	match state:
		State.IDLE:
			velocity = Vector2.ZERO
			play_idle_animation()
		State.NEW_DIR:
			dir = choose_direction()
			state = State.MOVE
		State.MOVE:
			velocity = dir * SPEED
			play_walk_animation()

	move_and_slide()  # Toujours appelé à la fin

func _process(_delta):
	if has_quest and !$QuestIcon.visible:
		$QuestIcon.visible = true
		$QuestIcon/AnimatedSprite2D.play("quest_icon")
	elif !has_quest and $QuestIcon.visible:
		$QuestIcon.visible = false
		$QuestIcon/AnimatedSprite2D.stop()

	# Si on est en train de discuter → on peut fermer la boîte
	if is_chatting:
		if Input.is_action_just_pressed("ui_accept"):
			if dialog_box and dialog_box.handle_input_accept() == false and current_sentence != speach.size() -1 :
				hide_dialogue()
			elif dialog_box and dialog_box.handle_input_accept() == false and current_sentence == speach.size() -1 :
				hide_dialogue()
				return 

	# Si on appuie sur "Entrée" et qu'on est DANS la zone de chat → on lance le dialogue
	if player_in_chat_zone and Input.is_action_just_pressed("ui_accept"):
		is_roaming = false
		is_chatting = true

		var player = $"../Player"  # Corrige le chemin si besoin
		var direction_to_player = (player.global_position - global_position).normalized()

		if abs(direction_to_player.x) > abs(direction_to_player.y):
			dir = Vector2.RIGHT if direction_to_player.x > 0 else Vector2.LEFT
		else:
			dir = Vector2.DOWN if direction_to_player.y > 0 else Vector2.UP

		start_dialogue()

func play_idle_animation():
	match dir:
		Vector2.DOWN: $AnimatedSprite2D.play("idle_down")
		Vector2.UP: $AnimatedSprite2D.play("idle_up")
		Vector2.LEFT: $AnimatedSprite2D.play("idle_left")
		Vector2.RIGHT: $AnimatedSprite2D.play("idle_right")

func play_walk_animation():
	match dir:
		Vector2.DOWN: $AnimatedSprite2D.play("walk_down")
		Vector2.UP: $AnimatedSprite2D.play("walk_up")
		Vector2.LEFT: $AnimatedSprite2D.play("walk_left")
		Vector2.RIGHT: $AnimatedSprite2D.play("walk_right")

func choose_direction() -> Vector2:
	var directions = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
	return directions[randi() % directions.size()]

func _on_timer_timeout():
	if is_roaming and !is_chatting:
		state = State.values()[randi() % State.size()]
		$Timer.wait_time = randf_range(0.5, 1.5)
		$Timer.start()

func _on_chat_detection_area_body_entered(body):
	if body.name == "Player":
		player_in_chat_zone = true
		state = State.IDLE  # On peut stopper la marche, mais PAS chatter encore !

func _on_chat_detection_area_body_exited(body):
	if body.name == "Player":
		player_in_chat_zone = false
		is_chatting = false
		is_roaming = true

func start_dialogue():
	Global.on_cutscene = true
	show_dialog(npc_name + " :", speach[current_sentence])

func show_dialog(npc_name: String, text: String):
	if dialog_box == null:
		dialog_box = dialog_box_scene.instantiate()
		get_tree().get_root().add_child(dialog_box)  # ajoute au root (ou choisis un autre parent)

	dialog_box.show_dialogue(npc_name, text)
	
func hide_dialogue():
	if dialog_box and current_sentence == speach.size() -1 :
		dialog_box.queue_free()
		dialog_box = null
		Global.on_cutscene = false
		is_chatting = false
		is_roaming = true
		current_sentence = 0
	elif dialog_box and current_sentence != speach.size() -1 :
		dialog_box.queue_free()
		dialog_box = null
		Global.on_cutscene = false
		is_chatting = false
		is_roaming = true
		current_sentence += 1
		start_dialogue()
		
