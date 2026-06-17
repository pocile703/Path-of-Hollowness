extends Node2D

## Builds a tutorial level in code, reusing the original game's assets/systems.
## Rock geometry is painted with the tileset terrain system (autotiled edges);
## L2/L3/L4 use a "fill solid, then carve tunnels" cave model. Spikes are built
## the same way the authentic levels do them: a Sprite2D using the tileset spike
## region plus an Area2D hazard.

@export var level_id: int = 1

const TERRAIN_SET := 0
const ROCK_TERRAIN := 1                       # solid rock terrain (autotiled)
const SPIKE_REGION := Rect2(48, 128, 32, 32)  # spike art in tileset.png (matches scene_4)

const TILESET := preload("res://levels/scene_1.tres")
const TILESET_TEX := preload("res://assets/background/tileset.png")
const PLAYER_SCENE := preload("res://player/player.tscn")
const SAW_BIG := preload("res://objects/moving_chainsaw_path.tscn")
const SAW_SMALL := preload("res://objects/moving_chainsaw_path_small.tscn")
const BG_SCENE := preload("res://levels/bg.tscn")
const CHECKPOINT_SCRIPT := preload("res://objects/Checkpoints.gd")
const SPIKE_SCRIPT := preload("res://objects/tutorial_spike.gd")
const EXIT_SCRIPT := preload("res://levels/tutorial_exit.gd")
const HUD_SCRIPT := preload("res://ui/tutorial_hud.gd")
const GATE_TEX := preload("res://assets/background/gate.png")

var tilemap: TileMap
var player: CharacterBody2D
var hud

func _ready():
	var layout: TutorialLayout = TutorialLayouts.build(level_id)
	_build_background()
	_build_tilemap(layout)
	_build_spikes(layout)
	_build_player(layout)
	_build_camera(layout)
	_build_checkpoints(layout)
	_build_saws(layout)
	_build_hud(layout)
	_build_hint_zones(layout)
	_build_kill_plane(layout)
	_build_exit(layout)
	SoundPlayer.play_music(SoundPlayer.white_palace)
	_track_progress()

func _build_background() -> void:
	var bg = BG_SCENE.instantiate()
	bg.layer = -1
	add_child(bg)

func _build_tilemap(layout: TutorialLayout) -> void:
	tilemap = TileMap.new()
	tilemap.tile_set = TILESET
	add_child(tilemap)
	while tilemap.get_layers_count() < 1:
		tilemap.add_layer(-1)

	var solid := {}
	var fr: Rect2i = layout.fill_rect
	if fr.size.x > 0 and fr.size.y > 0:
		for x in range(fr.position.x, fr.position.x + fr.size.x):
			for y in range(fr.position.y, fr.position.y + fr.size.y):
				solid[Vector2i(x, y)] = true
	for r in layout.solid_rects:
		for x in range(r.position.x, r.position.x + r.size.x):
			for y in range(r.position.y, r.position.y + r.size.y):
				solid[Vector2i(x, y)] = true
	for r in layout.carve_rects:
		for x in range(r.position.x, r.position.x + r.size.x):
			for y in range(r.position.y, r.position.y + r.size.y):
				solid.erase(Vector2i(x, y))

	var rock: Array[Vector2i] = []
	for c in solid:
		rock.append(c)
	if rock.size() > 0:
		tilemap.set_cells_terrain_connect(0, rock, TERRAIN_SET, ROCK_TERRAIN)

# Spikes = visible Sprite2D (tileset spike region) + one Area2D hazard holding a
# CollisionShape2D per spike. Matches how scene_4 builds its spikes.
func _build_spikes(layout: TutorialLayout) -> void:
	if layout.spikes.is_empty():
		return
	var visuals := Node2D.new()
	visuals.name = "spikes"
	add_child(visuals)
	var hazard := SPIKE_SCRIPT.new()  # Area2D + tutorial_spike.gd
	hazard.name = "spike_hazard"
	add_child(hazard)
	for pos in layout.spikes:
		var spr := Sprite2D.new()
		spr.texture = TILESET_TEX
		spr.region_enabled = true
		spr.region_rect = SPIKE_REGION
		spr.position = pos
		visuals.add_child(spr)
		var cs := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = Vector2(26, 22)
		cs.shape = shape
		cs.position = pos + Vector2(0, 3)
		hazard.add_child(cs)
	hazard.body_entered.connect(hazard._on_body_entered)

