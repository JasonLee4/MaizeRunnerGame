extends State
class_name EnemyFollow

@onready var pig = 	Globals.pig

@export var enemy: enemy
@export var move_speed := 100

var move_direction : Vector2
	
func enter():
	#print("enemy following")
	#pig = get_tree().get_current_scene().get_node("Pig")
	assert(pig != null)

func update(delta: float):
	if enemy.health <=0:
		transitioned.emit(self, "EnemyDead")
	elif enemy.can_attack and enemy.can_attack_player:
		print("follow -> attack")
		transitioned.emit(self, "EnemyAttack")
	elif "detection_radius" in enemy and enemy.global_position.distance_to(pig.global_position) > enemy.detection_radius:
		transitioned.emit(self, "EnemyIdle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(delta: float):
	var direction = pig.global_position - enemy.global_position
	enemy.velocity = Vector2(direction.normalized() * move_speed)
	enemy.move_and_slide()
