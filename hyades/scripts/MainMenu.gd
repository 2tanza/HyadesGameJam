extends Control

@onready var game_manager = get_node("/root/GameManager")

func _ready() -> void:
	print("MainMenu _ready fired")
	print("children: ", get_children())
	for child in get_children():
		print("child: ", child.name, " children: ", child.get_children())
	$Button.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	print("button pressed")
	game_manager.start_game()
