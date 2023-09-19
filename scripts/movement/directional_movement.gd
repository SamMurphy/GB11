extends Node

# Has defaults but can be overriden by individual classes
const STEP_DISTANCE = 16
const STEP_OFFSET = 8

#
var speed = 150.0
var targetPosition
var lastSafeTarget

var character

# Called when the node enters the scene tree for the first time.
func _setup(inCharacter : CharacterBody2D):
	character = inCharacter
	
	# Set the position to the closest square in the grid first
	var xCoordinate: int = (character.position.x / STEP_DISTANCE)
	var yCoordinate: int = (character.position.y / STEP_DISTANCE)
	character.position.x = (STEP_DISTANCE * xCoordinate) + STEP_OFFSET
	character.position.y = (STEP_DISTANCE * yCoordinate) + STEP_OFFSET
	
	targetPosition = character.position
	lastSafeTarget = targetPosition

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	character.velocity = Vector2(0, 0)
	
	if targetPosition.x < character.position.x:
		character.velocity.x = -1
	elif targetPosition.x > character.position.x:
		character.velocity.x = 1
	elif targetPosition.y < character.position.y:
		character.velocity.y = -1
	elif targetPosition.y > character.position.y:
		character.velocity.y = 1
		
	character.velocity *= speed
		
	var diffVector = targetPosition - character.position
	
	if diffVector.abs().x < 1:
		character.position.x = targetPosition.x
	if diffVector.abs().y < 1:
		character.position.y = targetPosition.y
	
	if diffVector.length() <= 1:
		character.position = targetPosition
		lastSafeTarget = targetPosition
	else:
		var col = character.move_and_collide(character.velocity * delta)
		if col:
			targetPosition = lastSafeTarget

# This will only work if we've already reached our target
func _add_relative_vec_to_target(inPos : Vector2):
	
	if character.position != targetPosition:
		return
	
	targetPosition += inPos

func _move_left():
	_add_relative_vec_to_target(Vector2(-STEP_DISTANCE, 0.0))

func _move_right():
	_add_relative_vec_to_target(Vector2(STEP_DISTANCE, 0.0))

func _move_up():
	_add_relative_vec_to_target(Vector2(0.0, STEP_DISTANCE))

func _move_down():
	_add_relative_vec_to_target(Vector2(0.0, -STEP_DISTANCE))