func _build_player(layout: TutorialLayout) -> void:
	player = PLAYER_SCENE.instantiate()
	player.name = "player"
	player.position = layout.spawn
	player.dir = 1
	add_child(player)

func _build_camera(layout: TutorialLayout) -> void:
	# Reuse the player's own internal Camera2D (already runs Camera2D.gd, so the
	# player states' `camera.shake` calls work). It is disabled in the prefab.
	var cam: Camera2D = player.get_node("Camera2D")
	cam.enabled = true
	cam.camera_limits = null
	cam.limit_left = int(layout.cam_bounds.position.x)
	cam.limit_top = int(layout.cam_bounds.position.y)
	cam.limit_right = int(layout.cam_bounds.position.x + layout.cam_bounds.size.x)
	cam.limit_bottom = int(layout.cam_bounds.position.y + layout.cam_bounds.size.y)
	cam.make_current()
	player.camera = cam

func _build_checkpoints(layout: TutorialLayout) -> void:
	var holder := Node2D.new()
	holder.name = "Checkpoints"
	add_child(holder)
	var positions := [layout.spawn]
	positions.append_array(layout.checkpoints)
	var first: Node = null
	for pos in positions:
		var cp := CHECKPOINT_SCRIPT.new()  # Area2D + Checkpoints.gd (class Checkpoint)
		cp.position = pos
		var cs := CollisionShape2D.new()
		var rect := RectangleShape2D.new()
		rect.size = Vector2(64, 80)
		cs.shape = rect
		cs.position = Vector2(0, -24)
		cp.add_child(cs)
		cp.body_entered.connect(cp._on_body_entered)
		holder.add_child(cp)
		if first == null:
			first = cp
	player.current_checkpoint = first  # safe respawn before any checkpoint is touched

func _build_saws(layout: TutorialLayout) -> void:
	var holder := Node2D.new()
	holder.name = "saws"
	add_child(holder)
	for s in layout.saws:
		var scene: PackedScene = SAW_BIG if s.get("big", true) else SAW_SMALL
		var saw = scene.instantiate()
		saw.position = s.get("pos", Vector2.ZERO)
		var curve := Curve2D.new()
		for p in s.get("points", [Vector2.ZERO, Vector2.ZERO]):
			curve.add_point(p)
		saw.curve = curve
		saw.loop = s.get("loop", false)
		saw.speed = s.get("speed", 2.0)
		saw.speed_scale = s.get("speed_scale", 1.0)
		holder.add_child(saw)

func _build_hud(layout: TutorialLayout) -> void:
	hud = HUD_SCRIPT.new()
	add_child(hud)
	hud.show_title(layout.level_title)

func _build_hint_zones(layout: TutorialLayout) -> void:
	for h in layout.hints:
		var rect: Rect2 = h["rect"]
		var text: String = h["text"]
		var area := Area2D.new()
		area.position = rect.position
		var cs := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = rect.size
		cs.shape = shape
		cs.position = rect.size / 2.0
		area.add_child(cs)
		area.body_entered.connect(func(body):
			if body.name == "player":
				hud.set_hint(text))
		area.body_exited.connect(func(body):
			if body.name == "player":
				hud.clear_hint())
		add_child(area)

func _build_kill_plane(layout: TutorialLayout) -> void:
	var kill := Area2D.new()
	kill.position = Vector2(0, layout.kill_y)
	var cs := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(40000, 64)
	cs.shape = shape
	kill.add_child(cs)
	kill.body_entered.connect(func(body):
		if body.name == "player":
			body.respawn())
	add_child(kill)

func _build_exit(layout: TutorialLayout) -> void:
	var exit := EXIT_SCRIPT.new()  # Area2D + tutorial_exit.gd
	exit.position = layout.exit_pos
	exit.target_scene = layout.next_scene
	var cs := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(40, 96)
	cs.shape = shape
	cs.position = Vector2(0, -40)  # doorway sits above the ground point
	exit.add_child(cs)
	exit.body_entered.connect(exit._on_body_entered)

	var gate := Sprite2D.new()
	gate.texture = GATE_TEX
	gate.offset = Vector2(0, -GATE_TEX.get_height() / 2.0)  # bottom-aligned to ground
	exit.add_child(gate)

	add_child(exit)

func _track_progress() -> void:
	if level_id > Game.save_scene:
		Game.save_scene = level_id
	SaveAndLoad.save_game()
