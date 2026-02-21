extends BaseLevel

func _ready() -> void:
	super._ready()  # calls BaseLevel._ready() which shows the dialogue
	$TestCollectButton.pressed.connect(_on_collect_pressed)

func _on_collect_pressed() -> void:
	on_item_collected()  # inherited from BaseLevel — triggers the whole chain
