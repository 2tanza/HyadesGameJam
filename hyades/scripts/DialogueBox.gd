class_name DialogueBox
extends Control

signal dialogue_dismissed

@onready var dialogue_text: Label = $Panel/Margins/Layout/DialogueText
@onready var continue_button: Button = $Panel/Margins/Layout/ContinueButton

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	hide()  # hidden by default, BaseLevel will show it

func show_dialogue(text: String) -> void:
	dialogue_text.text = text
	show()

func _on_continue_pressed() -> void:
	hide()
	emit_signal("dialogue_dismissed")
