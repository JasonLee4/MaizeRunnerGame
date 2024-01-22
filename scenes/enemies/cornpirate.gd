extends enemy

@onready var pigbullet_node = get_parent().get
var cornbullet_scene = preload("res://scenes/projectiles/cornbullet.tscn")



@onready var pig = get_parent().get_node("Pig")
var pig_position
var target_position

#func _process(delta):
	#deal_with_damage()
	
func _ready():
	ranged = true
	$Healthbar.max_value = MAX_HEALTH
	set_health()
	$AnimatedSprite2D.play("idle")
	
func enemy():
	pass


	
#func deal_with_damage():
	#if damaged and can_take_damage == true:
		#health = health - 20
		#set_health()
		#can_take_damage = false
		#$dmg_cooldown.start()
		#
		#print("cornpirate health = ", health)
		#if health <= 0:
			#self.queue_free()
	#damaged = false 


func _on_range_body_entered(body):
	if body.has_method("player"):
		can_attack_player = true
		player = body
		print("enter range")
		
		#$ShootTimer.start()


func _on_range_body_exited(body):
	if body.has_method("player"):
		can_attack_player = false
		player = null
		print("exit range")



func _on_attack_cooldown_timeout():
	if can_attack_player and player != null:
		var b = cornbullet_scene.instantiate()
		get_tree().root.add_child(b)
		b.global_position = global_position
		var dir = (pig.global_position - global_position).normalized()
		print("shooting corn bullet")
		b.global_rotation = dir.angle() + PI / 2.0
		b.direction = dir
		$attack_cooldown.start()

#func _on_dmg_iframecooldown_timeout():
	#can_take_damage = true

#func _on_hitbox_area_entered(area):
	#if area.has_method("pigbullet"):
		#damaged = true
		#
		#area.queue_free()
