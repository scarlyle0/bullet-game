extends CharacterBody2D

@export var hp_max: int = 100
@export var hp: int = hp_max
@export var defense: int = 0

@export var SPEED: int = 75

@onready var sprite = $Sprite2D
@onready var collShape = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move()

func move():
	move_and_slide()

func death():
	queue_free()
