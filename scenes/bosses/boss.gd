extends enemy
class_name boss

func _ready():
	MAX_HEALTH = 1000
	health = 10
	damage = 1
	
	$Healthbar.max_value = MAX_HEALTH
	set_health()

func special_animation():
#Eye animation flipping
	if $Base.flip_h == true:
		$RedEyes.flip_h = true
		$CollisionShape2D.position = Vector2(-63, -1)
		$enemy_hitbox/CollisionShape2D.position = Vector2(-28, 20)
		$Spawn.position = Vector2(30, -59)
		$FireSpawn.position = Vector2(-60,0)
		$PointLight2D.position = Vector2(-60.5,-5)
	else:
		$RedEyes.flip_h = false
		$CollisionShape2D.position = Vector2(4, -1)
		$enemy_hitbox/CollisionShape2D.position = Vector2(36, 20)
		$Spawn.position = Vector2(-90, -59)
		$FireSpawn.position = Vector2(0,0)
		$PointLight2D.position = Vector2(-0.5,-5)

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

