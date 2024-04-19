extends State
class_name EnemyFreeze

@export var enemy: CharacterBody2D
@onready var pig = Globals.pig

# Called when the node enters the scene tree for the first time.
func enter():
	if enemy.get_node("AnimationPlayer").current_animation == "thrown":
		print("setting animation to walk side")
		enemy.get_node("AnimationPlayer").play("walk_side")
		flip()
	enemy.get_node("AnimationPlayer").stop()
	enemy.speed = 0
	
func update(delta):
	enemy.get_node("AnimationPlayer").stop()
	if enemy.health <=0:
		transitioned.emit(self, "EnemyDead")
	
func exit():
		enemy.get_node("AnimationPlayer").play()
		
func flip(): 
	if pig.global_position.x > enemy.global_position.x:
		enemy.get_node("Base").flip_h = false
	elif pig.global_position.x < enemy.global_position.x:
		enemy.get_node("Base").flip_h = true
