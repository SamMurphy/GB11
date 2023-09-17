extends CharacterBody2D

const SPEED = 150.0
const STEP_DISTANCE = 16
const STEP_OFFSET = 8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var targetPosition
var lastSafeTarget

@onready var anim = get_node("AnimationPlayer")


func _ready():
	anim.play("idle")
	targetPosition = Vector2(40, 40)
	lastSafeTarget = targetPosition

func _physics_process(delta):
	
	velocity = Vector2(0, 0)
	
	if targetPosition == position:
		var xDirection = Input.get_axis("DPad_left", "DPad_right")
		var yDirection = Input.get_axis("DPad_up", "DPad_down")
		
		if xDirection:
			targetPosition.x = position.x + (xDirection * STEP_DISTANCE)
			if xDirection == -1:
				get_node("sprite").flip_h = true
			elif xDirection == 1:
				get_node("sprite").flip_h = false
		elif yDirection:
			targetPosition.y = position.y + (yDirection * STEP_DISTANCE)
	
	if targetPosition.x < position.x:
		velocity.x = -1
	elif targetPosition.x > position.x:
		velocity.x = 1
	elif targetPosition.y < position.y:
		velocity.y = -1
	elif targetPosition.y > position.y:
		velocity.y = 1
	
	if velocity.x || velocity.y:
		anim.play("run")
	else:
		anim.play("idle")
	
	velocity *= SPEED
	
	var currentPos = position
	var currentVel = velocity
	var diffVector = targetPosition - position
	
	if diffVector.abs().x < 1:
		position.x = targetPosition.x
	if diffVector.abs().y < 1:
		position.y = targetPosition.y
	
	if diffVector.length() <= 1:
		position = targetPosition
		lastSafeTarget = targetPosition
	else:
		var col = move_and_collide(velocity * delta)
		if col:
			targetPosition = lastSafeTarget
