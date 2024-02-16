extends Node2D

@onready var light = $Glow
@onready var shadow = $GlowShadow

var decreasing = true

func _process(_delta):
	if decreasing:
		if light.energy >= .1:
			light.energy -= .001
		else:
			decreasing = false
	else:
		if light.energy <= .4:
			light.energy += .001
		else:
			decreasing = true
