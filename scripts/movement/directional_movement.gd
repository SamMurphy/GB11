extends Node

# Has defaults but can be overriden by individual classes
const STEP_DISTANCE = 16
const STEP_OFFSET = 8

#
@export var speed = 150.0
var targetPosition
var lastSafeTarget

var physicsBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	physicsBody2D = get_parent()
	
	# Set the position to the closest square in the grid first
	var xCoordinate: int = (physicsBody2D.position.x / STEP_DISTANCE)
	var yCoordinate: int = (physicsBody2D.position.y / STEP_DISTANCE)
	physicsBody2D.position.x = (STEP_DISTANCE * xCoordinate) + STEP_OFFSET
	physicsBody2D.position.y = (STEP_DISTANCE * yCoordinate) + STEP_OFFSET
	
	targetPosition = physicsBody2D.position
	lastSafeTarget = targetPosition

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	physicsBody2D.velocity = Vector2(0, 0)
	
	if targetPosition.x < physicsBody2D.position.x:
		physicsBody2D.velocity.x = -1
	elif targetPosition.x > physicsBody2D.position.x:
		physicsBody2D.velocity.x = 1
	elif targetPosition.y < physicsBody2D.position.y:
		physicsBody2D.velocity.y = -1
	elif targetPosition.y > physicsBody2D.position.y:
		physicsBody2D.velocity.y = 1
		
	physicsBody2D.velocity *= speed
		
	var diffVector = targetPosition - physicsBody2D.position
	
	if diffVector.abs().x < 1:
		physicsBody2D.position.x = targetPosition.x
	if diffVector.abs().y < 1:
		physicsBody2D.position.y = targetPosition.y
	
	if diffVector.length() <= 1:
		physicsBody2D.position = targetPosition
		lastSafeTarget = targetPosition
	else:
		var col = physicsBody2D.move_and_collide(physicsBody2D.velocity * delta)
		if col:
			var resetPos = true
			if col.get_collider().name == "player" && physicsBody2D.is_in_group("furniture"):
				resetPos = false
			if resetPos:
				targetPosition = lastSafeTarget

# This will only work if we've already reached our target
func _add_relative_vec_to_target(inPos : Vector2):
	
	if physicsBody2D.position != targetPosition:
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
	
func _is_at_target_position() -> bool:
	if physicsBody2D.position == targetPosition:
		return true
	else:
		return false
		
func _get_step_distance() -> float:
	return STEP_DISTANCE
