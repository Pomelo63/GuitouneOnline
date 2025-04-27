extends CanvasLayer

@onready var label_name = $Panel/MarginContainer/VBoxContainer/NpcName
@onready var label_text = $Panel/MarginContainer/VBoxContainer/DialogueText
@onready var text_writer_timer = $TextWriterTimer  # Assure-toi que ce Timer s'appelle bien comme ça dans l’arborescence

var is_active := false
var full_text := ""
var displayed_text := ""
var char_index := 0
var is_typing := false

func _process(_delta):
	if is_typing and Input.is_action_just_pressed("ui_accept"):
		is_typing = false
		label_text.clear()
		label_text.append_text(full_text)
		text_writer_timer.stop()

func show_dialogue(npc_name: String, text: String):
	label_name.text = npc_name
	label_text.clear()
	full_text = text
	displayed_text = ""
	char_index = 0
	is_typing = true
	is_active = true
	text_writer_timer.start()

func hide_dialogue():
	is_active = false
	is_typing = false
	text_writer_timer.stop()

func _on_text_writer_timer_timeout() -> void:
	if is_typing:
		if char_index < full_text.length():
			displayed_text += full_text[char_index]
			label_text.clear()
			label_text.append_text(displayed_text)
			char_index += 1
		else:
			is_typing = false
			text_writer_timer.stop()

func handle_input_accept() -> bool:
	if is_typing:
		return true  # L'entrée a été consommée
	else:
		return false  # Rien n’a été fait
