extends RigidBody2D

@export var item: Inv_Item
#@export var speed = 100
#@export var damage = 20
#var direction = Vector2.LEFT
	
#func _ready():
	#$SelfdestructTimer.start()
	
	
#
func _physics_process(delta):
	#translate(direction*speed*delta)
	#linear_velocity.x *= 0.9
	#linear_velocity.y *= 0.9
	$AnimatedSprite2D.play()
	var collision_info = move_and_collide(linear_velocity * delta)
	
	if collision_info:
		linear_velocity = linear_velocity.bounce(collision_info.get_normal())
		linear_velocity.x *= 0
		linear_velocity.y *= 0
