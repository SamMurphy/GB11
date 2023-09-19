extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement

@onready var anim = get_node("AnimationPlayer")


func _ready():
	anim.play("idle")
	movement = get_node("Movement")

func _physics_process(delta):
	
	var xDirection = Input.get_axis("DPad_left", "DPad_right")
	var yDirection = Input.get_axis("DPad_up", "DPad_down")
		
	if xDirection:
		if xDirection == -1:
			movement._move_left()
			get_node("sprite").flip_h = true
		elif xDirection == 1:
			movement._move_right()
			get_node("sprite").flip_h = false
	elif yDirection:
		if yDirection == 1:
			movement._move_up()
		else:
			movement._move_down()
	
	if velocity.x || velocity.y:
		anim.play("run")
	else:
		anim.play("idle")
