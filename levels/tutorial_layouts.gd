class_name TutorialLayouts

## Data definitions for the four teaching levels. Tile coords are 16px units.
## Physics: jump -250 (~4 tiles) + double jump; wall-jump (400,-250); dash
## 650 for 0.15s (~6 tiles flat); pogo (Down+Attack on a saw) bounce -150 and
## resets jumps; crystal dash (charge super_dash, release) blasts to a wall.

static func build(id: int) -> TutorialLayout:
	match id:
		1: return _level1()
		2: return _level2()
		3: return _level3()
		_: return _level4()


## Human-readable label for the key currently bound to an action, so hints show
## the player's real button (default OR remapped). Reads the live InputMap.
static func key_label(action: String) -> String:
	if InputMap.has_action(action):
		for e in InputMap.action_get_events(action):
			if e is InputEventKey:
				var kc: int = e.physical_keycode if e.physical_keycode != 0 else e.keycode
				return OS.get_keycode_string(kc)
			elif e is InputEventMouseButton:
				return _mouse_label(e.button_index)
	return "?"

static func _mouse_label(idx: int) -> String:
	match idx:
		MOUSE_BUTTON_LEFT: return "Left Click"
		MOUSE_BUTTON_RIGHT: return "Right Click"
		MOUSE_BUTTON_MIDDLE: return "Middle Click"
		MOUSE_BUTTON_WHEEL_UP: return "Wheel Up"
		MOUSE_BUTTON_WHEEL_DOWN: return "Wheel Down"
		_: return "Mouse %d" % idx


# L1 - First Steps: move, jump, double-jump, jump over spikes.
static func _level1() -> TutorialLayout:
	var l := TutorialLayout.new()
	l.level_title = "I  -  First Steps"
	l.spawn = Vector2(48, 168)
	l.solid_rects = [
		Rect2i(0, 12, 16, 6),
		Rect2i(19, 12, 13, 6),
		Rect2i(35, 12, 18, 6),
	]
	l.spikes = [Vector2(648, 176), Vector2(680, 176), Vector2(712, 176)]
	l.checkpoints = [Vector2(336, 168), Vector2(576, 168)]
	l.hints = [
		{"rect": Rect2(16, 96, 210, 96), "text": "Use %s / %s to move" % [key_label("left"), key_label("right")]},
		{"rect": Rect2(232, 96, 150, 96), "text": "Press %s to jump  (press %s again to double jump)" % [key_label("jump"), key_label("jump")]},
		{"rect": Rect2(548, 80, 190, 110), "text": "Jump over the spikes!"},
	]
	l.exit_pos = Vector2(792, 192)
	l.next_scene = "res://levels/tut_2.tscn"
	l.cam_bounds = Rect2(0, -64, 848, 372)
	l.kill_y = 360.0
	return l


# L2 - The Climb (cave): wall-jump up a chimney carved from solid rock.
static func _level2() -> TutorialLayout:
	var l := TutorialLayout.new()
	l.level_title = "II  -  The Climb"
	l.fill_rect = Rect2i(0, 0, 20, 22)
	l.carve_rects = [
		Rect2i(2, 16, 6, 4),    # bottom chamber (start)
		Rect2i(4, 3, 3, 14),    # chimney shaft (walls at x3 & x7)
		Rect2i(4, 1, 12, 3),    # top room -> exit
	]
	l.spawn = Vector2(56, 304)
	l.checkpoints = [Vector2(96, 56)]
	l.hints = [
		{"rect": Rect2(24, 256, 132, 80), "text": "Jump at a wall to cling, then press %s to leap off. Alternate walls to climb!" % key_label("jump")},
	]
	l.exit_pos = Vector2(224, 64)
	l.next_scene = "res://levels/tut_3.tscn"
	l.cam_bounds = Rect2(0, 0, 320, 352)
	l.kill_y = 600.0
	return l


# L3 - Momentum (cave): dash across a pit through a low tunnel, then past a saw.
static func _level3() -> TutorialLayout:
	var l := TutorialLayout.new()
	l.level_title = "III  -  Momentum"
	l.fill_rect = Rect2i(0, 0, 40, 21)
	l.carve_rects = [
		Rect2i(1, 7, 12, 7),    # left room (start)
		Rect2i(13, 12, 7, 2),   # low dash passage (can't jump here)
		Rect2i(14, 14, 5, 5),   # pit beneath the passage
		Rect2i(20, 7, 18, 7),   # right room (saw)
	]
	l.spikes = [Vector2(240, 288), Vector2(272, 288), Vector2(296, 288)]
	l.saws = [
		{"pos": Vector2(448, 200), "big": true, "points": [Vector2(0, -40), Vector2(0, 24)], "speed_scale": 1.0},
	]
	l.spawn = Vector2(48, 206)
	l.checkpoints = [Vector2(336, 206)]
	l.hints = [
		{"rect": Rect2(16, 130, 170, 80), "text": "Press %s to Dash" % key_label("dash")},
		{"rect": Rect2(176, 178, 112, 46), "text": "Dash (%s) across - you can't jump in the low tunnel!" % key_label("dash")},
		{"rect": Rect2(330, 130, 150, 80), "text": "Dash past the saw!"},
	]
	l.exit_pos = Vector2(584, 224)
	l.next_scene = "res://levels/tut_4.tscn"
	l.cam_bounds = Rect2(0, 0, 640, 336)
	l.kill_y = 380.0
	return l


# L4 - The Trial (cave): POGO off a saw, then CRYSTAL DASH a long pit -> Path of Pain.
static func _level4() -> TutorialLayout:
	var l := TutorialLayout.new()
	l.level_title = "IV  -  The Trial"
	l.fill_rect = Rect2i(0, 0, 44, 26)
	l.carve_rects = [
		Rect2i(1, 10, 42, 8),   # long corridor
		Rect2i(12, 18, 6, 6),   # pogo pit (saw to bounce off)
		Rect2i(26, 18, 11, 6),  # crystal-dash pit (wall at x43 stops the dash)
	]
	l.spikes = [
		Vector2(208, 368), Vector2(240, 368), Vector2(272, 368),
		Vector2(432, 368), Vector2(464, 368), Vector2(496, 368), Vector2(528, 368), Vector2(560, 368),
	]
	l.saws = [
		# Pogo target: a slow-bobbing saw in the first pit, at jump-arc height.
		{"pos": Vector2(232, 252), "big": true, "points": [Vector2(0, -6), Vector2(0, 6)], "speed_scale": 0.6},
	]
	l.spawn = Vector2(48, 270)
	l.checkpoints = [Vector2(320, 270), Vector2(608, 270)]
	l.hints = [
		{"rect": Rect2(8, 200, 150, 80), "text": "Combine everything you have learned."},
		{"rect": Rect2(150, 206, 140, 74), "text": "In the air, hold %s + %s to POGO off the saw and bounce across!" % [key_label("down"), key_label("attack")]},
		{"rect": Rect2(360, 206, 160, 74), "text": "Hold %s to charge the Crystal Dash, release to blast across the pit!" % key_label("super_dash")},
	]
	l.exit_pos = Vector2(648, 288)
	l.next_scene = "res://levels/scene_1.tscn"   # THE real Path of Pain begins
	l.cam_bounds = Rect2(0, 0, 704, 416)
	l.kill_y = 460.0
	return l
