extends Node2D

@export var color: Color

func _ready():
	$ArrowLight.color = color
