extends enemy

#Variables for enemy movement
var pig_position
var target_position
@onready var pig = Globals.pig
	
func move():
	#if freeze:
		#speed = 0
	assert(pig != null)
	pig_position  = pig.global_position
	target_position = (pig_position-position).normalized()
	
	if pig_position.x < position.x:
		$Sprite2D.flip_v = true
	else:
		$Sprite2D.flip_v = false
		
	
	if (global_position.distance_to(pig_position) > 10):
		velocity = Vector2(target_position * speed) 
		move_and_slide()
		look_at(pig_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	MAX_HEALTH = 50
	health = 50
	damage = 0
	visible = true
	#var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	#$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	$Healthbar.max_value = MAX_HEALTH
	set_health()

#func _on_visible_on_screen_notifier_2d_screen_exited():
	#queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
