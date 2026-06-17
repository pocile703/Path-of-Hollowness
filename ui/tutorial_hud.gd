extends CanvasLayer

## On-screen teaching UI for the tutorial levels: a title card that fades in/out
## on entry and a contextual hint line shown while the player stands in a hint
## zone. Uses the original game's Pixeloid fonts.

const FONT_BOLD := preload("res://assets/fonts/PixeloidSansBold-PKnYd.ttf")
const FONT := preload("res://assets/fonts/PixeloidSans-mLxMm.ttf")
const TEXT_COLOR := Color(0.86, 0.86, 0.92)

var title_label: Label
var hint_label: Label

func _ready():
	layer = 20

	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	title_label = _make_label(FONT_BOLD, 40)
	title_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title_label.offset_top = 48
	title_label.offset_bottom = 160
	title_label.modulate.a = 0.0
	root.add_child(title_label)

	hint_label = _make_label(FONT, 24)
	hint_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	hint_label.offset_top = -120
	hint_label.offset_bottom = -48
	hint_label.modulate.a = 0.0
	root.add_child(hint_label)

func _make_label(font: Font, size: int) -> Label:
	var l := Label.new()
	l.add_theme_font_override("font", font)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", TEXT_COLOR)
	l.add_theme_color_override("font_outline_color", Color(0.05, 0.05, 0.07))
	l.add_theme_constant_override("outline_size", 8)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l

func show_title(text: String) -> void:
	title_label.text = text
	title_label.modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(title_label, "modulate:a", 1.0, 1.0)
	tw.tween_interval(2.5)
	tw.tween_property(title_label, "modulate:a", 0.0, 1.5)

func set_hint(text: String) -> void:
	hint_label.text = text
	var tw := create_tween()
	tw.tween_property(hint_label, "modulate:a", 1.0, 0.3)

func clear_hint() -> void:
	var tw := create_tween()
	tw.tween_property(hint_label, "modulate:a", 0.0, 0.3)
