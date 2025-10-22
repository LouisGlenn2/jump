extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var mouse_sensitivity := 0.003
var pitch := 0.0
var is_paused := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Cache le menu pause au démarrage
	$PauseMenu.visible = false

	# Connecte le bouton QuitButton
	var quit_button = $PauseMenu/Panel/VBoxContainer/QuitButton
	quit_button.pressed.connect(_on_quit_pressed)

	# Assure que le Panel continue à fonctionner en pause
	$PauseMenu/Panel.pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	if event is InputEventMouseMotion and not is_paused:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))
		$Pivot.rotation.x = pitch

	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()

func _physics_process(delta):
	if is_paused:
		return

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _toggle_pause():
	is_paused = not is_paused
	get_tree().paused = is_paused
	$PauseMenu.visible = is_paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if is_paused else Input.MOUSE_MODE_CAPTURED)

func _on_quit_pressed():
	print("Quit button pressed!")
	get_tree().quit()
