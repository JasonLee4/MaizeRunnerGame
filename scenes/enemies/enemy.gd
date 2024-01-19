extends CharacterBody2D
class_name enemy

@export var speed = 100

var MAX_HEALTH = 100
var health = MAX_HEALTH
var damage = 1

var can_attack = true
var can_attack_player = true
var player

var invulnerable = false

func _physics_process(delta):
	move()
	if player != null:
		deal_damage()

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	$Healthbar.max_value = MAX_HEALTH
	set_health()

func set_health():
	$Healthbar.value = health
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		body.enemies_pig_can_attack.append(self)
		#player_in_hitbox = true
		player = body

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		body.enemies_pig_can_attack.erase(self)
		#player_in_hitbox = false
		player = null
 
func move():
	pass

func deal_damage():
	if can_attack_player and can_attack:
		can_attack = false
		$attack_cooldown.start()
		player.recieve_damage(damage)
	pass

func recieve_damage(damage_value):
	if not invulnerable:
		health = health - damage_value
		set_health()
		invulnerable = true
		$dmg_iframe_cooldown.start()
		print("Slime health = ", health)
		if health <= 0:
			self.queue_free() 

func _on_pig_damage_cooldown_timeout():
	invulnerable = false

func _on_attack_cooldown_timeout():
	can_attack = true
