extends CharacterBody3D

var speed = 5.0
var jump_velocity = 4.5
var mouse_sens = 0.002
var hp = 100
var dead = false
var damage = 25

@onready var camera = $Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sens)
		camera.rotate_x(-event.relative.y * mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	if event.is_action_pressed("attack"):
		attack()
		
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Vector2.ZERO
	
	if Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_D):
		input_dir.x += 1
	if Input.is_key_pressed(KEY_W):
		input_dir.y -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.y += 1

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _process(delta):
	if hp <= 0 and not dead:
		die()

func die():
	dead = true
	print("Игрок умер")
	queue_free()
	
	#АТАКА
func attack():

	var enemies = get_tree().get_nodes_in_group("enemy")

	for enemy in enemies:

		var distance = global_position.distance_to(enemy.global_position)

		if distance < 3:
			enemy.take_damage(damage)
	
