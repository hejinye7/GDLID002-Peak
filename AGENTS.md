# AGENTS.md — GodotLine

## What This Is

A Dancing Line game template for **Godot 4.6+** (GDScript). Players auto-move along a line, clicking to turn. All game content lives in `#Template/` (directories prefixed with `#`). No automated tests — testing is manual via the Godot editor (F5).

**Note**: This repo also contains `MiMo2API/`, an unrelated Python/FastAPI proxy project. Ignore it when working on the game.

## Running

Open `project.godot` in Godot Engine 4.6+, press F5. Sample scene: `#Template/[Scenes]/Sample/Sample.tscn`. Export preset: Windows Desktop only. Editor plugin `addons/template/` adds a welcome/README page on first open.

## Critical Conventions

- **Naming**: `lowerCamelCase` vars/funcs, `PascalCase` class_name, `UPPER_SNAKE_CASE` constants
- **Physics layers**: 1=Player, 2=BaseFloor, 3=BaseWall. Player `collision_mask=2`, wall Area3D child `collision_mask=4`
- **Default speed**: 12.0, **Gravity**: `Vector3(0, -9.3, 0)`
- **Engine**: Jolt Physics on separate thread, mobile renderer

## Architecture Essentials

### LevelManager is RefCounted, NOT a Node

Has no `_ready()`, no tree access. Use `Player.instance.get_tree()` instead. State machine: `Waiting → Playing → Moving → Died → Completed`.

### Singleton Pattern

Key nodes: `class_name` + `static var instance` + `instance = self` in `_ready()`. Applies to Player, CameraFollower, GuidanceController, etc. Static RefCounted singletons: AudioManager, ObjectPool, SetLatency.

### Trigger System — Three Modes Coexist

When adding new triggers, use **Mode 1** (pure component):

| Mode | Base | How to add |
|------|------|-----------|
| **Pure component** | `extends Node3D` | Child of BaseTrigger, implement `func trigger(body: Node3D)` |
| **Self-container** | `extends BaseTrigger` | Override `_on_triggered(body)` |
| **Old mode** | `extends Area3D` | Own `body_entered` signal (legacy, don't use for new triggers) |

See `Comp.md` for full trigger architecture.

### @tool Editor Scripts

Guard `_ready()` with `Engine.is_editor_hint()`. The `@export var execute: bool` checkbox pattern: getter returns `false`, setter triggers one-shot generation.

### Revive / Checkpoint

Checkpoint captures full state (transform, camera, fog, light, ambient, material colors, music position, anim time). `Checkpoint.revive()` restores everything. Crown revive costs 1 crown from `LevelManager.crown`.

### AudioManager

Static methods: `AudioManager.play_clip(clip, volume)` for SFX, `AudioManager.play_track(clip, volume)` for music, `AudioManager.fade_out()`. Each `play_clip` creates a new AudioStreamPlayer (not yet pooled).

## Gotchas

- `move_and_slide()` must be called **after** gravity, **before** `is_on_floor()` — wrong order = floor detection always false
- Renaming/deleting a script requires updating all `.tscn` references manually or scenes break
- `RoadMaker.new_road()` must fire via signal before `_physics_process()` starts or `road` stays null
- `_delay_applied` flag guards music delay on revive — must not re-apply
- Jolt Physics on separate thread — thread safety matters for physics state access
- `SetMaterialColor.gd` is part of checkpoint restore chain via `revive_notification`
- `@export var execute: bool` with getter returning `false` is the standard one-shot editor tool pattern (NoteReader, BeatmapReader, etc.)

## Repo Structure

**This repo contains two unrelated projects.** The Godot game template is the primary project.

```
#Template/              — All game content (scripts, scenes, resources, music)
  [Scripts]/Level/      — Player, LevelManager, AudioManager, ObjectPool, RoadMaker, gameui
  [Scripts]/Trigger/    — Pure components (Jump, Speed, KillPlayer...) + Single/ (BaseTrigger, Checkpoint, Crown, Gem)
  [Scripts]/CameraScripts/ — CameraFollower (new) + OldCameraFollower (legacy)
  [Scripts]/Animator/   — AnimatorBase, PosAnimator, LocalPosAnimator, LocalRotAnimator, MovingPosMax
  [Scripts]/Settings/   — LevelData, CameraSettings, FogSettings, LightSettings resources
  [Scenes]/             — Sample/Sample.tscn, DefaultScene/Default.tscn
addons/
  template/             — Editor plugin: shows welcome/README page on first project open
  godot_mcp/            — Godot MCP (Model Context Protocol) integration plugin
MiMo2API/               — Separate Python/FastAPI proxy project (NOT game code). Has its own README, venv, Dockerfile
```

`.agents/`, `.codex/`, `.devin/`, `.opencode/` are AI tool config directories, not game content.

## Companion Docs

- `CLAUDE.md` — full architecture reference with detailed trigger file map, camera systems, audio system, beatmap import, and all gotchas (read for deep context)
- `Comp.md` — trigger system architecture: three coexistence modes, BaseTrigger details, revive integration, code patterns
- `TODO.md` — feature parity tracking vs Unity 冰焰模板 V4.7.6 (P0–P3 priorities)
- `CONTRIBUTING.md` — branch naming (GD-xxx), PR workflow, GDScript style conventions
