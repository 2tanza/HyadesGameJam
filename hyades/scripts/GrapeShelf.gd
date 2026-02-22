extends Interactable

@export var label: Label

func interact(player: Player) -> void:
	if player.is_holding("grapes"):
		label.text = "Already holding grapes!"
		return
	player.pick_up("grapes")
	label.text = "Grapes taken!"
