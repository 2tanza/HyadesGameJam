extends Node2D

# No Player node in this scene — Player lives in Level01GrapeJuice and persists between rooms.
# There must be a Node2D called SpawnPoint in this scene to set where the player appears.

signal level_finished

@onready var grape_shelf: Area2D = $GrapeShelf
@onready var stomping_vat: Area2D = $StompingVat
@onready var juice_bottle: Sprite2D = $JuiceBottle
@onready var bottle_pickup: Area2D = $BottlePickup

func _ready() -> void:
	stomping_vat.grapes_stomped.connect(_on_grapes_stomped)
	juice_bottle.visible = false
	bottle_pickup.visible = false
	bottle_pickup.bottle_picked_up.connect(_on_bottle_picked_up)

func _on_grapes_stomped() -> void:
	juice_bottle.visible = true
	stomping_vat.label.text = "Grape juice ready!"
	bottle_pickup.visible = true

func _on_bottle_picked_up() -> void:
	emit_signal("level_finished")
