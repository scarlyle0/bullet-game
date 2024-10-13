extends "res://entity/entity_base.gd"

var BULLET = preload("res://projectile/projectile.tscn")

@onready var attackTimer = $AttackTimer

@export var speed: float = 450.0


func _ready():
	pass # Replace with function body.

func _process(delta):
	move_control()
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


func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed

func move_control():
	get_input()
	move()
