extends Control

func _on_main_level_button_pressed():
	get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")
