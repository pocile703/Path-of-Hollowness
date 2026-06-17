# Path of Hollowness

A pixel-art 2D precision platformer built in **Godot 4**, inspired by *Path of Pain* by Robin Eversunshine — the final and hardest level of *Hollow Knight*. The goal is simple to describe and brutal to do: dash, jump, and air-dash through a chain of deadly rooms without dying.

## Features

- **Tight platforming movement** — running, jumping, and dashing with custom player states.
- **Guided tutorial rooms** — four tutorial stages (`tut_1`–`tut_4`) that introduce each mechanic before the real challenge.
- **Multiple levels** — a start scene, tutorial sequence, and four main scenes that ramp up in difficulty.
- **Save & load** — progress is persisted between sessions (`main/save_and_load.gd`).
- **Pause & settings menus** — rebindable controls, volume sliders, and an optional **instant death** mode for extra pain.
- **Smooth scene transitions, sound, and a victory screen.**

## Controls

- **Move:** Arrow keys/Configured in the in-game **Settings** menu
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

- **Inspiration and References:** https://github.com/RobinEversunshine/Godot_Pixelized_Hollow_Knight
- **Assets/Arts Demo:** https://www.artstation.com/artwork/EzaR0N
---

## Credits
- **Huge thanks to Robin Eversunshine for the assets and inspiration.**
- **Game referenced by the award winning: Hollow Knight.**

Made by **pocile703**.
**MADE FOR EDUCATIONAL PURPOSES ONLY**


I made this as my final year project so for any copyright concerns please do contact me.

**ALL CREDITS GO TO [Robin Eversunshin]([https://godotengine.org/download](https://github.com/RobinEversunshine)) AS I ONLY ADDED TUTORIAL LEVELS TO HIS GAME**
