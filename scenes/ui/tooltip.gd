extends NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready():
	$RichTextLabel.visible_characters = 0
	get_parent().connect("tooltip_update", apply_text)

func apply_text(text):
	$RichTextLabel.text = text
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	$RichTextLabel.visible_characters += 2
