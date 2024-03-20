extends Node2D

var ui_scene = preload("res://scenes/ui/ui.tscn")
var player_scene = preload("res://scenes/characters/pig.tscn")
var boss_enemy = preload("res://scenes/bosses/boss.tscn")
var laser_res = preload("res://scenes/items/laser_resource.tscn")
var ui

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.restart_game()
	
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
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var lr = laser_res.instantiate()

	lr.global_position.x = randf_range(59, 480)
	lr.global_position.y = randf_range(42, 296)
	
	add_child(lr)
	print($Boss.get_child(1).health)
