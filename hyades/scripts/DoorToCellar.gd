extends Interactable

signal door_used

func interact(player: Player) -> void:
	emit_signal("door_used")
