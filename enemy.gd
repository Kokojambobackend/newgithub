extends CharacterBody3D


var hp = 100
var damage = 10


@export var speed := 3.0
@export var attack_range := 2.0

var player
var can_attack = true


	

func _ready():
	player = get_node("/root/Main/Player")

func _physics_process(delta):
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	# Если далеко — идём к игроку
	if distance > attack_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

	# Если близко — атакуем
	else:
		attack()

func attack():
	if not can_attack:
		return

	can_attack = false

	player.hp -= damage
	print("Игрок получил урон")

	await get_tree().create_timer(1.5).timeout

	can_attack = true
	
	
func take_damage(amount):
	hp -= amount
	
	print("Враг получил урон")
	
	if hp <= 0:
		die()
		
func die():
	print("Враг умер")
	queue_free()
	
