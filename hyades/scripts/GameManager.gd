extends Node
@onready var audio_manager = get_node("/root/AudioManager")
@export var cutscene_player_scene: PackedScene

# The level order. Fill this in the Inspector by dragging .tres files in.
# Reorder here to change the level sequence — no code changes needed.
@export var level_sequence: Array[LevelData] = []

# Tracks where we are
var current_level_index: int = 0
var collected_items: Array[ItemData] = []

# Called by the Main Menu's Start button
func start_game() -> void:
	current_level_index = 0
	collected_items.clear()
	start_next_level()

# Loads whichever level is current
# Loads whichever level is current
func start_next_level() -> void:
	print("start_next_level called, index: ", current_level_index)
	if current_level_index >= level_sequence.size():
		print("level_sequence size: ", level_sequence.size())
		trigger_ending()
		return
	var level_data: LevelData = level_sequence[current_level_index]
	print("loading level: ", level_data.display_name)
	# Play this level's music if one is assigned
	if level_data.unlock_music:
		audio_manager.play_music(level_data.unlock_music)
	SceneLoader.load_scene(level_data.level_scene)

# Called by the level when the player gets the item
func complete_level(item: ItemData) -> void:
	collected_items.append(item)
	
	# Get the cutscene video from the level we just finished
	var level_data: LevelData = level_sequence[current_level_index]
	current_level_index += 1

	# If a cutscene is assigned, play it before moving on
	if level_data.cutscene_video and cutscene_player_scene:
		var cutscene = cutscene_player_scene.instantiate()
		get_tree().current_scene.add_child(cutscene)
		cutscene.play_cutscene(level_data.cutscene_video)
		cutscene.cutscene_finished.connect(_on_cutscene_finished)
	else:
		# No cutscene assigned, skip straight to next level
		start_next_level()

func _on_cutscene_finished() -> void:
	start_next_level()
# Called when all levels are done
func trigger_ending() -> void:
	# TODO: load ending scene
	print("All levels complete! Ending goes here.")
