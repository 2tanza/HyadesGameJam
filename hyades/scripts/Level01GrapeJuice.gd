extends Node

var level_data: LevelData = null

const ROOM_CABIN = preload("res://scenes/levels/level_01_grape_juice/room_cabin.tscn")
const ROOM_CELLAR = preload("res://scenes/levels/level_01_grape_juice/room_cellar.tscn")

@onready var room_container: Node2D = $RoomContainer
@onready var player: Player = $Player

var current_room = null

func _ready() -> void:
	pass

# Called by GameManager after scene load
func receive_level_data(data: LevelData) -> void:
	level_data = data
	print("Level01 received level_data: ", level_data.display_name)
	$DialogueBox.dialogue_dismissed.connect(_on_dialogue_dismissed)
	if level_data.problem_dialogue != "":
		$DialogueBox.show_dialogue(level_data.problem_dialogue)
	else:
		load_room(ROOM_CABIN)

func _on_dialogue_dismissed() -> void:
	load_room(ROOM_CABIN)

func load_room(room_scene: PackedScene) -> void:
	if current_room:
		current_room.queue_free()
	current_room = room_scene.instantiate()
	room_container.add_child(current_room)

	# Move the persistent player to the room's spawn point
	var spawn = current_room.get_node_or_null("SpawnPoint")
	if spawn:
		player.position = spawn.position
	else:
		push_warning("No SpawnPoint found in room: " + room_scene.resource_path)

	# Connect cellar door if present
	var door = current_room.get_node_or_null("DoorToCellar")
	if door:
		door.door_used.connect(_on_go_to_cellar)

	# Connect back door if present
	var back_door = current_room.get_node_or_null("CellarToRoom")
	if back_door:
		back_door.go_to_cabin.connect(_on_go_to_cabin)

	# Connect level finish signal if present
	if current_room.has_signal("level_finished"):
		current_room.level_finished.connect(_on_level_finished)

func _on_go_to_cellar() -> void:
	load_room(ROOM_CELLAR)

func _on_go_to_cabin() -> void:
	load_room(ROOM_CABIN)

func _on_level_finished() -> void:
	var gm = get_node("/root/GameManager")
	gm.complete_level(level_data.reward_item)
