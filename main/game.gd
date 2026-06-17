extends Node

# Must match inputSettings.gd's save_path.
const INPUT_SAVE_PATH := "res://keyinput.bin"

@onready var pause_menu = $CanvasLayer/PauseMenu


var hurt_times : int = 0
var save_scene : int = 0

var portal_name : String
var can_wrap : bool = true
var instant_death : bool = true
var zoom : Vector2 = Vector2(3, 3)

signal toggle_game_paused(is_paused : bool)

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)


func _input(event : InputEvent):
	if not pause_menu.second_menu:
		if event.is_action_pressed("ui_cancel") and get_tree().get_current_scene().get_name() != "StartScene":
			game_paused = !game_paused


func _process(delta):
	if Game.can_wrap == false:
		await get_tree().create_timer(1).timeout
		Game.can_wrap = true


func update_zoom():
	#print("zoomchanged")
	var window_size = get_window().size
	zoom.x = window_size.x / 384.0
	zoom.y = window_size.y / 216.0
	if zoom.x > zoom.y:
		zoom.y = zoom.x
	else:
		zoom.x = zoom.y


func _ready():
	get_window().size_changed.connect(update_zoom)
	apply_saved_input()


func apply_saved_input():
	# Apply the player's saved key bindings at startup so custom controls persist
	# across launches (previously they were only re-applied when the settings
	# menu was opened).
	if not FileAccess.file_exists(INPUT_SAVE_PATH):
		return
	var file = FileAccess.open(INPUT_SAVE_PATH, FileAccess.READ)
	if file == null or file.eof_reached():
		return
	var data = JSON.parse_string(file.get_line())
	if not (data is Dictionary):
		return
	for action in data:
		if not InputMap.has_action(action):
			continue
		var ev := _input_event_from(data[action])
		if ev != null:
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, ev)


func _input_event_from(entry) -> InputEvent:
	# New format: {"t": "k"|"m", "c": code}.  Old format: bare int keycode.
	if entry is Dictionary:
		var c := int(entry.get("c", 0))
		if c == 0:
			return null
		if entry.get("t", "k") == "m":
			var me := InputEventMouseButton.new()
			me.button_index = c
			return me
		var ke := InputEventKey.new()
		ke.physical_keycode = c
		return ke
	elif entry is float or entry is int:
		var code := int(entry)
		if code == 0:
			return null
		var ke := InputEventKey.new()
		ke.physical_keycode = code
		return ke
	return null


