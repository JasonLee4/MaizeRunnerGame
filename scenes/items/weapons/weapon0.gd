extends RigidBody2D

class_name weapon

var pickup = false
var player
var weaponsprite = ""

func _physics_process(delta):
	if Input.is_action_pressed("interact") and pickup:
		set_weapon()
		equip_weapon()
		queue_free()

func set_weapon():
	pass
func equip_weapon():
	player.get_node("weapon_sprite").texture = load(weaponsprite)

func _on_area_2d_area_entered(area):
	print(area.name)
	if area.name == "pig_hitbox":
		player = area.get_parent()
		pickup = true	
	
	



func _on_area_2d_area_exited(area):
	if area.name == "pig_hitbox":
		pickup = false
