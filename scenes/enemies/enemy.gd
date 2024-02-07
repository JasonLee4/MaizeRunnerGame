extends CharacterBody2D
class_name enemy

@export var speed = 100
#@export var freeze = false
@export var MAX_HEALTH = 100
var health = MAX_HEALTH
@export var damage = 1

var can_attack = true
var can_attack_player = false
@export var ranged = false
@onready var player = Globals.pig

var invulnerable = false

func _physics_process(delta):
	choose_animation()
	#pass
	#move()
	#if player != null:
		#deal_damage(ranged)

func choose_animation():
	var animationNames = $AnimatedSprite2D.sprite_frames.get_animation_names()
	var walkRatio = abs(velocity.x/velocity.y)
	if walkRatio >= 1 and "walk_side" in animationNames:
		if velocity.x > 0 :
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
		#print("playing walk side")
		$AnimatedSprite2D.play("walk_side")
	elif 0 < walkRatio and walkRatio < 1:	
		if velocity.y > 0 and "walk_down" in animationNames:
			$AnimatedSprite2D.play("walk_down")
		elif velocity.y < 0 and "walk_up" in animationNames:
			#print("up")
			$AnimatedSprite2D.play("walk_up")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health()

func set_health():
	$Healthbar.max_value = MAX_HEALTH	
	$Healthbar.value = health
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func enemy():
	pass

#func _on_enemy_hitbox_body_entered(body):
	#if body.has_method("player"):
		##body.enemies_pig_can_attack.append(self)
		##player_in_hitbox = true
		#player = body
#
#func _on_enemy_hitbox_body_exited(body):
	#if body.has_method("player"):
		##body.enemies_pig_can_attack.erase(self)
		##player_in_hitbox = false
		#player = null
 
func move():
	pass

func deal_damage():
	#if can_attack_player and can_attack:
		can_attack = false
		$attack_cooldown.start()
		if not ranged and player:
			print(damage)
			player.receive_damage(damage)
	

func take_damage(damage_value):
	#print("damaged hit")
	#if not invulnerable:
	$AnimatedSprite2D.modulate = Color(2,2,2,2)
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	
	health = health - damage_value
	set_health()
		#invulnerable = true
		#$dmg_iframe_cooldown.start()
	#print("Slime health = ", health)
	if health <= 0:
		self.queue_free() 

func _on_attack_cooldown_timeout():
	can_attack = true

func _on_dmg_iframe_cooldown_timeout():
	invulnerable = false
	
func _on_enemy_hitbox_area_entered(area):
	if area.has_method("pigbullet"):
		take_damage(area.damage)
		area.queue_free()
