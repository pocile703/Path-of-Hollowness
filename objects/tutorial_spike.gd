extends Area2D

## Static spike hazard for the tutorial levels. Touching it respawns the player
## at the last checkpoint (same effect as the saws). One Area2D holds a
## CollisionShape2D per spike; visuals are separate Sprite2D nodes.

func _on_body_entered(body):
	if body.name == "player":
		body.respawn()
		body.hurt_pos = global_position
