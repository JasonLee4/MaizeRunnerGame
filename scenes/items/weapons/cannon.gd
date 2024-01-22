extends weapon


# preload the cannon shell
# "shoot" command instantiates shell with direction

func set_weapon():
	weaponsprite = "res://assets/spritesheets/headcannon.png"
	bulletsprite = "res://assets/spritesheets/pigcannonball.png"
	typepath = "res://scenes/items/weapons/cannon.tscn"

#func equip_weapon():
	#var cannoninstance = cannon.instantiate()
	#set_weapon()
	#player.add_child(cannoninstance)
	#equipweapon.emit(weaponsprite, bulletsprite)
	
