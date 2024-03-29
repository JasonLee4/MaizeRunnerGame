extends Node2D

var ui_scene = preload("res://scenes/ui/ui.tscn")
var player_scene = preload("res://scenes/characters/pig.tscn")
var boss_enemy = preload("res://scenes/bosses/boss.tscn")
var laser_res = preload("res://scenes/items/laser_resource.tscn")

var ui

@onready var loading_screen = $LoadingScreen
 
# Called when the node enters the scene tree for the first time.
func _ready():
	if not Globals.inv:
		Globals.restart_game()
	
	# loading screen
	loading_screen.set_text(LevelManager.get_loading_screen_text())
	$Objects.visible = false
	
	await(get_tree().create_timer(2).timeout)
	
	loading_screen.visible = false
	$Objects.visible = true
	$CanvasModulate.visible = true
	
	# add ui
	print("Loading UI...")
	ui = ui_scene.instantiate()
	add_child(ui)
	
	# spawn pig
	var player = player_scene.instantiate()
	$Player.add_child(player)
	Globals.pig = player
	player.position = $Player/Marker2D.global_position
	
	var boss = boss_enemy.instantiate()
	$Boss.add_child(boss)
	boss.position = $Boss/Marker2D.global_position
	boss.scale = Vector2(2,2)
	
	ui.get_node("BossHealthbar").init_boss(boss)
	
	Globals.lvl_start.emit()
	
	await(get_tree().create_timer(2).timeout)
	var mono = "Something feels a bit off here..."
	Globals.monologue.emit(mono)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var lr = laser_res.instantiate()

	lr.global_position.x = randf_range($CoalSpawn/Marker2D.global_position.x, $CoalSpawn/Marker2D2.global_position.x)
	lr.global_position.y = randf_range($CoalSpawn/Marker2D.global_position.y, $CoalSpawn/Marker2D2.global_position.y)
	
	add_child(lr)
	print($Boss.get_child(1).health)
