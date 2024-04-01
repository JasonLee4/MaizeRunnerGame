extends Node

var transitioning : bool
signal done

func transition(from : Camera2D, to : Camera2D, duration : float = 1.0):
	
	$Camera2D.zoom = from.zoom
	$Camera2D.offset = from.offset
	$Camera2D.light_mask = from.light_mask

	$Camera2D.global_transform = from.global_transform
	
	$Camera2D.make_current()
	
	transitioning = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Camera2D, "global_transform", to.global_transform, duration).from($Camera2D.global_transform)
	tween.tween_property($Camera2D, "zoom", to.zoom, duration).from($Camera2D.zoom)

	# Wait for the tween to complete
	await tween.finished
	
	to.make_current()
	transitioning = false
	done.emit()
