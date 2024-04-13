extends Camera2D

@export var randomStrength: float = 7.0
@export var shakeFade: float = 5.0


var rng = RandomNumberGenerator.new()

var shake_strength : float = 0.0

var ground_shake = false

func _ready():
	get_parent().connect("camera_shake", apply_shake)
	get_parent().connect("ground_shake", apply_shake_boss)
	

func apply_shake():
	ground_shake = false
	shake_strength = randomStrength
	$AnimationPlayer.play("damage")

func apply_shake_boss():
	ground_shake = true
	shake_strength = randomStrength
	

func _process(delta):
	if offset.x < 0.1 and offset.y < 0.1:
		offset = Vector2.ZERO
	#if Globals.connect("health_change", update_health)
		#apply_shake()
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()

func randomOffset():
	if ground_shake:
		return Vector2(0, rng.randf_range(-shake_strength, shake_strength))
		
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
