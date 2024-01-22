extends RigidBody2D

class_name weapon

var pickup = false
var player
var typepath = ""

var weaponsprite = ""
var bulletsprite = ""
signal equipweapon(skin, bulletskin)

func _ready():
	connect("equipweapon", equip_weapon)
	
func _physics_process(delta):
	if Input.is_action_pressed("interact") and pickup:
		set_weapon()
		#equipweapon.emit(weaponsprite, bulletsprite)
		equip_weapon()
		queue_free()

func set_weapon():
	pass
	
func equip_weapon():
	#print("weapon equipping")
	#player.get_node("weapon_sprite").texture = load(weaponsprite)
	player.equip_weapon(weaponsprite, bulletsprite)
	pass
	
	
func _on_area_2d_area_entered(area):
	print(area.name)
	if area.name == "pig_hitbox":
		player = area.get_parent()
		pickup = true
		
	
	



func _on_area_2d_area_exited(area):
	if area.name == "pig_hitbox":
		pickup = false
