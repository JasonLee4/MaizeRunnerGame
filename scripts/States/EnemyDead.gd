extends State
class_name EnemyDead

@export var enemy: enemy

@export var despawn_timer : float
var timer

func _ready():
	pass
func enter():
	enemy.speed = 0
	enemy.velocity = Vector2(0,0)
	if enemy.get_node("death") != null:
		enemy.get_node("death").play()
	if enemy.has_method("rat"):
		enemy.get_node("YellowEyes").visible = false
		enemy.get_node("RedEyes").visible = false
	enemy.get_node("CollisionShape2D").disabled = true
	
	enemy.get_node("AnimationPlayer").stop()
	enemy.get_node("AnimationPlayer").play("death")
	
	timer = 0
	
func update(delta):
	if timer < despawn_timer:
		timer += delta
	else:
		enemy.queue_free()
