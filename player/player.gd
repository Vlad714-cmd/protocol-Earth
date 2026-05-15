extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

@onready var camera = $Camera3D

func _ready():
	# Примусово скидаємо масштаб, щоб уникнути помилок Jolt
	transform.basis = transform.basis.orthonormalized()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	# Перевірка: чи працює функція взагалі?
	# print("Фізика працює!") 

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	
	# Перевірка: чи бачить Godot твої натискання клавіш?		
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
func _input(event):
	if event.is_action_pressed("esc"): 
		get_tree().quit()
