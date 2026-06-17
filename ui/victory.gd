extends Control

## End-of-game screen shown after completing the Path of Pain. Gives the run
## closure (deaths count) and a way back to the menu.

const FONT_BOLD := preload("res://assets/fonts/PixeloidSansBold-PKnYd.ttf")
const FONT := preload("res://assets/fonts/PixeloidSans-mLxMm.ttf")

var _done := false

func _ready():
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.04, 0.06)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var vb := VBoxContainer.new()
	vb.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_theme_constant_override("separation", 16)
	add_child(vb)

	vb.add_child(_label("PATH OF HOLLOWNESS", FONT_BOLD, 56))
	vb.add_child(_label("Complete", FONT, 30))
	vb.add_child(_label("Deaths: %d" % Game.hurt_times, FONT, 24))
	vb.add_child(_label("Press Z or click to return to the menu", FONT, 18))
	var credit := _label("A Godot Demo Made by Sew Ethan\nHollow Knight (C) Team Cherry.", FONT, 12)
	credit.modulate.a = 0.55
	vb.add_child(credit)

	SoundPlayer.play_music(SoundPlayer.white_palace)
	LevelTransition.fade_out()

func _label(text: String, font: Font, size: int) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_override("font", font)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", Color(0.88, 0.88, 0.93))
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l

func _unhandled_input(event):
	if _done:
		return
	if event.is_action_pressed("jump") or (event is InputEventMouseButton and event.pressed):
		_done = true
		var tree := get_tree()
		await LevelTransition.fade_in()
		Game.portal_name = "__none__"
		tree.change_scene_to_file("res://levels/start_scene.tscn")
		LevelTransition.fade_out()
