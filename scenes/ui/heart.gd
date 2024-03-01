extends Control


# Called when the node enters the scene tree for the first time.
func set_full(is_full):
	if not is_full:
		$MissingHeart.visible = true
		$FullHeart.visible = false
	else:
		$MissingHeart.visible = false
		$FullHeart.visible = true
