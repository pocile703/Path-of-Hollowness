extends Control

@export var parent_node : Control
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		if Game.game_paused == true or (get_tree().get_current_scene().get_name() == "StartScene" and not "second_menu" in parent_node):
			parent_node.show()
			hide()
			if parent_node.get("second_menu"):
				await get_tree().process_frame
				parent_node.second_menu = false
			
	
