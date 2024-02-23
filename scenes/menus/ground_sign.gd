extends Control

@export var text: String

func _process(delta):
	$Label.text = text
