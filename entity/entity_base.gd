extends CharacterBody2D

@export var hp_max: int = 100
@export var hp: int = hp_max
@export var defense: int = 0

@export var SPEED: int = 75

@onready var sprite = $Sprite2D
@onready var collShape = $CollisionShape2D
@onready var hurtbox = $hurtbox


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move()

func move():
	move_and_slide()

func death():
	queue_free()

func recieve_damage(base_damage: int):
	var full_damage = base_damage
	full_damage -= defense
	
	self.hp -= full_damage
	print(name + " recieved " + str(full_damage) + " damage")
	
func _on_hurtbox_area_entered(hitbox):
	recieve_damage(hitbox.damage)
