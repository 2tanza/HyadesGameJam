extends Node

@onready var audio_manager = get_node("/root/AudioManager")

@export var cutscene_player_scene: PackedScene
@export var level_sequence: Array[LevelData] = []
@export var level_scenes: Array[PackedScene] = []  # parallel to level_sequence, no circular ref

var current_level_index: int = 0
var collected_items: Array[ItemData] = []
var _pending_level_data: LevelData = null

func start_game() -> void:
	print("start_game called")
	print("level_sequence size: ", level_sequence.size())
	print("level_scenes size: ", level_scenes.size())
	for i in range(level_sequence.size()):
		var ld = level_sequence[i]
		print("  level ", i, ": ", ld.display_name, " | scene assigned: ", i < level_scenes.size() and level_scenes[i] != null)
	current_level_index = 0
	collected_items.clear()
	start_next_level()

func start_next_level() -> void:
	if current_level_index >= level_sequence.size():
		trigger_ending()
		return

	var level_data: LevelData = level_sequence[current_level_index]

	if level_data.unlock_music:
		audio_manager.play_music(level_data.unlock_music)

	_pending_level_data = level_data

	# Load the scene via SceneLoader (fades out, swaps, fades in)
	await SceneLoader.load_scene(level_scenes[current_level_index])

	# Wait one full frame AFTER SceneLoader fully returns so current_scene is correct
	await get_tree().process_frame

	var level = get_tree().current_scene
	print("current scene after load: ", level.name)

	# Inject level data via method call — avoids all export serialization issues
	if level.has_method("receive_level_data"):
		level.receive_level_data(_pending_level_data)
		print("GameManager injected level_data: ", _pending_level_data.display_name)
	else:
		push_warning("Loaded scene has no receive_level_data() method: " + level.name)

func complete_level(item: ItemData) -> void:
	collected_items.append(item)
	var level_data: LevelData = level_sequence[current_level_index]
	current_level_index += 1

	if level_data.cutscene_video and cutscene_player_scene:
		var cutscene = cutscene_player_scene.instantiate()
		get_tree().current_scene.add_child(cutscene)
		cutscene.play_cutscene(level_data.cutscene_video)
		cutscene.cutscene_finished.connect(_on_cutscene_finished)
	else:
		start_next_level()

func _on_cutscene_finished() -> void:
	start_next_level()

func trigger_ending() -> void:
	print("All levels complete! Ending goes here.")
