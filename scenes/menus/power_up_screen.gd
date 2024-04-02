extends Control

@export var powerUpArr : Array[Resource] = []

var powerUp1
var powerUp2
var powerUp3

# Called when the node enters the scene tree for the first time.
func _ready():
	$Yay.play()
	$Sign.text = "Level " + str(Globals.cur_lvl) + " Complete"
	$VBoxContainer/HBoxContainer/VBoxContainer/Power1.grab_focus()
	
	randomize_powerups()
	set_icons()
	set_power_text()
	set_power_alt_desc()
	
	
	
	$AnimatedSprite2D.play()
	$VBoxContainer/HBoxContainer2/Sprite2D.material.set_shader_parameter("shine_speed", 0)
	$VBoxContainer/HBoxContainer2/Sprite2D2.material.set_shader_parameter("shine_speed", 0)
	$VBoxContainer/HBoxContainer2/Sprite2D3.material.set_shader_parameter("shine_speed", 0)
	
func randomize_powerups():
	print(powerUpArr.size())	
	var power_idx1 = randi_range(0, powerUpArr.size()-1)
	print(power_idx1)
	powerUp1 = powerUpArr[power_idx1]
	powerUpArr.remove_at(power_idx1)
	print(powerUpArr.size())
	
	var power_idx2 = randi_range(0, powerUpArr.size()-1)
	print(power_idx2)	
	powerUp2 = powerUpArr[power_idx2]
	powerUpArr.remove_at(power_idx2)
	print(powerUpArr.size())
	
	var power_idx3 = randi_range(0, powerUpArr.size()-1)
	print(power_idx3)
	powerUp3 = powerUpArr[power_idx3]
	powerUpArr.remove_at(power_idx3)
	print(powerUpArr.size())

func set_icons():
	$VBoxContainer/HBoxContainer2/Sprite2D.frame = powerUp1.frameIdx
	$VBoxContainer/HBoxContainer2/Sprite2D2.frame = powerUp2.frameIdx
	$VBoxContainer/HBoxContainer2/Sprite2D3.frame = powerUp3.frameIdx
	
	
	pass


func set_power_text():
	$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text = powerUp1.name
	$VBoxContainer/HBoxContainer/VBoxContainer/Power1.text = powerUp1.desc
	$VBoxContainer/HBoxContainer/VBoxContainer2/Label2.text = powerUp2.name
	$VBoxContainer/HBoxContainer/VBoxContainer2/Power2.text = powerUp2.desc
	$VBoxContainer/HBoxContainer/VBoxContainer3/Label3.text = powerUp3.name
	$VBoxContainer/HBoxContainer/VBoxContainer3/Power3.text = powerUp3.desc

func set_power_alt_desc():
	if powerUp1.name == "Scavenge":
		var power1_script = load(powerUp1.effectScript)
		var power1 = power1_script.new()
		
		$VBoxContainer/HBoxContainer/VBoxContainer/Power1.text = "+2 " + power1.get_item_name()
	if powerUp2.name == "Scavenge":
		var power2_script = load(powerUp2.effectScript)
		var power2 = power2_script.new()
		
		$VBoxContainer/HBoxContainer/VBoxContainer2/Power2.text = "+2 " + power2.get_item_name()
	if powerUp3.name == "Scavenge":
		var power3_script = load(powerUp3.effectScript)
		var power3 = power3_script.new()
		
		$VBoxContainer/HBoxContainer/VBoxContainer3/Power3.text = "+2 " + power3.get_item_name()


func next_level():
	Globals.go_next_lvl()
	if Globals.cur_lvl in [5, 10]:
		get_tree().change_scene_to_file("res://scenes/levels/boss_level.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/dungeon_gen/dungeon_gen.tscn")


func _on_get_power_1_pressed():
	$Button.play()
	await $Button.finished
	#Globals.max_health = Globals.max_health+1
	#Globals.health = Globals.health+1
	var power1_script = load(powerUp1.effectScript)
	var power1 = power1_script.new()
	power1.power_up()	
	
	next_level()

func _on_get_power_1_mouse_entered():
	$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text = "[shake rate=15 level=15]"+$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text+"[/shake]"
	$VBoxContainer/HBoxContainer2/Sprite2D.material.set_shader_parameter("shine_speed", 1.5)
	
func _on_get_power_1_mouse_exited():
	$VBoxContainer/HBoxContainer/VBoxContainer/Label1.text = powerUp1.name
	$VBoxContainer/HBoxContainer2/Sprite2D.material.set_shader_parameter("shine_speed", 0)
	
func _on_icon_button_1_pressed():
	_on_get_power_1_pressed()

func _on_icon_button_1_mouse_entered():
	_on_get_power_1_mouse_entered()
	
func _on_icon_button_1_mouse_exited():
	_on_get_power_1_mouse_exited()
	


func _on_get_power_2_pressed():
	$Button.play()
	await $Button.finished
	# increase pig speed by 10 percent
	#Globals.increase_pig_speed(.1)
	var power2_script = load(powerUp2.effectScript)
	var power2 = power2_script.new()
	power2.power_up()	
	next_level()

func _on_get_power_2_mouse_entered():
	$VBoxContainer/HBoxContainer/VBoxContainer2/Label2.text = "[shake rate=15 level=15]"+$VBoxContainer/HBoxContainer/VBoxContainer2/Label2.text+"[/shake]"
	$VBoxContainer/HBoxContainer2/Sprite2D2.material.set_shader_parameter("shine_speed", 1.5)

func _on_get_power_2_mouse_exited():
	$VBoxContainer/HBoxContainer/VBoxContainer2/Label2.text = powerUp2.name
	$VBoxContainer/HBoxContainer2/Sprite2D2.material.set_shader_parameter("shine_speed", 0)
	
func _on_icon_button_2_pressed():
	_on_get_power_2_pressed()

func _on_icon_button_2_mouse_entered():
	_on_get_power_2_mouse_entered()
	
func _on_icon_button_2_mouse_exited():
	_on_get_power_2_mouse_exited()
	


func _on_get_power_3_pressed():
	$Button.play()
	await $Button.finished
	#Globals.inv.insert(item)
	#Globals.inv.insert(item)
	var power3_script = load(powerUp3.effectScript)
	var power3 = power3_script.new()
	power3.power_up()	
	next_level()
	
func _on_get_power_3_mouse_entered():
	$VBoxContainer/HBoxContainer/VBoxContainer3/Label3.text = "[shake rate=15 level=15]"+$VBoxContainer/HBoxContainer/VBoxContainer3/Label3.text+"[/shake]"
	$VBoxContainer/HBoxContainer2/Sprite2D3.material.set_shader_parameter("shine_speed", 1.5)
	

func _on_get_power_3_mouse_exited():
	$VBoxContainer/HBoxContainer/VBoxContainer3/Label3.text = powerUp3.name
	$VBoxContainer/HBoxContainer2/Sprite2D3.material.set_shader_parameter("shine_speed", 0)
	
func _on_icon_button_3_pressed():
	_on_get_power_3_pressed()

func _on_icon_button_3_mouse_entered():
	_on_get_power_3_mouse_entered()
	
func _on_icon_button_3_mouse_exited():
	_on_get_power_3_mouse_exited()








