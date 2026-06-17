extends Area2D

## Win trigger for the end of the final level. Self-contained (builds its own
## collision box) so adding it to a scene is a single node. Placed as a wide
## band across the end region so reaching/falling into the finish counts as a
## win instead of dropping the player back to an earlier checkpoint.

@export var box_size: Vector2 = Vector2(560, 120)

var _done := false

func _ready():
	var cs := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = box_size
	cs.shape = shape
	add_child(cs)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if _done or body.name != "player":
		return
	_done = true
	var tree := get_tree()
	await LevelTransition.fade_in()
	Game.portal_name = "__none__"
	tree.change_scene_to_file("res://ui/victory.tscn")
	LevelTransition.fade_out()
