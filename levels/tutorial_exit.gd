extends Area2D

## Self-contained level exit for the tutorial levels. Avoids the original's
## bidirectional portal-name convention: it simply fades out, changes scene,
## and fades back in (mirroring start_scene.gd's New Game flow).

@export var target_scene: String = ""

var _used: bool = false

func _on_body_entered(body):
	if _used or body.name != "player":
		return
	_used = true
	var tree := get_tree()
	SoundPlayer.play_sound(SoundPlayer.ui_button_confirm)
	await LevelTransition.fade_in()
	# Sentinel so authentic level_scene.gd won't try to match a return portal.
	Game.portal_name = "__none__"
	tree.change_scene_to_file(target_scene)
	LevelTransition.fade_out()
