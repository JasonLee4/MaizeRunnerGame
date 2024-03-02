extends Control

@onready var load_save_option = $VBoxContainer/HBoxContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists(Globals.save_file_path+Globals.save_file_name):
		load_save_option.visible = true
		load_save_option.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_quit_button_pressed():
	$Button.play()
	await $Button.finished
	get_tree().quit()


func _on_load_save_1_pressed():
	$Button.play()
	await $Button.finished
	if FileAccess.file_exists(Globals.save_file_path+Globals.save_file_name):
		Globals.new_game = false
		get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
		Globals.restart_game()
	else:
		$TextEdit.visible = true
		await get_tree().create_timer(2.0).timeout
		$TextEdit.visible = false
		

func _on_create_save_pressed():
	$Button.play()
	await $Button.finished
	Globals.new_game = true
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
	Globals.restart_game()
	
	

func _on_back_button_pressed():
	$Button.play()
	await $Button.finished
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")









func _on_load_save_1_mouse_entered():
	$RichTextLabel.text = "[wave amp=90]" + $RichTextLabel.text + "[/wave]"

func _on_load_save_1_mouse_exited():
	$RichTextLabel.text = "Load Save"

func _on_create_save_mouse_entered():
	$RichTextLabel2.text = "[wave amp=90]" + $RichTextLabel2.text + "[/wave]"

func _on_create_save_mouse_exited():
	$RichTextLabel2.text = "New Game"
	
