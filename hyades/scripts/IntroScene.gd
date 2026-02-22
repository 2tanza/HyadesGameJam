extends Node2D

@onready var boar_container: Node2D = $BoarContainer
@onready var debug_label: Label = $DebugLabel
@onready var game_manager = get_node("/root/GameManager")

const BOAR_SCENE = preload("res://scenes/intro/boar.tscn")

const REGULAR_BOAR_COUNT = 3
const SPAWN_X = -100.0       # just off left edge of screen
const SPAWN_Y = 360.0        # middle height of 720p screen
const BOAR_SPACING = 2.0     # seconds between boar spawns

var boars_killed: int = 0
var boars_spawned: int = 0
var golden_boar_spawned: bool = false
var spawn_timer: float = 0.0

func _ready() -> void:
	spawn_timer = 0.5  # short delay before first boar appears

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		try_spawn_next_boar()

func try_spawn_next_boar() -> void:
	# All regular boars spawned, golden boar already spawned or waiting for kills
	if boars_spawned >= REGULAR_BOAR_COUNT:
		return
	spawn_regular_boar()

func spawn_regular_boar() -> void:
	var boar = BOAR_SCENE.instantiate()
	boar.position = Vector2(SPAWN_X, SPAWN_Y)
	boar.is_golden = false
	boar.boar_clicked.connect(_on_boar_clicked)
	boar_container.add_child(boar)
	boars_spawned += 1
	spawn_timer = BOAR_SPACING

func spawn_golden_boar() -> void:
	golden_boar_spawned = true
	var boar = BOAR_SCENE.instantiate()
	boar.position = Vector2(SPAWN_X, SPAWN_Y)
	boar.is_golden = true
	boar.move_speed = 150.0  # slightly slower so player has time to click
	boar.boar_clicked.connect(_on_boar_clicked)
	boar_container.add_child(boar)

func _on_boar_clicked(boar: Area2D) -> void:
	if boar.is_golden:
		boar.die()
		trigger_cutscene()
	else:
		boar.die()
		boars_killed += 1
		update_debug_label()
		if boars_killed >= REGULAR_BOAR_COUNT and not golden_boar_spawned:
			spawn_golden_boar()
func update_debug_label() -> void:
	var remaining = REGULAR_BOAR_COUNT - boars_killed
	if remaining > 0:
		debug_label.text = "Boars remaining: " + str(remaining)
	else:
		debug_label.text = "Click the golden boar!"

func trigger_cutscene() -> void:
	debug_label.text = "Cutscene would play here!"
	# TODO: Person 4 hooks in the real cutscene here
	# For now, wait 2 seconds then hand off to GameManager
	await get_tree().create_timer(2.0).timeout
	game_manager.start_game()
