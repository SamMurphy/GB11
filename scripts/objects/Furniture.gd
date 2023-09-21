extends StaticBody2D

@export var velocity : Vector2

@onready var movement = get_node("Movement")
@onready var anim = get_node("AnimationPlayer")

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("front")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _entered_area():
	pass
	#anim.play("active")
	
func _rotate(clockwise : bool = true):
	if clockwise:
		match anim.get_assigned_animation():
			"front":
				anim.play("left")
			"left":
				anim.play("back")
			"back":
				anim.play("right")
			"right":
				anim.play("front")
	else:
		match anim.get_assigned_animation():
			"front":
				anim.play("right")
			"right":
				anim.play("back")
			"back":
				anim.play("left")
			"left":
				anim.play("front")

func _push(direction : Vector2):
	if direction.x < 0:
		movement._move_left()
	elif direction.x > 0:
		movement._move_right()
	elif direction.y < 0:
		movement._move_down()
	elif direction.y > 0:
		movement._move_up() 
