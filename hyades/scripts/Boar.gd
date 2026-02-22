class_name Boar
extends Area2D

signal boar_clicked(boar)

@export var move_speed: float = 200.0
@export var is_golden: bool = false

@onready var sprite: AnimatedSprite2D = $Sprite

var is_dead: bool = false

func _ready() -> void:
	input_pickable = true
	input_event.connect(_on_input_event)
	
	# Swap to gold spriteframes if this is the golden boar
	if is_golden:
		var frames = SpriteFrames.new()
		sprite.sprite_frames = load_gold_frames()
	
	sprite.play("idle")

func load_gold_frames() -> SpriteFrames:
	var frames = SpriteFrames.new()
	
	# idle animation
	frames.add_animation("idle")
	frames.set_animation_loop("idle", true)
	frames.set_animation_speed("idle", 8)
	var idle_texture = load("res://assets/sprites/char_gold_boar.png")
	for i in range(5):
		var atlas = AtlasTexture.new()
		atlas.atlas = idle_texture
		atlas.region = Rect2(i * 140, 0, 140, 148)
		frames.add_frame("idle", atlas)
	
	# death animation
	frames.add_animation("death")
	frames.set_animation_loop("death", false)
	frames.set_animation_speed("death", 12)
	var death_texture = load("res://assets/sprites/char_gold_boar_death.png")
	for i in range(16):
		var atlas = AtlasTexture.new()
		atlas.atlas = death_texture
		atlas.region = Rect2(i * 140, 0, 140, 148)
		frames.add_frame("death", atlas)
	
	return frames

func _process(delta: float) -> void:
	if is_dead:
		return  # stop moving during death animation
	position.x += move_speed * delta
	if position.x > 1400:
		queue_free()

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not is_dead:
				emit_signal("boar_clicked", self)

func die() -> void:
	is_dead = true
	sprite.play("death")
	sprite.animation_finished.connect(_on_death_animation_finished)

func _on_death_animation_finished() -> void:
	queue_free()
