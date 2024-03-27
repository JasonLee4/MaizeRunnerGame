extends State
class_name BossRunAway

@onready var pig = Globals.pig

@export var boss : boss
@export var speed : float
@export var cam_follow_time : float
var time : float

@export var drop_scene : Resource

func enter():
	#fix camera to the boss instead of pig
	boss.get_node("RunAwayCam").make_current()
	#drop key
	var drop = drop_scene.instantiate()
	boss.get_parent().add_child(drop)
	drop.global_position = boss.global_position
	#play run-away animation
	run_away()
	
func run_away():
	boss.get_node("AnimationPlayer").play("windup")
	await get_tree().create_timer(5.0).timeout
	boss.get_node("AnimationPlayer").stop()
	time = 0	
	
func update(delta):
	if time < cam_follow_time:
		time += delta
		boss.velocity = Vector2(Vector2(1,0) * speed)
		boss.move_and_slide()
	elif time >= cam_follow_time:
		pig.get_node("Camera2D").make_current()
		boss.queue_free()	
	
	
