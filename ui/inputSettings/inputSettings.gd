extends Control

@export var parent_node : Control
@onready var input_button_scene = preload("res://ui/inputSettings/input_button.tscn")
@onready var action_list = %ActionList


var input_actions = {
	"up": "Move Up",
	"left": "Move Left",
	"down": "Move Down",
	"right": "Move Right",
	"jump": "Jump",
	"attack": "Attack",
	"dash": "Dash",
	"super_dash": "Crystal Dash",
}


var is_remapping = false
var action_to_remap = null
var remapping_button = null

const save_path = "res://keyinput.bin"


func _ready():
	_create_aciton_list()


# Saves the first event of each action. Supports keyboard keys AND mouse buttons.
func save_input():
	var data: Dictionary = {}
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			var e = events[0]
			if e is InputEventKey:
				var code = e.physical_keycode if e.physical_keycode != 0 else e.keycode
				data[action] = {"t": "k", "c": code}
			elif e is InputEventMouseButton:
				data[action] = {"t": "m", "c": e.button_index}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))


func load_input():
	if not FileAccess.file_exists(save_path):
		return null
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file == null or file.eof_reached():
		return null
	var current_line = JSON.parse_string(file.get_line())
	if current_line is Dictionary:
		return current_line
	return null


# Just displays the current InputMap. Bindings are applied at startup by the
# Game autoload and updated live while remapping, so no file re-apply here
# (re-applying from a partial file is what used to wipe Dash / Crystal Dash).
func _create_aciton_list():
	for item in action_list.get_children():
		item.queue_free()
	# Cancel any in-progress remap so we never keep a freed button reference.
	is_remapping = false
	action_to_remap = null
	remapping_button = null

	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")

		action_label.text = input_actions[action]

		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""

		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func reset():
	InputMap.load_from_project_settings()
	_create_aciton_list()


func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press a Key or Mouse Button"


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Game.game_paused == true or (get_tree().get_current_scene().get_name() == "StartScene" and not "second_menu" in parent_node):
			parent_node.show()
			hide()
			save_input()
			if parent_node.get("second_menu"):
				await get_tree().process_frame
				parent_node.second_menu = false

	if is_remapping:
		if event is InputEventKey or (event is InputEventMouseButton and event.pressed):
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			# Consume the event so the key/click doesn't also activate a focused
			# button (this is why binding Space needed the hold + Accept workaround).
			get_viewport().set_input_as_handled()


func _update_action_list(button, event):
	if not is_instance_valid(button):
		return
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed():
	reset()


func _on_accept_button_pressed():
	parent_node.show()
	hide()
	save_input()
	if parent_node.get("second_menu"):
		await get_tree().process_frame
		parent_node.second_menu = false
