extends StaticBody2D

@onready var interaction_area = $Area2D

const lines: Array[String] = [
	"Hey!",
	"Wow, you're trying to find the best corn in the maize?",
	"You got some chops, for sure.",
	"I heard there's some baddies ahead...",
	"Use LEFTCLICK to turn on your flashlight.",
	"You can also use SPACE to dash. ",
	"Good luck out there!"
]

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		print("interact pressed")
		if interaction_area.get_overlapping_bodies().size() > 0:
			print("overlap detected")
			DialogueManager.start_dialogue(global_position, lines)
			
			

func _process(delta):
	$AnimatedSprite2D.play("cowidle")


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		Globals.tooltip_update.emit("[F] Speak", true)

func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		Globals.tooltip_update.emit("", false)
