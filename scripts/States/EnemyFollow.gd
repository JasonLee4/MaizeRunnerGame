extends State
class_name EnemyFollow

var pig : CharacterBody2D

@export var enemy: CharacterBody2D
@export var move_speed := 100

var move_direction : Vector2
	
func enter():
	print("enemy following")
	pig = get_tree().get_current_scene().get_node("Pig")
	assert(pig != null)

func update(delta: float):
	if "detectionRadius" in enemy and enemy.global_position.distance_to(pig.global_position) > enemy.detectionRadius:
		transitioned.emit(self, "EnemyIdle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta: float):
	var direction = pig.global_position - enemy.global_position
	enemy.velocity = Vector2(direction.normalized() * move_speed)
	enemy.move_and_slide()
