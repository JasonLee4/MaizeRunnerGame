extends Node2D

var ui_scene = preload("res://scenes/ui/ui.tscn")
var player_scene = preload("res://scenes/characters/pig.tscn")
var boss_enemy = preload("res://scenes/bosses/boss.tscn")
var laser_res = preload("res://scenes/items/laser_resource.tscn")
var boss_healthbar = preload("res://scenes/items/laser_resource.tscn")

var curr_boss : boss
var boss_spawned : bool

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
	
	Globals.lvl_start.emit()
	
	await(get_tree().create_timer(2).timeout)
	var mono = "Something feels a bit off here..."
	if Globals.cur_lvl != 5:
		mono = "This again? Come back for more, I see."
	Globals.monologue.emit(mono)
	
	boss_spawned = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_instance_valid(Globals.pig) and !boss_spawned):
		#spawns boss once pig enters the room
		if (Globals.pig.global_position.x >= $CoalSpawn/Marker2D2.global_position.x+80):
				curr_boss = boss_enemy.instantiate()
				curr_boss.position = $Boss/Marker2D.global_position
				$Boss.add_child(curr_boss)
				
				ui.get_node("BossHealthbar").init_boss(curr_boss)
				boss_spawned = true


func _on_timer_timeout():
	if(is_instance_valid(curr_boss)):
		if(curr_boss.get_node("State Machine").get_current_state().name != "BossDead"):
			var lr = laser_res.instantiate()

			lr.global_position.x = randf_range($CoalSpawn/Marker2D.global_position.x, $CoalSpawn/Marker2D2.global_position.x)
			lr.global_position.y = randf_range($CoalSpawn/Marker2D.global_position.y, $CoalSpawn/Marker2D2.global_position.y)
			
			$laserResource.add_child(lr)
		#print($Boss.get_child(1).health)
