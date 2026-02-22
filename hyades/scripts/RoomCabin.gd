extends Node2D

signal go_to_cellar

@onready var door: Area2D = $DoorToCellar
@onready var player: Player = $Player

func _ready() -> void:
	door.door_used.connect(_on_door_used)
	# Spawn player at starting position
	player.position = Vector2(640, 400)

func _on_door_used() -> void:
	emit_signal("go_to_cellar")
