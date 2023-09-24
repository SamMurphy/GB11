extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement

var current_furniture : Node2D

var spawn_point

var inDialogue = false

@onready var anim = get_node("AnimationPlayer")
@onready var interact = get_node("DialogueInteraction").get_node("CanvasLayer").get_node("BoxOfWords")
@onready var endGameInteract = get_node("EndDayInteraction").get_node("CanvasLayer").get_node("BoxOfWords")
var transition_tween

@export var held_time : float = 0.25
var a_press : bool = false
var a_held_timer : float = held_time
var a_held : bool = false
var a_tapped : bool = false
var release_furniture_on_release : bool = false

var pulling : bool = false

func on_dialogue_finish():
	inDialogue = false

func on_end_day_dialog_finish(is_day_ended : bool):
	if is_day_ended:
		#trigger end day on level
		if transition_tween:
			transition_tween.kill() # Abort the previous animation.
		transition_tween = create_tween()
		transition_tween.tween_method(GameGlobals.change_fade_time, 0.0, 1.0, 1.0)#.set_trans(Tween.TRANS_BOUNCE)
		transition_tween.tween_callback(load_next_stage)
		transition_tween.tween_method(GameGlobals.change_fade_time, 1.0, 0.0, 1.0)#.set_trans(Tween.TRANS_BOUNCE
		return

func load_next_stage():
	position = spawn_point   
	movement.targetPosition = spawn_point
	get_parent()._load_next_stage()

func _ready():
	anim.play("idle")
	movement = get_node("Movement")
	interact.dialogue_finished.connect(on_dialogue_finish)
	endGameInteract.dialogue_finished.connect(on_dialogue_finish)
	endGameInteract.choice.connect(on_end_day_dialog_finish)
	spawn_point = position
	
func _input(event):
	if event.is_action_pressed("A"):
		a_press = true
	if event.is_action_released("A"):
		if a_held_timer < held_time && !a_held:
			a_tapped = true
		a_held = false
		a_held_timer = held_time
		a_press = false
		pulling = false
		if release_furniture_on_release && is_instance_valid(current_furniture):
			release_furniture()

func _physics_process(delta):
	
	# Process Input
	if a_press:
		a_held_timer -= delta
	if a_held_timer <= 0:
		a_held = true
	
	var xDirection = Input.get_axis("DPad_left", "DPad_right")
	var yDirection = Input.get_axis("DPad_up", "DPad_down")
	
	if (inDialogue):
		return
		
	# Push / Rotate the furniture
	var just_pushed = false
	if a_held && is_instance_valid(current_furniture):
		just_pushed = handle_furniture_push(Vector2(xDirection, yDirection))
	elif a_tapped && is_instance_valid(current_furniture) && !inDialogue:
		current_furniture._rotate()
	
	# Dialogue interaction
	if Input.is_action_just_pressed("B") && is_instance_valid(current_furniture):
		inDialogue = true
		if current_furniture.is_end_game_object:
			current_furniture.endGameDialogue()
		else:
			current_furniture.activateDialogue()
		
	
	# Cast a ray to make sure there isn't anything in front of us	
	var something_in_front = cast_a_ray(Vector2(xDirection, yDirection))
	
	# Stop the player moving if they're trying to pull the 
	# furniture and it hasn't finished it's timer
	var can_move = true
	if pulling && !just_pushed:
		can_move = false
	
	# Movement
	if !something_in_front && can_move:
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
	
	# reverse the animation if we're pulling the furniture
	if pulling:
		xDirection = -xDirection
		yDirection = -yDirection
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
		
	if a_tapped:
		a_tapped = false


func _on_object_detector_entered(body):
	if body.is_in_group("furniture"):
		if !is_instance_valid(current_furniture):
			current_furniture = body
		elif body == current_furniture:
			release_furniture_on_release = false

func _on_object_detector_exited(body):
	if is_instance_valid(current_furniture):
		if body == current_furniture:
			if a_held:
				release_furniture_on_release = true
			else:
				release_furniture()

## Casts a ray of ray_length from the origin of the player in ray_direction
## Returns wether it hits anything, ignoring the player
func cast_a_ray(ray_direction : Vector2, ray_length : float = 9) -> bool:
	# Cast a ray to make sure there isn't anything in front of us	
	var spaceState = get_world_2d().direct_space_state
	ray_direction = ray_direction * ray_length
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + ray_direction)
	query.exclude = [self]
	# if this is empty then there is nothing in front of us
	var result = spaceState.intersect_ray(query)
	return !result.is_empty()
	
func handle_furniture_push(push_direction : Vector2) -> bool:
	if push_direction == Vector2.ZERO:
		return false

	# Only care about horizonal and vertical directions, ignore diagonals
	if push_direction.x != 0:
		push_direction = Vector2(push_direction.x, 0)
	elif push_direction.y != 0:
		push_direction = Vector2(0, push_direction.y)
	
	# Calc the direction to the furniture
	var furniture_collider = current_furniture.get_node("Collider")
	var direction_to_furniture = (furniture_collider.global_position - global_position).normalized()
	# Only care about horizonal and vertical directions, ignore diagonals
	if abs(direction_to_furniture.x) > abs(direction_to_furniture.y):
		direction_to_furniture = Vector2(direction_to_furniture.x, 0).normalized()
	else:
		direction_to_furniture = Vector2(0, direction_to_furniture.y).normalized()
	
	pulling = false
	
	# Are we still close to the furniture
	var furniture_still_close = cast_a_ray(direction_to_furniture, 9)
	#print(furniture_still_close)
	if furniture_still_close == false:
		#release_furniture()
		return false
	
	# Calculate wether we're pushing or pulling
	var dot_of_direction = direction_to_furniture.dot(push_direction)
	if dot_of_direction == -1.0:
		pulling = true
		if !cast_a_ray(push_direction, 16):
			return current_furniture._push(push_direction)
		else:
			return false
	elif dot_of_direction == 1.0:
		pulling = false
		return current_furniture._push(push_direction)
	else:
		release_furniture()
		return false
		
	return false
	
func release_furniture():
	if is_instance_valid(current_furniture):
		current_furniture._release_furniture()
	release_furniture_on_release = false
	current_furniture = null # release the furniture
