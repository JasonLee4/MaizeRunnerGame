extends StaticBody2D

@onready var interaction_area = $Area2D

const lines: Array[String] = [
	"Hey!",
	"Wow, you're trying to escape the farm?",
	"That's crazy...",
	"Press space to dash!",
]

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		print("interact pressed")
		if interaction_area.get_overlapping_bodies().size() > 0:
			print("overlap detected")
			DialogueManager.start_dialogue(global_position, lines)
			
