extends GPUParticles2D


func emit_stomp():
	$".".emitting = true
	$Timer.start()
	
func _on_timer_timeout():
	$".".emitting = false
