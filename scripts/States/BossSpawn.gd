extends State
class_name BossSpawn

@onready var pig = Globals.pig

@export var boss : boss

func enter():
	#freeze everything but the boss
	boss.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	#fix camera to the boss instead of pig
	$CameraTransition.transition(pig.get_node("Camera2D"), boss.get_node("BossCam"))
	await $CameraTransition.done
	boss.get_node("spawn_roar").play()

func _on_spawn_roar_finished():
	$CameraTransition.transition(boss.get_node("BossCam"), pig.get_node("Camera2D"), 0.5)
	await $CameraTransition.done
	get_tree().paused = false
	boss.get_node("boss_music").play()
	transitioned.emit(self, "BossDashAndStomp")
	boss.process_mode = Node.PROCESS_MODE_INHERIT
	boss.get_node("growl").play_rand_sound()
