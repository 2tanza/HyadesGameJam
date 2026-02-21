class_name BaseLevel
extends Node2D

@export var level_data: LevelData

signal level_complete(item: ItemData)

@onready var game_manager = get_node("/root/GameManager")
@onready var dialogue_box = $DialogueBox

func _ready() -> void:
	level_complete.connect(game_manager.complete_level)
	
	dialogue_box.dialogue_dismissed.connect(_on_dialogue_dismissed)
	if level_data and level_data.problem_dialogue != "":
		dialogue_box.show_dialogue(level_data.problem_dialogue)

func _on_dialogue_dismissed() -> void:
	# Gameplay can begin now — override this in child level scripts if needed
	pass

func on_item_collected() -> void:
	if level_data and level_data.reward_item:
		emit_signal("level_complete", level_data.reward_item)
	else:
		push_warning("Level completed but no reward_item assigned in LevelData!")
