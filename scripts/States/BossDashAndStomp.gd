extends State
class_name BossDashAndStomp

@export var totalCycles = 5
var cycles : float

@onready var pig = 	Globals.pig
@export var enemy: enemy
var animation

@export var dash_windup = 3.0
@export var dash_speed = 400.0
@export var dash_acc =  300.0
@export var total_dashes = 1

@export var jump_windup = 0.25
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
	dashes = 0
	stomps = 0
	windup_time = 0
	dashing = true
	stomping = false
	
	direction == Vector2(-1,-1)
	
	animation = enemy.get_node("AnimationPlayer")
	animation.animation_finished.connect(animation_finished)
	
func switch_dash_and_stomp():	
	dashing = !dashing
	stomping = !stomping

func dash(delta):
	enemy.velocity = Vector2(direction.normalized() * speed)
	enemy.move_and_slide()

	speed = maxf(enemy.velocity.length() - (dash_acc*delta), 0)
	if speed <= 20:
		direction = Vector2(-1,-1)
		windup_time = 0
		dashes += 1
	
func stomp():
	enemy.get_node("stomp").play()
	Globals.pig.ground_shake.emit()
	if(abs((pig.global_position - enemy.global_position).length()) <= stompRadius):
		enemy.deal_damage()
	enemy.stomp()
	stomps += 1
	windup_time = 0
	
func play_windup(delta):
	animation.play("windup")
	windup_time += delta	

func animation_finished(anim_name):
	if anim_name == "stomp":
		stomp()
	
func update(delta):
	if enemy.health <= 0:
		if Globals.cur_lvl == 5:
			transitioned.emit(self, "BossRunAway")
		elif Globals.cur_lvl == 10:
			transitioned.emit(self, "BossDead")
	
	if enemy.can_attack and enemy.can_attack_player:
		enemy.deal_damage()
	
	if(dashes == total_dashes):
		dashes = 0
		switch_dash_and_stomp()
	if(stomps == total_stomps):
		stomps = 0
		#print("Cycles: "+str(cycles))
		cycles += 1
		switch_dash_and_stomp()
	
	if dashing:
		#Windup
		if windup_time < dash_windup:
			enemy.get_node("growl").play_rand_sound()
			play_windup(delta)
		#Setup for dash
		elif direction == Vector2(-1,-1):
				animation.stop()
				direction = pig.global_position - enemy.global_position
				speed = dash_speed
		#Dash
		else:
			dash(delta)
	elif stomping:
		#Windup
		if windup_time < jump_windup:
			play_windup(delta)
		#Setup animation for stomp
		if animation.current_animation != "stomp":
			#print("playing stomp")
			animation.play("stomp")
			
			
	
	#End phase
	if cycles == totalCycles:
		animation.stop()
		enemy.get_node("roar").play_rand_sound()
		transitioned.emit(self, "BossSpawnMinions")
