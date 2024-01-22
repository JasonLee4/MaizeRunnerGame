extends Area2D

var player = preload("res://scenes/characters/pig.tscn")
@export var speed = 180
var direction = Vector2.DOWN

func start(target_dir):
	target_dir = target_dir

	
#func _ready():
	#$SelfdestructTimer.start()
	
	
#
func _process(delta):
		translate(direction*speed*delta)
		


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	# stop cornbullet from freeing if touching pirate 
	if body.name != "cornpirate":
		if body.has_method("player"):
			#Globals.health -= 1
			print(body.name)
			body.receive_damage(1)
		queue_free()
	

