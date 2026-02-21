extends CanvasLayer

@onready var fade_overlay: ColorRect = $FadeOverlay

const FADE_DURATION: float = 0.4

func _ready() -> void:
	layer = 10
	fade_overlay.modulate.a = 0.0

func load_scene(scene: PackedScene) -> void:
	await _fade_in()
	get_tree().change_scene_to_packed(scene)
	await get_tree().process_frame
	await _fade_out()

func _fade_in() -> void:
	# Fade to black
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 1.0, FADE_DURATION)
	await tween.finished

func _fade_out() -> void:
	# Fade back to clear
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 0.0, FADE_DURATION)
	await tween.finished
