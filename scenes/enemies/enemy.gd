extends CharacterBody2D

@export var speed = 100

#Variables for enemy movement
var pig_position
var target_position
@onready var pig = get_parent().get_node("Pig")

var health = 100
var player_inattack_zone = false
var player

var can_take_damage = true

func _physics_process(delta):
	deal_with_damage()
	
	if(pig != null):
		pig_position  = pig.global_position
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
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true
		player = body


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
		player = null
 
func deal_with_damage():
	if player_inattack_zone and player.pig_current_attack == true and can_take_damage == true:
		health = health - 20
		can_take_damage = false
		$pig_damage_cooldown.start()
		print("Slime health = ", health)
		if health <= 0:
			self.queue_free() 

func _on_pig_damage_cooldown_timeout():
	can_take_damage = true
