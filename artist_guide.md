# 🎨 Dionysus Game Jam — Artist Guide

Everything you need to deliver assets that drop straight into the game with zero back-and-forth.

---

## How your work fits in

The game is built in **Godot 4** (a free, open-source game engine). The developers have set up every asset slot in advance — your files just need to land in the right folder with the right format and the game picks them up automatically. No one needs to touch code when you deliver something new.

The game is a 2D side-on/overhead style parental simulator where the Hyades nymphs raise baby Dionysus. The tone is comedic and mythological — think ancient Greek aesthetics meets slapstick baby chaos. Dionysus is the god of wine and revelry, so the humor comes from him demanding increasingly un-baby-like things (wine, parties, theatrical performances) while the nymphs scramble to provide them.

---

## Drop folders

When you finish something, put it here:

| What | Where |
|---|---|
| Character & environment sprites | `assets/sprites/` |
| Background music | `assets/audio/music/` |
| Sound effects | `assets/audio/sfx/` |
| Cutscene videos | `assets/cutscenes/` |

That's it. The developers wire everything up on their end by dragging your files into the game editor. You don't need to touch Godot at all.

---

## Cutscenes

Cutscenes are created in **Blender** using Grease Pencil (2D animation) and exported as video files.

### Export settings

| Setting | Value |
|---|---|
| Format | **WebM** |
| Video codec | **VP9** |
| Audio codec | **Opus** |
| Resolution | **1280 × 720** (720p) |
| Frame rate | **24 fps** |
| Color space | sRGB |

**Why WebM?** It's the most reliable video format for Godot 4 across all platforms. MP4/H.264 works on most platforms but has licensing issues on some Linux builds. WebM is the safe default.

### Export steps from Blender

1. **Output Properties** → set resolution to 1280 × 720, frame rate to 24
2. **Render → Render Animation** to render your frames first if needed
3. **File → Export → ffmpeg video** and set the container to WebM, video codec to VP9
4. Alternatively render as PNG sequence first, then use Blender's Video Sequencer to encode to WebM

### Naming convention

Name cutscene files to match the level they belong to:

```
cutscene_level_01.webm
cutscene_level_02.webm
cutscene_level_03.webm
...
cutscene_ending.webm
```

### What each cutscene should show

At the end of each level, the Hyades present the collected item to baby Dionysus. He then reacts with over-the-top revelry that is completely inappropriate for a baby. Each cutscene should:

- Show the item being presented
- Show Dionysus's reaction (partying, drinking, summoning a small theatre troupe, etc.)
- Be short — **10 to 30 seconds** is ideal. Players will watch these repeatedly during testing.
- Include a skip button is handled by the game automatically — you don't need to build one into the video

### The ending cutscene

The final cutscene is longer and more dramatic. After enough levels, there is a time skip to adult Dionysus. He rewards the Hyades nymphs by transforming them into stars (the Hyades star cluster). This one can run **60 to 90 seconds**.

### Audio in cutscenes

You can bake audio directly into the WebM export from Blender — dialogue, music, and effects mixed together is fine. The game will play the video file as-is.

---

## Sprites

The game is 2D. Sprites are PNG files with transparent backgrounds.

### Format

| Setting | Value |
|---|---|
| File format | **PNG** |
| Background | **Transparent** (alpha channel) |
| Color mode | RGBA |
| Color profile | sRGB |

### Resolution & scale

The game runs at **1280 × 720**. Design sprites at a scale that looks right at that resolution. A few guidelines:

- **Baby Dionysus** (the main character on screen during gameplay) should be readable and expressive at roughly **100–150px tall**
- **Hyades nymphs** (playable characters) similar scale to Dionysus
- **Items** (the collectibles each level rewards) should read clearly at around **64–80px**
- **Backgrounds** should be exactly **1280 × 720px** to fill the screen
- **UI elements** (buttons, frames, decorative borders) can be any size, but design at 1x — Godot will scale them

### Sprite sheets vs individual files

Deliver **individual files** unless you specifically discuss spritesheets with the developers. Individual PNGs are simpler to wire up and easier to replace later.

For animated characters, deliver individual frames as separate PNGs named sequentially:

```
dionysus_idle_01.png
dionysus_idle_02.png
dionysus_idle_03.png
dionysus_walk_01.png
dionysus_walk_02.png
```

### Naming convention

Use lowercase with underscores. Be descriptive:

```
bg_olympus_vineyard.png       ← background
char_dionysus_idle.png        ← character, state
char_nymph_running.png
item_grape_juice.png          ← collectible item
item_wine_amphora.png
ui_dialogue_frame.png         ← UI element
ui_button_continue.png
```

### Art style notes

- The game has a comedic tone, so expressive characters with slightly exaggerated proportions work well
- Ancient Greek visual motifs (amphorae, olive branches, columns, laurel wreaths, grape vines) are appropriate for backgrounds and decorative elements
- Baby Dionysus should look recognizably godlike even as a baby — think chubby baby with tiny ivy crown and an imperious expression
- The Hyades are nymphs, so they can look nature-adjacent — flowing robes, floral elements, earthy tones

