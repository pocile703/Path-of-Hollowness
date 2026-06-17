extends Node2D

@onready var settings = $CanvasLayer/Settings
@onready var input_settings = $CanvasLayer/inputSettings
@onready var menu = $CanvasLayer/Menu
@onready var camera = $Camera2D
@onready var continue_ = $CanvasLayer/Menu/Panel/VBoxContainer/continue_
@onready var start_game = $CanvasLayer/Menu/Panel/VBoxContainer/start_game
@onready var title = $CanvasLayer/Menu/Title

# Guards the menu buttons so a double-click can't fire two scene changes
# (the second would resume after this node leaves the tree -> null get_tree()).
var _transitioning := false

#var file = FileAccess.open(SaveAndLoad.save_path, FileAccess.READ)
	

func _ready():
	if FileAccess.file_exists(SaveAndLoad.save_path):
		continue_.disabled = false
		start_game.text = "New Game"
	
	LevelTransition.black()
	await get_tree().create_timer(1).timeout
	LevelTransition.fade_out()
	SoundPlayer.play_music(SoundPlayer.white_palace)

func _process(delta):
	# Show NewTitle2.png at its native size, centered horizontally, in the upper
	# area (above the menu buttons).
	var win = get_window().size
	title.position = Vector2(win.x / 2.0, win.y * 0.28)

func _on_quit_game_pressed():
	if _transitioning: return
	_transitioning = true
	var tree := get_tree()
	SoundPlayer.play_sound(SoundPlayer.ui_save)
	LevelTransition.fade_in()
	await LevelTransition.animation_player.animation_finished
	tree.quit()


func _on_start_game_pressed():
	if _transitioning: return
	_transitioning = true
	var tree := get_tree()
	SoundPlayer.play_sound(SoundPlayer.ui_button_confirm)
	# New game: reset progress and begin at the first tutorial.
	Game.save_scene = 0
	Game.hurt_times = 0
	Game.portal_name = "__none__"
	await LevelTransition.fade_in()
	camera.enabled = false
	tree.change_scene_to_file("res://levels/tut_1.tscn")
	LevelTransition.fade_out()



func _on_options_pressed():
	settings.visible = true
	menu.hide()


func _on_continue_pressed():
	if _transitioning: return
	_transitioning = true
	var tree := get_tree()
	SaveAndLoad.load_game()
	SoundPlayer.play_sound(SoundPlayer.ui_button_confirm)
	Game.portal_name = "__none__"
	await LevelTransition.fade_in()
	camera.enabled = false
	var load_scene : String = SaveAndLoad.path_for(Game.save_scene)
	tree.change_scene_to_file(load_scene)
	LevelTransition.fade_out()


func _on_input_pressed():
	input_settings.visible = true
	input_settings._create_aciton_list()
	menu.hide()
