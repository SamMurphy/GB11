extends CharacterBody2D

const SPEED = -60.0

@onready var sprite = get_node("AnimatedSprite2D")

func _ready():
	velocity.x = SPEED
	sprite.play("default")

func _physics_process(delta):
	move_and_slide()
