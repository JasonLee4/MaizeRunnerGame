extends State
class_name EnemyFreeze

@export var enemy: CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	enemy.speed = 0
