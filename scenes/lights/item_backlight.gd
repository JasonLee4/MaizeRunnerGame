extends Node2D

@export var color: Color = Color.YELLOW
@onready var light = $Glow
@onready var shadow = $GlowShadow

var decreasing = true

func _ready():
	light.color = color

func _process(_delta):
	if decreasing:
		if light.energy >= .2:
			light.energy -= .001
		else:
			decreasing = false
	else:
		if light.energy <= .5:
			light.energy += .001
		else:
			decreasing = true
