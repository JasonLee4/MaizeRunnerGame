extends Control


var powerUp1 = ResourceLoader.load("res://scenes/menus/power_ups/get_laser.tres")

func _ready():
	$Yay.play()
	$Sign.text = "Level " + str(Globals.cur_lvl) + " Complete"
	$VBoxContainer/HBoxContainer/VBoxContainer/Power1.grab_focus()
	set_power_text()
	
func next_level():
	Globals.go_next_lvl()
	if Globals.cur_lvl in [5, 10]:
		get_tree().change_scene_to_file("res://scenes/levels/boss_level.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")

func set_power_text():
	$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text = powerUp1.name
	$VBoxContainer/HBoxContainer/VBoxContainer/Power1.text = powerUp1.desc

func _on_get_power_1_pressed():
	$Button.play()
	await $Button.finished
	
	if powerUp1.onetime and !Globals.onetime_power.has(powerUp1.fname):
		Globals.onetime_power.append(powerUp1.fname)
	next_level()

func _on_get_power_1_mouse_entered():
	$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text = "[shake rate=15 level=15]"+$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text+"[/shake]"
	$VBoxContainer/HBoxContainer/VBoxContainer/Control/Sprite2D.material.set_shader_parameter("shine_speed", 1.5)
	
func _on_get_power_1_mouse_exited():
	$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text = powerUp1.name
	$VBoxContainer/HBoxContainer/VBoxContainer/Control/Sprite2D.material.set_shader_parameter("shine_speed", 0)
	
func _on_icon_button_1_pressed():
	_on_get_power_1_pressed()

func _on_icon_button_1_mouse_entered():
	_on_get_power_1_mouse_entered()
	
func _on_icon_button_1_mouse_exited():
	_on_get_power_1_mouse_exited()
	
