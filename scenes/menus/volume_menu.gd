extends Control




func _on_close_button_pressed():
	$Button.play()	
	await $Button.finished	
	$".".get_parent().visible = false
