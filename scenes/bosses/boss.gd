extends enemy
class_name boss

func _ready():
	MAX_HEALTH = 1000
	health = 100
	damage = 0
	
	$Healthbar.max_value = MAX_HEALTH
	set_health()
	
	$growl.play_rand_sound()
	
func boss():
	pass
