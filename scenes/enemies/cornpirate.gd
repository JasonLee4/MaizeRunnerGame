extends enemy
@onready var pigbullet_node = get_parent().get
var cornbullet_scene = preload("res://scenes/projectiles/cornbullet.tscn")
var enemy_attack_cooldown = true

var player_inrange = false
var can_take_damage = true
var damaged = false

@onready var pig = get_parent().get_node("Pig")
var pig_position
var target_position

func _process(delta):
	deal_with_damage()
	
func _ready():
	$Healthbar.max_value = MAX_HEALTH
	set_health()
	
func enemy():
	pass

func set_health():
	$Healthbar.value = health
	
func deal_with_damage():
	if damaged and can_take_damage == true:
		health = health - 20
		set_health()
		can_take_damage = false
		$dmg_cooldown.start()
		
		print("cornpirate health = ", health)
		if health <= 0:
			self.queue_free()
	damaged = false 


func _on_range_body_entered(body):
	if body.has_method("player"):
		player_inrange = true
		player = body
		print("enter range")
		
		$ShootTimer.start()


func _on_range_body_exited(body):
	if body.has_method("player"):
		player_inrange = false
		player = null
		print("exit range")



func _on_shoot_timer_timeout():
	if player_inrange and player != null:
		var b = cornbullet_scene.instantiate()
		get_tree().root.add_child(b)
		b.global_position = global_position
		var dir = (pig.global_position - global_position).normalized()
		print("shooting corn bullet")
		b.global_rotation = dir.angle() + PI / 2.0
		b.direction = dir

	$ShootTimer.start()

func _on_dmg_cooldown_timeout():
	can_take_damage = true




func _on_hitbox_area_entered(area):
	if area.has_method("pigbullet"):
		damaged = true
		
		area.queue_free()
