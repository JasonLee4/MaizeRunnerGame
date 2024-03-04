extends Node

@onready var textbox_scene: PackedScene = preload("res://scenes/ui/textbox.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var textbox
var textbox_position: Vector2

var is_dialogue_active = false
var can_advance_line = false

func start_dialogue(position: Vector2, lines: Array[String]):
	if is_dialogue_active:
		return
	
	dialog_lines = lines
	textbox_position = position
	_show_text_box()
	is_dialogue_active = true

func _show_text_box():
	textbox = textbox_scene.instantiate()
	textbox.finished_displaying.connect(_on_textbox_finished_displaying)
	get_tree().root.add_child(textbox)
	textbox.global_position = textbox_position
	textbox.display_text(dialog_lines[current_line_index])
	can_advance_line = false

func _on_textbox_finished_displaying():
	can_advance_line = true
	Globals.tooltip_update.emit("[F] Continue", true)

func _unhandled_input(event):
	if (
		event.is_action_pressed("advance_dialogue") and
		is_dialogue_active and
		can_advance_line
	):
		textbox.queue_free()
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialogue_active = false
			current_line_index = 0
			Globals.tooltip_update.emit("", false)
			return
		_show_text_box()
