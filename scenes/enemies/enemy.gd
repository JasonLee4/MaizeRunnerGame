extends CharacterBody2D

@export var speed = 100
var pig_position
var target_position
@onready var pig = get_parent().get_node("Pig")

func _physics_process(delta):
	pig_position = pig.global_position
	target_position = (pig_position-position).normalized()
	
	if (position.distance_to(pig_position) > 3):
		velocity = Vector2(target_position * speed) 
		move_and_slide()
		look_at(pig_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
