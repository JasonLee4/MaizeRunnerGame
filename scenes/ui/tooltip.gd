extends NinePatchRect


func _ready():
	pass
	

func apply_text(text, display):
	$RichTextLabel.text = text
	$RichTextLabel.visible = display
	
