extends "res://entity_base/entity_base.gd"

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
	var velocity: Vector2 = Vector2.ZERO

	# Check for WASD input
	if Input.is_action_pressed("right"):  # Right (D key)
		velocity.x += 1
	if Input.is_action_pressed("left"):   # Left (A key)
		velocity.x -= 1
	if Input.is_action_pressed("down"):   # Down (S key)
		velocity.y += 1
	if Input.is_action_pressed("up"):     # Up (W key)
		velocity.y -= 1

	# Normalize the velocity to prevent faster diagonal movement
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed
		position += velocity * delta  # Move the entity
