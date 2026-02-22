extends Interactable

signal grapes_stomped

@export var label: Label

func interact(player: Player) -> void:
	if not player.is_holding("grapes"):
		label.text = "Need grapes first!"
		return
	player.clear_held_item()
	label.text = "Stomping..."
	emit_signal("grapes_stomped")
