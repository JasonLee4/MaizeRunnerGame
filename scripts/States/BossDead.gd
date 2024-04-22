extends State
class_name BossDead

@onready var pig = Globals.pig

@export var boss : boss
@export var windup_time : float
@onready var dying = false
var time : float

@export var drop_scene : Resource

func enter():
	#connect signals
	$CameraTransition.done.connect(cam_trans_finished)
	boss.get_node("AnimationPlayer").animation_finished.connect(animation_finished)
	#freeze everything but the boss
	boss.get_node("boss_music").stop()
	boss.get_node("spin").stop()
	boss.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.get_node("UI/BossHealthBar").hide()
	get_tree().paused = true
	boss.get_node("CollisionShape2D").disabled = true
	#fix camera to the boss instead of pig
	$CameraTransition.transition(pig.get_node("Camera2D"), boss.get_node("BossCam"))
	boss.get_node("roar").play_rand_sound()
	boss.get_node("death_screech").play()
	time = 0
	
func update(delta):
	if !dying:
		if time < windup_time:
			time += delta
			boss.get_node("AnimationPlayer").play("windup")
		elif time >= windup_time:
			time = 0
			dying = true
	elif boss.get_node("AnimationPlayer").current_animation == "windup":
		boss.get_node("AnimationPlayer").play("death")
			
	
func animation_finished(anim_name):
	if anim_name == "death":
		#drop key
		var drop = drop_scene.instantiate()
		boss.get_parent().add_child(drop)
		drop.global_position = boss.global_position
		#transition camera
		$CameraTransition.transition(boss.get_node("BossCam"), pig.get_node("Camera2D"))
		
func cam_trans_finished():
	if dying:
		get_tree().paused = false
	