---

## Music

Music files are referenced per-level — each level can have its own track that plays when that level loads.

### Format

| Setting | Value |
|---|---|
| File format | **OGG Vorbis** (.ogg) — preferred |
| Alternative | MP3 (.mp3) — also works |
| Sample rate | 44100 Hz |
| Bit depth | 16-bit |
| Channels | Stereo |
| Bitrate | 128–192 kbps for OGG |

**Why OGG?** Godot handles OGG natively with no licensing issues and it loops cleanly. MP3 can have a small gap at the loop point on some platforms.

### Looping

All background music should be designed to **loop seamlessly**. Godot will loop OGG files automatically. Make sure your track has a clean loop point — either loop from the beginning or use a loop point baked into the file metadata.

If you're using a DAW, export with a clean loop: the last sample of the file should line up musically with the first. A simple way to do this is to leave a bar of natural decay before the loop point, or just fade out and back in.

### Naming convention

```
music_level_01_grape_heist.ogg
music_level_02_spider_cave.ogg
music_menu.ogg
music_ending.ogg
```

### Tone per section

| Section | Tone |
|---|---|
| Main menu | Light, mythological, slightly comedic |
| Levels (general) | Upbeat, adventurous, Greek-adjacent instrumentation |
| Tense/combat levels | More percussive, urgent |
| Ending / timeskip | Emotional, celestial, swells into triumph |

Instrumentation ideas: lyres, aulos (double flute), frame drums, and strings all work for the Greek aesthetic. Mixing these with more modern comedic orchestration (comedic horns, slapstick percussion) fits the tone well.

---

## Sound effects

SFX are short audio files triggered by gameplay events.

### Format

Same as music — **OGG Vorbis** preferred, same specs.

SFX files should be short and punchy. Normalize them to around **-3 dBFS** peak so they're loud enough without clipping.

### Useful SFX to plan for

| Sound | Notes |
|---|---|
| Item collected | Short positive chime or comedic pop |
| Dialogue appear | Soft whoosh or parchment rustle |
| Button click | Light click or tap |
| Baby Dionysus happy | Tiny godly giggle or miniature thunderclap |
| Baby Dionysus unhappy | Dramatic baby cry with reverb |
| Level complete fanfare | Short 2–3 second triumphant sting |
| Scene transition | Optional whoosh to accompany the fade |

---

## Delivering work in progress

You don't have to wait until everything is perfect. Developers can use placeholder assets and swap them out as you finish things.

**Preferred approach:**
- Deliver rough/placeholder versions of sprites and audio early so developers can test with something in place
- Replace them with finals by dropping the new file in the same location with the same filename — the game will use the new version automatically
- Let the relevant developer know when a final version replaces a placeholder

**If you need to change a filename** after it's been integrated, let the developer who uses that asset know so they can update the reference in the editor.

---

## Technical context (for asking AI questions)

The following information will help any AI assistant give you accurate answers about this project.

**Engine:** Godot 4.x

**Asset integration method:** All assets are referenced via `@export` fields on GDScript Resource files (`ItemData` and `LevelData`). Developers assign files by dragging them into the Godot Inspector — no hardcoded paths. This means filenames don't need to match anything in code, but should be consistent and descriptive.

**Video playback:** Godot 4 uses the `VideoStreamPlayer` node. It supports WebM (VP8/VP9) natively. The game plays cutscene videos fullscreen with a skip button. Videos are assigned to levels via `LevelData.cutscene_video` (type `VideoStream`).

**Audio playback:** Godot 4 uses `AudioStreamPlayer` nodes managed by a global `AudioManager` singleton. Music plays via `AudioManager.play_music(stream)`. The manager prevents tracks from restarting if the same track is already playing. OGG files loop automatically when set in Godot's import settings.

**Sprite import:** PNG files imported into Godot 4 default to `Texture2D`. Sprite sheets would use `AtlasTexture` or `SpriteFrames` — but the project uses individual PNGs for simplicity. Animated sprites use Godot's `AnimatedSprite2D` node with a `SpriteFrames` resource.

**Game resolution:** 1280 × 720, windowed. No pixel-art scaling — assets display at their native resolution.

**Color space:** Godot 4 defaults to linear color space for rendering. sRGB source assets (standard for PNG and video) are handled correctly by the engine automatically.

**Blender version note:** Grease Pencil 2D animation in Blender 3.x and 4.x both export to WebM. If using Blender 4.x, the Grease Pencil system was significantly updated (renamed to Grease Pencil v3) — make sure to use the correct mode for your version.

**File size:** No hard limit, but keep individual music tracks under ~10MB and cutscene videos under ~50MB where possible for reasonable build sizes in a game jam context.

**Platforms:** The game jam target platform is likely Windows desktop. WebM and OGG are fully supported on Windows in Godot 4.
