extends CanvasLayer

var heart: PackedScene = preload("res://scenes/ui/heart.tscn")

@onready var health_counter: HBoxContainer = $HealthCounter/HBoxContainer

func _ready():
	Globals.connect("health_change", update_health)
	update_health()

func update_health():
	# clear all hearts
	for child in health_counter.get_children():
		child.queue_free()
	# repopulate hearts
	for i in Globals.health:
		health_counter.add_child(heart.instantiate())
