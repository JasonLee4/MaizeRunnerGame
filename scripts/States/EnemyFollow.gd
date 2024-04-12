extends State
class_name EnemyFollow

@onready var pig = 	Globals.pig

@export var enemy: enemy
@export var move_speed := 100

#var move_direction : Vector2
	
func enter():
	#print("enemy following")
	#pig = get_tree().get_current_scene().get_node("Pig")
	assert(pig != null)

func update(delta: float):
	if enemy.health <=0:
		transitioned.emit(self, "EnemyDead")
	elif enemy.can_attack and enemy.can_attack_player:
		print("follow -> attack")
		transitioned.emit(self, "EnemyAttack")
	elif "detection_radius" in enemy and enemy.global_position.distance_to(pig.global_position) > enemy.detection_radius:
		transitioned.emit(self, "EnemyIdle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta: float):
	var direction = pig.global_position - enemy.global_position
	enemy.velocity = Vector2(direction.normalized() * move_speed)
	enemy.move_and_slide()
	
	walk_animation()

func walk_animation():
	var walk_ratio = abs(enemy.velocity.x/enemy.velocity.y)
	var player = enemy.get_node("AnimationPlayer")
	var base = enemy.get_node("Base")
	if walk_ratio >= 1 and player.get_animation("walk_side") != null:
		if enemy.velocity.x > 0 :
			base.flip_h = false
		else:
			base.flip_h = true
		player.play("walk_side")
	elif 0 < walk_ratio and walk_ratio < 1:	
		if enemy.velocity.y > 0 and player.get_animation("walk_down") != null:
			player.play("walk_down")
		elif enemy.velocity.y < 0 and player.get_animation("walk_up") != null:
			player.play("walk_up")
	
	#Idle animation for rats
	if ((enemy.get_class() == "rat" or enemy.get_class() == "albinorat") and 
		enemy.velocity.x == 0 and enemy.velocity.y == 0):
		player.play("tail_wag")
