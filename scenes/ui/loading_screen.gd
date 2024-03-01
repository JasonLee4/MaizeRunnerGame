extends Control

@onready var screen_text = $Label

func set_text(text):
	screen_text.text = text
