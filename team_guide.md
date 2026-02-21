# 🍇 Dionysus Game Jam — Level Developer Guide

Welcome to the project! This doc covers everything you need to know to build your assigned levels without touching any of the core systems.

---

## How the game works (quick summary)

The game is structured as a sequence of levels defined in `GameManager`. Each level:

1. Loads a scene
2. Shows a dialogue popup hinting at what Dionysus wants
3. Player does gameplay stuff to collect an item
4. Item is presented, cutscene plays
5. Next level loads

You don't need to worry about steps 4 or 5 — the core systems handle all of that automatically once you emit the right signal.

---

## Your folder

Each level lives in its own folder under `scenes/levels/`. Create yours like this:

```
scenes/levels/
└── level_01_grape_juice/
    ├── level_01_grape_juice.tscn   ← your scene
    └── level_01_grape_juice.gd     ← your script
```

Use your level number and a short name. Keep it all lowercase with underscores.

---

## Creating a new level — step by step

### Step 1 — Duplicate the template

In the Godot FileSystem panel:

1. Right-click `scenes/levels/level_template/` → **Duplicate**
2. Rename the duplicated folder to your level name
3. Rename the `.tscn` and `.gd` files inside to match

### Step 2 — Open your scene

Double-click your `.tscn` file. You'll see this node tree:

```
YourLevel (Node2D)
├── DialogueBox       ← don't touch this, it works automatically
├── DebugLabel        ← delete this when you build real gameplay
└── TestCollectButton ← delete this when you build real gameplay
```

### Step 3 — Update your script

Open your `.gd` file. It will look like this from the template:

```gdscript
extends BaseLevel

func _ready() -> void:
    super._ready()
    $TestCollectButton.pressed.connect(_on_collect_pressed)

func _on_collect_pressed() -> void:
    on_item_collected()
```

Replace the contents with your own gameplay logic. The only rules are:

- **Always keep** `extends BaseLevel` at the top
- **Always call** `super._ready()` as the first line of `_ready()`
- **Always call** `on_item_collected()` when the player earns the item

Everything else is up to you. Add whatever nodes, logic, enemies, puzzles you want.

**Example — a simple level where collecting a pickup item triggers completion:**

```gdscript
extends BaseLevel

func _ready() -> void:
    super._ready()  # shows the dialogue popup, do not remove

func _on_item_area_body_entered(body) -> void:
    if body.is_in_group("player"):
        on_item_collected()  # this triggers the whole end-of-level chain
```

### Step 4 — Make sure DialogueBox is instanced correctly

The `DialogueBox` in your scene must be an **instanced scene**, not a plain node. To check:

- Click the `DialogueBox` node in the Scene panel
- If you see a small film-strip icon next to its name, you're good
- If not, delete it, then right-click your root node → **Instantiate Child Scene** → find `scenes/ui/dialogue_box.tscn`

### Step 5 — Create your LevelData resource

This is the file that connects your level to the GameManager.

1. Right-click `resources/levels/` → **New Resource**
2. Search for `LevelData` → Create
3. Save it as `level_01_data.tres` (use your level number)
4. Click the file and fill in the Inspector:

| Field | What to put |
|---|---|
| Level Id | `level_01` (short, no spaces) |
| Display Name | `The Grape Juice Heist` (whatever you want) |
| Problem Dialogue | The hint text the player sees at the start |
| Level Scene | Drag your `.tscn` file here |
| Reward Item | Drag your `ItemData` resource here (see below) |
| Cutscene Video | Leave empty for now — Person 4 fills this in |
| Unlock Music | Leave empty for now — artist fills this in |

### Step 6 — Create your ItemData resource

1. Right-click `resources/items/` → **New Resource**
2. Search for `ItemData` → Create
3. Save as `item_grape_juice.tres` or whatever your item is
4. Fill in:

| Field | What to put |
|---|---|
| Item Name | `Grape Juice` |
| Description | A short funny description |
| Item Sprite | Leave empty until artist delivers the sprite |

Then go back to your `LevelData` and drag this into the **Reward Item** slot.

### Step 7 — Tell Person 1 your level is ready

Person 1 (Systems) adds your `LevelData` resource to the GameManager's level sequence. Just let them know your `.tres` file is ready and what order your level should appear in.

---

## Rules to follow

**Do:**
- Keep all your files inside your own level folder
- Use `extends BaseLevel` on your root script
- Call `super._ready()` at the start of `_ready()`
- Call `on_item_collected()` when the player earns the item
- Name your nodes clearly so teammates can understand your scene

**Don't:**
- Modify `GameManager.gd`, `BaseLevel.gd`, `AudioManager.gd`, or `SceneLoader.gd`
- Change the name of the `DialogueBox` node (BaseLevel looks for it by that exact name)
- Change scene to a different scene yourself — always use `on_item_collected()` and let the system handle it
- Put files outside your level folder (except resources, which go in `resources/levels/` and `resources/items/`)

---

## Dropping in artist assets

When the artist delivers files, drop them into the correct folder:

| Asset type | Where it goes |
|---|---|
| Sprites / backgrounds | `assets/sprites/` |
| Music tracks | `assets/audio/music/` |
| Sound effects | `assets/audio/sfx/` |
| Cutscene videos (.webm) | `assets/cutscenes/` |

Then open your `LevelData.tres` or `ItemData.tres` in the Inspector and drag the new file into the correct slot. No code changes needed.

---

## Testing your level in isolation

You don't have to run the full game to test your level. You can set your level scene as the temporary main scene:

1. **Project → Project Settings → Application → Run → Main Scene**
2. Set it to your level's `.tscn` file
3. Test, then set it back to `scenes/main_menu.tscn` when done

Note: when running in isolation, GameManager still exists as an Autoload so signals will fire — but there are no other levels to chain to, so it will just print "All levels complete!" in the Output panel when you collect the item. That's expected.

---

## Quick reference — the signals

| Signal | Where it's defined | What it does |
|---|---|---|
| `level_complete(item)` | `BaseLevel.gd` | Tells GameManager the level is finished |
| `dialogue_dismissed` | `DialogueBox.gd` | Fires when player clicks Continue |

You only ever need to trigger `on_item_collected()`. Everything else fires automatically.

---

## Asking for help

If you're stuck, grab the AI context document (`ai_context.md` in the repo root) and paste it at the start of your conversation with any AI assistant. It gives the AI full knowledge of the project structure so it can give you accurate help without you having to explain everything from scratch.
