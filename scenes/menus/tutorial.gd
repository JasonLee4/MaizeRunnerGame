extends Control

@onready var tut1 = $"1"
@onready var tut2 = $"2"
@onready var tut3 = $"3"
var tutorial: Array
var i = 0

func _ready():
	tutorial = [tut1, tut2, tut3]
	tut2.visible = false
	tut3.visible = false

func _input(event):
	if event.is_action_pressed("space"):
		if i == 2:
			get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
			return
		i += 1
		tutorial[i].visible = true
		
		
