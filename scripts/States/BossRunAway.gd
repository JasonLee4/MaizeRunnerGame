extends State
class_name BossRunAway

@onready var pig = Globals.pig

@export var boss : boss
@export var speed : float
@export var cam_follow_time : float
@export var windup_time : float
@onready var running = false
@onready var finishing = false
var time : float

@export var drop_scene : Resource

func enter():
	#freeze everything but the boss
	boss.get_node("boss_music").stop()
	boss.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	boss.get_node("CollisionShape2D").disabled = true
	#fix camera to the boss instead of pig
	$CameraTransition.transition(pig.get_node("Camera2D"), boss.get_node("BossCam"))
	#drop key
	var drop = drop_scene.instantiate()
	boss.get_parent().add_child(drop)
	drop.global_position = boss.global_position
	time = 0
	
func update(delta):
	if !running:
		if time < windup_time:
			time += delta
			boss.get_node("AnimationPlayer").play("windup")
		elif time >= windup_time:
			boss.get_node("AnimationPlayer").stop()
			time = 0
			running = true
	else:
		if time < cam_follow_time:
			time += delta
			boss.velocity = Vector2(Vector2(1,0) * speed)
			boss.move_and_slide()
		elif time >= cam_follow_time and !finishing:
			finishing = true
			boss.velocity = Vector2(Vector2(1,0) * speed)
			boss.move_and_slide()
			$CameraTransition.transition(boss.get_node("BossCam"), pig.get_node("Camera2D"), 0.5)
			await $CameraTransition.done
			get_tree().paused = false
	
	
