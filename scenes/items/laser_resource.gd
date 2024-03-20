extends Node2D





func _on_area_2d_body_entered(body):
	
	$Pickup.play()
	Globals.laser_energy += 20
	visible = false
	await $Pickup.finished
	queue_free()
