extends CharacterBody3D

# --- Variables de déplacement ---
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var mouse_sensitivity := 0.003
var pitch := 0.0
var is_paused := false

# --- Checkpoint / Respawn ---
var respawn_position: Vector3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Sauvegarde la position initiale comme premier checkpoint
	respawn_position = global_position

func _input(event):
	if event is InputEventMouseMotion and not is_paused:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))
		$Pivot.rotation.x = pitch

func _physics_process(delta):
	if is_paused:
		return
	
	# --- Gravité ---
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# --- Saut ---
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# --- Déplacement ---
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	# --- Respawn si on tombe trop bas ---
	if global_position.y < -20.0:
		respawn()

# --- Fonction de respawn ---
func respawn():
	global_position = respawn_position
	velocity = Vector3.ZERO

# --- Fonction pour mettre à jour le checkpoint (appelée par les CheckPoint) ---
func update_checkpoint(new_position: Vector3):
	respawn_position = new_position
	print("✓ Nouveau checkpoint enregistré : ", new_position)
