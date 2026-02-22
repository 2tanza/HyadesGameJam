class_name Player
extends CharacterBody2D

const SPEED = 150.0

@onready var interaction_zone: Area2D = $InteractionZone

# Simple inventory — null means hands empty
var held_item: String = ""

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()
	
	# Face the interaction zone in the direction of movement
	if direction != Vector2.ZERO:
		interaction_zone.position = direction * 32

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print("ui_accept pressed")
		try_interact()

func try_interact() -> void:
	print("try_interact called")
	var interactables = interaction_zone.get_overlapping_areas()
	print("Overlapping areas: ", interactables)
	if interactables.is_empty():
		return
	interactables[0].interact(self)

func pick_up(item_name: String) -> void:
	held_item = item_name
	print("Picked up: ", item_name)

func is_holding(item_name: String) -> bool:
	return held_item == item_name

func clear_held_item() -> void:
	held_item = ""
