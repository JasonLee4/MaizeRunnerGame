extends State
class_name BossDash

@export var totalTime = 15
var time : float

@onready var pig = 	Globals.pig
@export var max_speed : float
@export var accelaration : float
var direction : Vector2
var speed : float

@export var enemy: enemy
@export var totalWindupTime = 3
var windupTime : float

# Called when the node enters the scene tree for the first time.
func enter():
	print("dashing")
	windupTime = 0
	direction = Vector2(-1,-1)

func dashing(delta):
	enemy.velocity = Vector2(direction.normalized() * speed)
	enemy.move_and_slide()

	if enemy.can_attack and enemy.can_attack_player:
		enemy.deal_damage()

	speed = maxf(enemy.velocity.length() - (accelaration*delta), 0)
	if speed <= 0:
		direction = Vector2(-1,-1)
		windupTime = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if windupTime < totalWindupTime:
		enemy.get_node("AnimationPlayer").play("windup")
		windupTime += delta
		time += delta
	elif time < totalTime:
		enemy.get_node("AnimationPlayer").stop()
		if direction == Vector2(-1,-1):
			direction = pig.global_position - enemy.global_position
			speed = max_speed
		dashing(delta)
		time += delta
	else:
		enemy.get_node("AnimationPlayer").stop()
		transitioned.emit(self, "BossFollow")
		
	
	
	
