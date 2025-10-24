extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var temps:float = 0

func _physics_process(delta: float) -> void:
	rotate_x(cos(temps)/30.0)
	temps += 0.1
