extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Buttons/VBoxContainer/StartButton.grab_focus()
	$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	#get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
	get_tree().change_scene_to_file("res://scenes/menus/save_data.tscn")
	
	#Globals.restart_game()


func _on_quit_button_pressed():
	get_tree().quit()
