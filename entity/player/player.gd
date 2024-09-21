extends "res://entity/entity_base.gd"

var BULLET = preload("res://projectile/projectile.tscn")

@onready var attackTimer = $AttackTimer

@export var speed: float = 450.0


func _ready():
	pass # Replace with function body.

func _process(delta):
	move()
	move_control(delta)
	if Input.is_action_pressed("action_attack") and attackTimer.is_stopped():
		var bullet_direction = self.position.direction_to(get_global_mouse_position())
		shoot(bullet_direction)

func shoot(bullet_direction : Vector2):
	if BULLET:
		var bullet = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.position = self.position
		
		var bullet_rotation = bullet_direction.angle()
		bullet.rotation = bullet_rotation
		
	attackTimer.start()

func move_control(delta):
	var input_velocity: Vector2 = Vector2.ZERO

	# Check for WASD input
	if Input.is_action_pressed("right"):  # Right (D key)
		input_velocity.x += 1
	if Input.is_action_pressed("left"):   # Left (A key)
		input_velocity.x -= 1
	if Input.is_action_pressed("down"):   # Down (S key)
		input_velocity.y += 1
	if Input.is_action_pressed("up"):     # Up (W key)
		input_velocity.y -= 1

	# Normalize the velocity to prevent faster diagonal movement
	if input_velocity != Vector2.ZERO:
		input_velocity = input_velocity.normalized() * speed
		position += input_velocity * delta  # Move the entity
