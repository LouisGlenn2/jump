extends MeshInstance3D

@export var checkpoint_color_active = Color.GREEN
@export var checkpoint_color_inactive = Color.WHITE

var activated = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("update_checkpoint") and not activated:
		body.update_checkpoint(global_position)
		activated = true
		activate_visual()

func activate_visual():
	# Change la couleur du MeshInstance3D enfant si présent
	for child in get_children():
		if child is MeshInstance3D:
			var material = child.get_active_material(0)
			if material:
				material.albedo_color = checkpoint_color_active
