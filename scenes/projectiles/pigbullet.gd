extends Area2D



@export var speed = 100
@export var damage = 20
var direction = Vector2.LEFT
signal pigbullethit
	
#func _ready():
	#$SelfdestructTimer.start()
	
	
#
func _process(delta):
	translate(direction*speed*delta)
		
func pigbullet():
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.name != "player":
		if body.has_method("enemy"):
			body.take_damage(damage)
		queue_free()
	
