extends enemy
class_name boss

func _ready():
	MAX_HEALTH = 1000
	health = 1000
	damage = 1
	
	$Healthbar.max_value = MAX_HEALTH
	set_health()

func _process(_delta):
	if (health < MAX_HEALTH * .75):
		$FireSpawn/Fire1.visible = true
	if (health < MAX_HEALTH * .50):
		$FireSpawn/Fire2.visible = true
	if (health < MAX_HEALTH * .25):
		$FireSpawn/Fire3.visible = true

func boss():
	pass
