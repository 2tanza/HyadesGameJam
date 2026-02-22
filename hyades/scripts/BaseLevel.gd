class_name BaseLevel
extends Node

var level_data: LevelData  # injected by GameManager, not exported

signal level_complete(item: ItemData)

func on_item_collected() -> void:
	if level_data and level_data.reward_item:
		emit_signal("level_complete", level_data.reward_item)
	else:
		push_warning("Level completed but no reward_item assigned!")
