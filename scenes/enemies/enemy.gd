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

var poison_duration = 5

func _physics_process(delta):
	special_animation()
	process_sound()

func special_animation():
	pass

func process_sound():
	pass

func set_health():
	$Healthbar.max_value = MAX_HEALTH	
	$Healthbar.value = health
	
func enemy():
	pass

func deal_damage():
	#if can_attack_player and can_attack:
		can_attack = false
		$attack_cooldown.start()
		if not ranged and player:
			#print(damage)
			player.receive_damage(damage)	

func take_damage(damage_value):
	$Base.modulate = Color(2,2,2,2)
	await get_tree().create_timer(0.1).timeout
	$Base.modulate = Color.WHITE
	
	health = health - damage_value
	set_health()

func _on_attack_cooldown_timeout():
	can_attack = true

func _on_dmg_iframe_cooldown_timeout():
	invulnerable = false
	
func _on_enemy_hitbox_area_entered(area):
	if area.has_method("pigbullet"):
		take_damage(area.damage)
		area.queue_free()
		
func take_poison():
	print("TAKING POISON IN ENEMY")
	
	while (poison_duration > 0):	
		print("Taking POISON OWWWWW")
		poison_duration -= 1
		take_damage(20)
		$Poison/poison_particles.visible = true
		$Poison/poison_particles.emitting = true
			
		await get_tree().create_timer(1.0).timeout
		$Poison/poison_particles.visible = false
		
	if poison_duration == 0:
		poison_duration = 5




