extends State
class_name BossFollowing

@export var boss: CharacterBody2D
@export var move_speed := 20
var player : CharacterBody2D

const followingTotalTime = 5
var followingTime : float

func enter():
	followingTime = 0
	player = owner.get_node("Pig")
	assert(player != null)

func update(delta: float):
	if followingTime < followingTotalTime:
		followingTime += delta
	else:
		transitioned.emit(self, "minions")

func physics_update(delta: float):
	var direction = player.global_position - boss.global_position
	boss.velocity = Vector2(direction.normalized() * move_speed)
	boss.move_and_slide()
