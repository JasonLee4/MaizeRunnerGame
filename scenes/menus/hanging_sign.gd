extends Control

@export var text: String

func _process(_delta):
	$Label.text = text
