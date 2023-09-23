extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement

var currentFurniture : Node2D

var spawn_point

var inDialogue = false

@onready var anim = get_node("AnimationPlayer")
@onready var interact = get_node("DialogueInteraction").get_node("CanvasLayer").get_node("BoxOfWords")
@onready var endGameInteract = get_node("EndDayInteraction").get_node("CanvasLayer").get_node("BoxOfWords")

func on_dialogue_finish():
	inDialogue = false

func on_end_day_dialog_finish(is_day_ended : bool):
	if is_day_ended:
		#trigger end day on level
		position = spawn_point
		movement.targetPosition = spawn_point
		get_parent()._load_next_stage()
		return

func _ready():
	anim.play("idle")
	movement = get_node("Movement")
	interact.dialogue_finished.connect(on_dialogue_finish)
	endGameInteract.dialogue_finished.connect(on_dialogue_finish)
	endGameInteract.choice.connect(on_end_day_dialog_finish)
	spawn_point = position

func _physics_process(delta):
	
	var xDirection = Input.get_axis("DPad_left", "DPad_right")
	var yDirection = Input.get_axis("DPad_up", "DPad_down")
	
	if (inDialogue):
		return
	
	if xDirection != 0 || yDirection != 0:
		if Input.is_action_pressed("A") && is_instance_valid(currentFurniture):
			currentFurniture._push(Vector2(xDirection, yDirection))
	elif Input.is_action_just_pressed("A") && is_instance_valid(currentFurniture) && !inDialogue:
		currentFurniture._rotate()
	
	if Input.is_action_just_pressed("B") && is_instance_valid(currentFurniture):
		inDialogue = true
		if currentFurniture.is_end_game_object:
			currentFurniture.endGameDialogue()
		else:
			currentFurniture.activateDialogue()
		
	
	# Cast a ray to make sure there isn't anything in front of us	
	var spaceState = get_world_2d().direct_space_state
	var rayLength = (movement._get_step_distance() / 2.0) + 1.0
	var rayDirection = Vector2(xDirection, yDirection) * rayLength
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + rayDirection)
	query.exclude = [self]
	# if this is empty then there is nothing in front of us
	var result = spaceState.intersect_ray(query)
	
	# Movement
	if result.is_empty():
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
	
	# Animation - this also changes where the object dectector is
	if xDirection <= -1:
		anim.play("walk_left")
	elif xDirection >= 1:
		anim.play("walk_right")
	elif yDirection <= -1:
		anim.play("walk_up")
	elif yDirection >= 1:
		anim.play("walk_down")
	elif velocity.y == 0 && velocity.x == 0:
		anim.play("idle")
	else:
		anim.play("idle")


func _on_object_detector_entered(body):
	if body.is_in_group("furniture"):
		currentFurniture = body

func _on_object_detector_exited(body):
	if is_instance_valid(currentFurniture):
		if body == currentFurniture:
			currentFurniture = null
