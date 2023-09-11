extends CharacterBody3D

var Velocidad
const VEL_CAMINAR = 6.0
const VEL_CORRER = 10.0
const SPEED = 6.0
const JUMP_VELOCITY = 5.0
const SENSITIVITY = 0.03

# Constantes para el balanceo de cámara.
const balanceo_frec = 2.0
const balanceo_ampl = 0.08
var balanceo_long = 0.0

# Constantes para FOV dinámico.
const FOV_BASE = 75.0
const FOV_CAMBIO = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var Cabeza = $Cabeza
@onready var Camara = $Cabeza/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		Cabeza.rotate_y(-event.relative.x * SENSITIVITY)
		Camara.rotate_x(-event.relative.y * SENSITIVITY)
		Camara.rotation.x = clamp(Camara.rotation.x, deg_to_rad(-60), deg_to_rad(80))
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Saltar") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Controla el sprint.
	if Input.is_action_pressed("Correr"):
		Velocidad = VEL_CORRER
	else:
		Velocidad = VEL_CAMINAR

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Izquierda", "Derecha", "Adelante", "Atras")
	var direction = (Cabeza.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * Velocidad
			velocity.z = direction.z * Velocidad
		else:
			velocity.x = lerp(velocity.x, direction.x * Velocidad, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * Velocidad, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * Velocidad, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * Velocidad, delta * 3.0)
	
	# Balanceo de cámara
	balanceo_long += delta * velocity.length() * float(is_on_floor())
	Camara.transform.origin = _balCam(balanceo_long)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, VEL_CORRER * 2)
	var targed_fov = FOV_BASE + FOV_CAMBIO * velocity_clamped
	Camara.fov = lerp(Camara.fov, targed_fov, delta * 8.0)

	move_and_slide()

func _balCam(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * balanceo_frec) * balanceo_ampl
	pos.x = cos(time * balanceo_frec / 2) * balanceo_ampl 
	return pos
	
