extends Node

# level_data is now set via receive_level_data() from GameManager — NOT via .tscn export.
# Do NOT assign level_data in the Inspector or .tscn file.
var level_data: LevelData = null

const ROOM_CABIN = preload("res://scenes/levels/level_01_grape_juice/room_cabin.tscn")
const ROOM_CELLAR = preload("res://scenes/levels/level_01_grape_juice/room_cellar.tscn")

@onready var room_container: Node2D = $RoomContainer

var current_room = null

func _ready() -> void:
	# Nothing here — we wait for GameManager to call receive_level_data()
	pass

# Called by GameManager after scene load. This replaces the old export + _on_ready_deferred pattern.
func receive_level_data(data: LevelData) -> void:
	level_data = data
	print("Level01 received level_data: ", level_data.display_name)
	$DialogueBox.dialogue_dismissed.connect(_on_dialogue_dismissed)
	if level_data.problem_dialogue != "":
		$DialogueBox.show_dialogue(level_data.problem_dialogue)
	else:
		# No dialogue — go straight to the first room
		load_room(ROOM_CABIN)

func _on_dialogue_dismissed() -> void:
	load_room(ROOM_CABIN)

func load_room(room_scene: PackedScene) -> void:
	if current_room:
		current_room.queue_free()
	current_room = room_scene.instantiate()
	room_container.add_child(current_room)
	# Connect door signal directly from the DoorToCellar node
	var door = current_room.get_node_or_null("DoorToCellar")
	if door:
		door.door_used.connect(_on_go_to_cellar)
	if current_room.has_signal("level_finished"):
		current_room.level_finished.connect(_on_level_finished)

func _on_go_to_cellar() -> void:
	load_room(ROOM_CELLAR)

func _on_level_finished() -> void:
	var gm = get_node("/root/GameManager")
	gm.complete_level(level_data.reward_item)
