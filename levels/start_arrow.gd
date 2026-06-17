extends Node2D

## A small bobbing "Go Up!" arrow shown at the start of the final level, since
## the player must climb upward immediately (this was confusing without a cue).

func _ready():
	z_index = 50

	var label := Label.new()
	label.text = "Go Up!"
	label.add_theme_font_override("font", preload("res://assets/fonts/PixeloidSansBold-PKnYd.ttf"))
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.92, 0.92, 1.0))
	label.add_theme_color_override("font_outline_color", Color(0.05, 0.05, 0.08))
	label.add_theme_constant_override("outline_size", 4)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size = Vector2(80, 16)
	label.position = Vector2(-40, -34)
	add_child(label)

	var arrow := Polygon2D.new()
	arrow.polygon = PackedVector2Array([
		Vector2(0, -16), Vector2(-9, -2), Vector2(-3.5, -2),
		Vector2(-3.5, 14), Vector2(3.5, 14), Vector2(3.5, -2), Vector2(9, -2),
	])
	arrow.color = Color(0.95, 0.95, 1.0)
	add_child(arrow)

	var tw := create_tween().set_loops()
	tw.tween_property(arrow, "position:y", -8.0, 0.5).from(0.0).set_trans(Tween.TRANS_SINE)
	tw.tween_property(arrow, "position:y", 0.0, 0.5).set_trans(Tween.TRANS_SINE)
