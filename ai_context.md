# AI CONTEXT DOCUMENT — Dionysus Game Jam Project
# Paste this at the start of any AI conversation about this project.

## Project overview

This is a Godot 4.x (GDScript) 2D game jam project called a "parental simulator" where the Hyades nymphs raise baby Dionysus (Greek god of revelry) by giving him increasingly un-baby-like items. It consists of a sequence of self-contained levels that chain together, ending in a timeskip cutscene where adult Dionysus turns the Hyades into stars.

Team size: 4 people.
- Person 1: Systems/core architecture (already built — see below)
- Person 2: Levels 1–3
- Person 3: Levels 4–6
- Person 4: Cutscenes, UI, ending sequence
- Artist: Async, delivers assets to res://assets/

Engine: Godot 4.x
Language: GDScript
Cutscenes: 2D Blender animations exported as .webm video files

---

## Project directory structure

```
res://
├── assets/
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   ├── sprites/
│   └── cutscenes/          ← .webm files go here
├── resources/
│   ├── levels/             ← LevelData .tres files
│   └── items/              ← ItemData .tres files
├── scenes/
│   ├── core/
│   │   ├── audio_manager.tscn
│   │   ├── game_manager.tscn
│   │   └── scene_loader.tscn
│   ├── ui/
│   │   └── dialogue_box.tscn
│   ├── cutscenes/
│   │   └── cutscene_player.tscn
│   └── levels/
│       ├── level_template/     ← reference level, copy this
│       └── level_XX_name/      ← each level in its own folder
└── scripts/
    ├── ItemData.gd
    ├── LevelData.gd
    ├── AudioManager.gd
    ├── GameManager.gd
    ├── BaseLevel.gd
    ├── DialogueBox.gd
    ├── CutscenePlayer.gd
    ├── SceneLoader.gd
    ├── LevelTemplate.gd
    └── MainMenu.gd
```

---

## Autoloads (global singletons)

Three autoloads are registered, in this order:

1. **AudioManager** → `scenes/core/audio_manager.tscn`
2. **GameManager** → `scenes/core/game_manager.tscn`
3. **SceneLoader** → `scenes/core/scene_loader.tscn`

Access them from any script using their name, but declare them with get_node to avoid type errors:
```gdscript
@onready var game_manager = get_node("/root/GameManager")
@onready var audio_manager = get_node("/root/AudioManager")
```

---

## Custom resource types

### ItemData (res://scripts/ItemData.gd)
```gdscript
class_name ItemData
extends Resource

@export var item_name: String = ""
@export var description: String = ""
@export var item_sprite: Texture2D
```

### LevelData (res://scripts/LevelData.gd)
```gdscript
class_name LevelData
extends Resource

@export var level_id: String = ""
@export var display_name: String = ""
@export var problem_dialogue: String = ""
@export var level_scene: PackedScene
@export var reward_item: ItemData
@export var cutscene_video: VideoStream
@export var unlock_music: AudioStream
```

---

## Core scripts (DO NOT MODIFY)

### AudioManager.gd
```gdscript
extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

func play_music(stream: AudioStream) -> void:
    if music_player.stream == stream:
        return
    music_player.stream = stream
    music_player.play()

func stop_music() -> void:
    music_player.stop()

func play_sfx(stream: AudioStream) -> void:
    sfx_player.stream = stream
    sfx_player.play()
```

### GameManager.gd
```gdscript
extends Node

@onready var audio_manager = get_node("/root/AudioManager")
@export var cutscene_player_scene: PackedScene
@export var level_sequence: Array[LevelData] = []

var current_level_index: int = 0
var collected_items: Array[ItemData] = []

func start_game() -> void:
    current_level_index = 0
    collected_items.clear()
    start_next_level()

func start_next_level() -> void:
    if current_level_index >= level_sequence.size():
        trigger_ending()
        return
    var level_data: LevelData = level_sequence[current_level_index]
    if level_data.unlock_music:
        audio_manager.play_music(level_data.unlock_music)
    SceneLoader.load_scene(level_data.level_scene)

func complete_level(item: ItemData) -> void:
    collected_items.append(item)
    var level_data: LevelData = level_sequence[current_level_index]
    current_level_index += 1
    if level_data.cutscene_video and cutscene_player_scene:
        var cutscene = cutscene_player_scene.instantiate()
        get_tree().current_scene.add_child(cutscene)
        cutscene.play_cutscene(level_data.cutscene_video)
        cutscene.cutscene_finished.connect(_on_cutscene_finished)
    else:
        start_next_level()

func _on_cutscene_finished() -> void:
    start_next_level()

func trigger_ending() -> void:
    print("All levels complete! Ending goes here.")
```

