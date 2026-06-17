# Path of Hollowness

A pixel-art 2D precision platformer built in **Godot 4**, inspired by *Path of Pain* — the final and hardest level of *Hollow Knight*. The goal is simple to describe and brutal to do: dash, jump, and air-dash through a chain of deadly rooms without dying.

I built this in **October 2023**, about two weeks after first picking up Godot. It started as a way to learn the engine and turned into a full, playable game with tutorials, multiple levels, save/load, and a settings menu.

## Features

- **Tight platforming movement** — running, jumping, and dashing with custom player states.
- **Guided tutorial rooms** — four tutorial stages (`tut_1`–`tut_4`) that introduce each mechanic before the real challenge.
- **Multiple levels** — a start scene, tutorial sequence, and four main scenes that ramp up in difficulty.
- **Save & load** — progress is persisted between sessions (`main/save_and_load.gd`).
- **Pause & settings menus** — rebindable controls, volume sliders, and an optional **instant death** mode for extra pain.
- **Smooth scene transitions, sound, and a victory screen.**

## Controls

- **Move:** Arrow keys
- **Jump / Dash / Attack:** as configured in the in-game **Settings** menu

All inputs are rebindable from the Settings screen.

## How to Run

You can either run the source in the editor or play the project directly.

**From source (Godot 4.1+):**
1. Install [Godot 4](https://godotengine.org/download).
2. Open the editor, click **Import**, and select this folder's `project.godot`.
3. Press **F5** (or the Play button) to launch. The main scene is `levels/start_scene.tscn`.

## Project Structure

```
Path of Hollowness/
├── main/      # Game manager, save/load
├── player/    # Player controller, camera, and movement states
├── levels/    # Start scene, tutorials, and main levels
├── objects/   # In-world objects and hazards
├── ui/        # Pause menu, settings, transitions, victory screen
├── sound/     # Audio buses and sound player
├── assets/    # Sprites and art
└── icon/      # Game icon
```

## Tech

- **Engine:** Godot 4 (Mobile renderer)
- **Language:** GDScript

## Links

- **Art & asset showcase:** https://www.artstation.com/artwork/EzaR0N
- **Gameplay / guide video:** https://youtu.be/7hBDyPOqoHY

---

Made by **pocile703**.
