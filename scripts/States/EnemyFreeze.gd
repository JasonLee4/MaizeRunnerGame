extends State
class_name EnemyFreeze

@export var enemy: CharacterBody2D


# Called when the node enters the scene tree for the first time.
func enter():
	#print(enemy.get_node("AnimatedSprite2D"))
	enemy.get_node("AnimationPlayer").stop()
	enemy.speed = 0
	
func update(delta):
	enemy.get_node("AnimationPlayer").stop()
	
func exit():
	enemy.get_node("AnimationPlayer").play()