### BaseLevel.gd
```gdscript
class_name BaseLevel
extends Node2D

@export var level_data: LevelData
signal level_complete(item: ItemData)

@onready var game_manager = get_node("/root/GameManager")
@onready var dialogue_box = $DialogueBox

func _ready() -> void:
    level_complete.connect(game_manager.complete_level)
    dialogue_box.dialogue_dismissed.connect(_on_dialogue_dismissed)
    if level_data and level_data.problem_dialogue != "":
        dialogue_box.show_dialogue(level_data.problem_dialogue)

func _on_dialogue_dismissed() -> void:
    pass  # override in child level scripts to trigger gameplay start

func on_item_collected() -> void:
    if level_data and level_data.reward_item:
        emit_signal("level_complete", level_data.reward_item)
    else:
        push_warning("Level completed but no reward_item assigned in LevelData!")
```

### SceneLoader.gd
```gdscript
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
    var tween = create_tween()
    tween.tween_property(fade_overlay, "modulate:a", 1.0, FADE_DURATION)
    await tween.finished

func _fade_out() -> void:
    var tween = create_tween()
    tween.tween_property(fade_overlay, "modulate:a", 0.0, FADE_DURATION)
    await tween.finished
```

### DialogueBox.gd
```gdscript
class_name DialogueBox
extends Control

signal dialogue_dismissed

@onready var dialogue_text: Label = $Panel/Margins/Layout/DialogueText
@onready var continue_button: Button = $Panel/Margins/Layout/ContinueButton

func _ready() -> void:
    continue_button.pressed.connect(_on_continue_pressed)
    hide()

func show_dialogue(text: String) -> void:
    dialogue_text.text = text
    show()

func _on_continue_pressed() -> void:
    hide()
    emit_signal("dialogue_dismissed")
```

### CutscenePlayer.gd
```gdscript
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
```

---

## How to create a level (the contract)

Every level scene MUST follow this contract or the game loop breaks:

1. Root node is Node2D
2. Root script extends BaseLevel
3. Root script calls super._ready() as first line of _ready()
4. Scene has a child node named exactly "DialogueBox" that is an instanced dialogue_box.tscn scene
5. Script has a LevelData resource assigned in the Inspector (drag the .tres file in)
6. When the player earns the item, the script calls on_item_collected()

### Minimal valid level script:
```gdscript
extends BaseLevel

func _ready() -> void:
    super._ready()
    # your setup code here

func _on_dialogue_dismissed() -> void:
    # called when player clicks Continue on the dialogue popup
    # start your gameplay here if needed
    pass

# call on_item_collected() from wherever makes sense in your gameplay
# for example, when player touches an item Area2D:
func _on_item_area_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        on_item_collected()
```

### Things level scripts can safely do:
- Add any nodes to the scene tree
- Use any Godot built-in nodes (CharacterBody2D, Area2D, AnimationPlayer, etc.)
- Call AudioManager.play_sfx(stream) for sound effects
- Override _on_dialogue_dismissed() to trigger gameplay after dialogue closes
- Add additional signals and connect them internally

### Things level scripts must NOT do:
- Call get_tree().change_scene_to_packed() directly
- Modify current_level_index on GameManager
- Remove or rename the DialogueBox node
- Skip calling super._ready()

---

## Level sequence configuration

The level order is controlled entirely by the `level_sequence` array on the GameManager node, set in the Godot Inspector. It is an Array[LevelData]. To reorder levels, reorder the array entries. To add a level, append a new LevelData .tres file. No code changes are required.

---

## Asset pipeline

All artist assets drop into res://assets/ with no code changes needed:
- Sprites reference via @export var item_sprite: Texture2D on ItemData resources
- Music references via @export var unlock_music: AudioStream on LevelData resources  
- Cutscene videos reference via @export var cutscene_video: VideoStream on LevelData resources
- All connections are made in the Godot Inspector by dragging files into export fields

Cutscene video format: .webm (VP8/VP9), 1280x720, 24fps agreed standard.

---

## Known quirks and solutions

- Autoloads must be accessed via get_node("/root/AutoloadName") not by name directly, to avoid GDScript type checker errors
- SceneLoader root node is CanvasLayer (not Control) so that layer = 10 works
- FadeOverlay ColorRect Mouse Filter must be set to Ignore or it blocks clicks
- DialogueBox must be added via Instantiate Child Scene, not Add Child Node, or its internal node tree won't exist
- await get_tree().process_frame is required after change_scene_to_packed before accessing current_scene
