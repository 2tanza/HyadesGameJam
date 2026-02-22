extends Control

@onready var scene_loader = get_node("/root/SceneLoader")
@onready var game_manager = get_node("/root/GameManager")

func _ready() -> void:
	print("MainMenu _ready fired")
	print("children: ", get_children())
	for child in get_children():
		print("child: ", child.name, " children: ", child.get_children())
	$Button.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	scene_loader.load_scene(preload("res://scenes/intro/intro_scene.tscn"))
