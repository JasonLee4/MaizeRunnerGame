extends StaticBody2D

@onready var interaction_area = $Area2D

const lines: Array[String] = [
	"Hey!",
	"Wow, you're trying to escape the farm?",
	"You got some chops, for sure.",
	"I heard there's some baddies ahead...",
	"Press space to dash, F to pickup items, and LMB to attack!",
]

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		print("interact pressed")
		if interaction_area.get_overlapping_bodies().size() > 0:
			print("overlap detected")
			DialogueManager.start_dialogue(global_position, lines)
			

func _process(delta):
	$AnimatedSprite2D.play("cowidle")
