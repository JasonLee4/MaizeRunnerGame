extends State
class_name BossDashAndStomp

@export var totalCycles = 5
var cycles : float

@onready var pig = 	Globals.pig
@export var enemy: enemy

@export var dash_windup = 3.0
@export var dash_speed = 400.0
@export var dash_acc =  300.0
@export var total_dashes = 1

@export var jump_windup = 0.25
@export var jump_speed = 200.0
@export var jump_acc = 800.0
@export var total_stomps = 3

@export var stompRadius = 100

var direction : Vector2
var speed : float
var windup_time : float

var stomps: int
var dashes : int
var dashing : bool
var stomping : bool

func enter():
	cycles = 0
	dashing = true
	stomping = false
	
func switch_dash_and_stomp():	
	dashing = !dashing
	stomping = !stomping
	
func dash(delta):
	enemy.velocity = Vector2(direction.normalized() * speed)
	enemy.move_and_slide()

	if enemy.can_attack and enemy.can_attack_player:
		enemy.deal_damage()

	speed = maxf(enemy.velocity.length() - (dash_acc*delta), 0)
	if speed <= 20:
		direction = Vector2(-1,-1)
		windup_time = 0
		dashes += 1
		
func jump(delta):
	enemy.velocity = Vector2(0, -speed)
	enemy.move_and_slide()

	if enemy.can_attack and enemy.can_attack_player:
		enemy.deal_damage()

	speed = speed - (jump_acc*delta)
	if speed <= -jump_speed:
		stomp()
		windup_time = 0
		speed = 0
	
func stomp():
	if(abs((pig.global_position - enemy.global_position).length()) <= stompRadius):
		enemy.deal_damage()
	stomps += 1
		
func update(delta):
	if enemy.health <= 0:
		transitioned.emit(self, "BossRunAway")
	
	if(dashes == total_dashes):
		dashes = 0
		switch_dash_and_stomp()
	if(stomps == total_stomps):
		stomps = 0
		cycles += 1
		print("Cycles: "+str(cycles))
		switch_dash_and_stomp()
	
	if dashing:
		if windup_time < dash_windup:
			enemy.get_node("AnimationPlayer").play("windup")
			windup_time += delta
		else:
			enemy.get_node("AnimationPlayer").stop()
			if direction == Vector2(-1,-1):
				direction = pig.global_position - enemy.global_position
				speed = dash_speed
			dash(delta)
	elif stomping:
		if windup_time < jump_windup:
			enemy.get_node("AnimationPlayer").play("windup")
			windup_time += delta
		else:
			enemy.get_node("AnimationPlayer").stop()
			if speed == 0:
				speed = jump_speed
			jump(delta)
	if cycles == totalCycles:
		enemy.get_node("AnimationPlayer").stop()
		transitioned.emit(self, "BossSpawnMinions")
