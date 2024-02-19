extends Camera2D

@export var randomStrength: float = 10.0
@export var shakeFade: float = 5.0


var rng = RandomNumberGenerator.new()

var shake_strength : float = 0.0

func _ready():
	get_parent().connect("camera_shake", apply_shake)

func apply_shake():
	shake_strength = randomStrength
	$AnimationPlayer.play("damage")

func _process(delta):
	if offset.x < 0.1 and offset.y < 0.1:
		offset = Vector2.ZERO
	#if Globals.connect("health_change", update_health)
		#apply_shake()
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()

func randomOffset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
