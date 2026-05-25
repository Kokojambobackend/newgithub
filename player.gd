extends CharacterBody3D

var speed = 5.0
var jump_velocity = 4.5
var mouse_sens = 0.002

@onready var camera = $Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sens)
		camera.rotate_x(-event.relative.y * mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Прыжок на пробел (KEY_SPACE)
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = jump_velocity

	# Создаем вектор движения на основе физических клавиш WASD
	var input_dir = Vector2.ZERO
	
	if Input.is_key_pressed(KEY_A): # Влево
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_D): # Вправо
		input_dir.x += 1
	if Input.is_key_pressed(KEY_W): # Вперед
		input_dir.y -= 1
	if Input.is_key_pressed(KEY_S): # Назад
		input_dir.y += 1

	# Считаем направление взгляда камеры, чтобы персонаж шел туда, куда смотрит
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
