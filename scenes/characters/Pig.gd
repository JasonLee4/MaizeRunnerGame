extends CharacterBody2D

#Dash variable
var dashDirection = Vector2(1,0)

@export var speed = 400
func get_input():
	var input_direction = Input.get_vector("left","right" , "up", "down")
	velocity = input_direction * speed
	dash(input_direction)
	
func _physics_process(delta):
	get_input()
	move_and_slide()

func dash(dashDirection) :
	if Input.is_action_pressed("space"):
		velocity = dashDirection.normalized()*2000
