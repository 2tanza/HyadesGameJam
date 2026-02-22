extends Interactable

signal bottle_picked_up

func interact(player: Player) -> void:
	emit_signal("bottle_picked_up")
	queue_free()
