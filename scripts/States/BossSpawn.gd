extends State
class_name BossSpawn

@onready var pig = Globals.pig

@export var boss : boss
@export var start_phase : State

func enter():
	#freeze everything but the boss
	boss.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	
	### turn to invisible ui nodes that shouldn't move in transition
	for n in get_tree().current_scene.get_node("UI").get_node("Hideable").get_children():
		n.visible = false
	
	#fix camera to the boss instead of pig
	$CameraTransition.transition(pig.get_node("Camera2D"), boss.get_node("BossCam"))
	await $CameraTransition.done
	boss.get_node("spawn_roar").play()
	
		
		
func _on_spawn_roar_finished():
	$CameraTransition.transition(boss.get_node("BossCam"), pig.get_node("Camera2D"), 0.5)
	await $CameraTransition.done
	get_tree().paused = false
	boss.get_node("boss_music").play()
	transitioned.emit(self, start_phase.name)
	boss.process_mode = Node.PROCESS_MODE_INHERIT
	
	for n in get_tree().current_scene.get_node("UI").get_node("Hideable").get_children():
		n.visible = true
