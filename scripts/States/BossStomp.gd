extends State
class_name BossStomp

@export var totalStomps = 5
@export var stompRadius = 10
var stomps : float

@onready var pig = 	Globals.pig
@export var initial_jump_speed : float
@export var accelaration : float
var speed : float

@export var enemy: enemy
@export var totalWindupTime = 3
var windupTime : float

# Called when the node enters the scene tree for the first time.
func enter():
	print("stomping")
	windupTime = 0
	speed = 0

func jumping(delta):
	enemy.velocity = Vector2(0, -speed)
	enemy.move_and_slide()

	if enemy.can_attack and enemy.can_attack_player:
		enemy.deal_damage()

	speed = speed - (accelaration*delta)
	if speed <= -initial_jump_speed:
		stomp()
		windupTime = 0
		speed = 0
		
func stomp():
	if(abs((pig.global_position - enemy.global_position).length()) <= stompRadius):
		enemy.deal_damage()
	stomps += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if enemy.health <= 0:
		transitioned.emit(self, "BossDead")
	if windupTime < totalWindupTime:
		enemy.get_node("AnimationPlayer").play("windup")
		windupTime += delta
	elif stomps < totalStomps:
		enemy.get_node("AnimationPlayer").stop()
		if speed == 0:
			speed = initial_jump_speed
		jumping(delta)
	else:
		enemy.get_node("AnimationPlayer").stop()
		transitioned.emit(self, "BossDash")
