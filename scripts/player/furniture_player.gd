extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement

var currentFurniture : Node2D

@onready var anim = get_node("AnimationPlayer")


func _ready():
	anim.play("idle")
	movement = get_node("Movement")

func _physics_process(delta):
	
	var xDirection = Input.get_axis("DPad_left", "DPad_right")
	var yDirection = Input.get_axis("DPad_up", "DPad_down")
	
	if Input.is_action_pressed("A") && is_instance_valid(currentFurniture):
		currentFurniture._push(Vector2(xDirection, yDirection))		
#
		
	if Input.is_action_just_pressed("B") && is_instance_valid(currentFurniture):
		currentFurniture.activateDialogue()
		
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
	
	if velocity.x < 0:
		anim.play("walk_left")
	elif velocity.x > 0:
		anim.play("walk_right")
	elif velocity.y < 0:
		anim.play("walk_down")
	elif velocity.y > 0:
		anim.play("walk_up")
	else:
		anim.play("idle")


func _on_object_detector_entered(body):
	if body.is_in_group("furniture"):
		currentFurniture = body

func _on_object_detector_exited(body):
	if is_instance_valid(currentFurniture):
		if body == currentFurniture:
			currentFurniture = null
