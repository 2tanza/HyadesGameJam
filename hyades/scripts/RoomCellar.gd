extends Node2D

signal level_finished

@onready var shelf: Area2D = $GrapeShelf
@onready var vat: Area2D = $StompingVat
@onready var juice_bottle: Sprite2D = $JuiceBottle
@onready var player: Player = $Player

func _ready() -> void:
	vat.grapes_stomped.connect(_on_grapes_stomped)
	juice_bottle.visible = false
	$BottlePickup.visible = false
	$BottlePickup.bottle_picked_up.connect(_on_bottle_picked_up)
	player.position = Vector2(640, 150)

func _on_grapes_stomped() -> void:
	# Show the bottle
	juice_bottle.visible = true
	vat.label.text = "Grape juice ready!"
	# Make bottle interactable
	var bottle_pickup = $BottlePickup
	bottle_pickup.visible = true

func _on_bottle_picked_up() -> void:
	emit_signal("level_finished")
