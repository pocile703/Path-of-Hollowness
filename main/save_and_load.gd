extends Node

const save_path = "res://savegame.bin"

# Ordered campaign: 4 tutorials, then the authentic Path of Pain run.
# Game.save_scene is a 1-based index into this list (highest level reached).
const ORDER := [
	"res://levels/tut_1.tscn",
	"res://levels/tut_2.tscn",
	"res://levels/tut_3.tscn",
	"res://levels/tut_4.tscn",
	"res://levels/scene_1.tscn",
	"res://levels/scene_2.tscn",
	"res://levels/scene_3.tscn",
	"res://levels/scene_4.tscn",
]

func path_for(idx: int) -> String:
	var i := clampi(idx, 1, ORDER.size())
	return ORDER[i - 1]

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var data: Dictionary = {
		"hurt_times": Game.hurt_times,
		"save_scene": Game.save_scene,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func load_game():
	var file = FileAccess.open(save_path, FileAccess.READ)
	if FileAccess.file_exists(save_path):
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.hurt_times = current_line["hurt_times"]
				Game.save_scene = current_line["save_scene"]
