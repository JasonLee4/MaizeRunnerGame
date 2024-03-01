extends State
class_name EnemyDead

@export var enemy: enemy

func _ready():
	pass
func enter():
	enemy.speed = 0
	enemy.velocity = Vector2(0,0)
	enemy.get_node("YellowEyes").visible = false
	enemy.get_node("RedEyes").visible = false
	enemy.get_node("CollisionShape2D").disabled = true
	
	enemy.get_node("AnimationPlayer").play("death")
