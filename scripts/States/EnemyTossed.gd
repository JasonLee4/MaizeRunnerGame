extends State
class_name EnemyTossed

@export var enemy: enemy
@export var move_speed := 100
@export var acceleration := 50
var speed

var direction := Vector2(0,0)
	
func enter():
	print(str(move_speed)+" "+str(acceleration))
	enemy.get_node("thrown").play()
	enemy.get_node("AnimationPlayer").play("thrown")
	enemy.get_node("Base").visible = false
	enemy.get_node("Ball").visible = true
	speed = move_speed
	enemy.velocity = Vector2(direction.normalized() * speed)

func set_values(init_speed, init_acc, init_dir):
	move_speed = init_speed
	acceleration = init_acc
	direction = init_dir

func update(delta: float):
	if enemy.health <=0:
		enemy.reset_animation()
		transitioned.emit(self, "EnemyDead")
	if speed <= 20:
		enemy.reset_animation()
		transitioned.emit(self, "EnemyIdle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta: float):
	enemy.velocity = Vector2(direction.normalized() * speed)
	enemy.move_and_slide()
	speed = speed - acceleration
	
