extends GPUParticles2D

var decreasing = true

@onready var light = $PointLight2D

func _process(_delta):
	if decreasing:
		if light.energy >= .1:
			light.energy -= randf()/70
		else:
			decreasing = false
	else:
		if light.energy <= .4:
			light.energy += randf()/70
		else:
			decreasing = true
