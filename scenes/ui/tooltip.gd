extends NinePatchRect


func _ready():
	pass
	

func apply_text(text, display):
	$TextLabel.text = text
	$TextLabel.visible = display
	
