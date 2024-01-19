extends consumable

func effect(body):
	if body.has_method("player") and Globals.health < 5:
		queue_free()
		Globals.health += 1

