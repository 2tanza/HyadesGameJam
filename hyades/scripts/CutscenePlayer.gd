class_name CutscenePlayer
extends Control

signal cutscene_finished

@onready var video_player: VideoStreamPlayer = $VideoPlayer
@onready var skip_button: Button = $SkipButton

func _ready() -> void:
	skip_button.pressed.connect(_on_skip_pressed)
	video_player.finished.connect(_on_video_finished)

func play_cutscene(video: VideoStream) -> void:
	video_player.stream = video
	video_player.play()

func _on_video_finished() -> void:
	emit_signal("cutscene_finished")

func _on_skip_pressed() -> void:
	video_player.stop()
	emit_signal("cutscene_finished")
