extends enemy
class_name boss

func _ready():
	MAX_HEALTH = 1000
	health = 1000
	damage = 1
	
	$Healthbar.max_value = MAX_HEALTH
	set_health()

func special_animation():
#Eye animation flipping
	if $Base.flip_h == true:
		$RedEyes.flip_h = true
	else:
		$RedEyes.flip_h = false

func _process(_delta):
	if (health < MAX_HEALTH * .75):
		$FireSpawn/Fire1.visible = true
	if (health < MAX_HEALTH * .50):
		$FireSpawn/Fire2.visible = true
	if (health < MAX_HEALTH * .25):
		$FireSpawn/Fire3.visible = true

func stomp():
	$StompParticles.emit_stomp()

func boss():
	pass

