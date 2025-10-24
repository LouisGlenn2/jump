extends Area3D

@export var activated := false

func _on_body_entered(body):
	if body.is_in_group("player"):  # Le joueur doit être dans ce groupe
		body.respawn_position = global_position
		if not activated:
			activated = true
			print("Checkpoint activé :", global_position)
