extends "res://entity/entity_base.gd"

var BULLET = preload("res://projectile/projectile.tscn")

@onready var attackTimer = $AttackTimer

@export var speed: float = 450.0

@export var rotation_speed := 2 # Adjust this for faster/slower rotation


func _ready():
	pass # Replace with function body.

func _process(delta):
	move_control()
	if Input.is_action_pressed("action_attack") and attackTimer.is_stopped():
		var bullet_direction = self.position.direction_to(get_global_mouse_position())
		shoot(bullet_direction)
	
	# Rotate left when Q is pressed
	if Input.is_action_pressed("rotate_left"):
		rotation -= rotation_speed * delta

	# Rotate right when E is pressed
	if Input.is_action_pressed("rotate_right"):
		rotation += rotation_speed * delta


func shoot(bullet_direction : Vector2):
	if BULLET:
		var bullet = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.position = self.position
		
		var bullet_rotation = bullet_direction.angle()
		bullet.rotation = bullet_rotation
		
	attackTimer.start()


func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	# Calculate the movement direction based on the rotation
	var movement_direction = Vector2(input_dir.x, input_dir.y).rotated(rotation)
	velocity = movement_direction.normalized() * speed

func move_control():
	get_input()
	move()
