extends PhysicsBody2D

## The name of the furniture that will show up in the interactive text
@export var fancy_name : String = "This is the name of the furniture."
## The description of the furniture that will show up in the interactive text
@export var description : String = "This is the description of a piece of furniture..."
## The "Weight" of the furniture, this is the delay between pushes
@export var weight : float = 0.5
## The amount of time the object flashes for if it can't be rotated
@export var flash_time : float = 0.1

@export var velocity : Vector2

@export var is_end_game_object : bool = false

@export var base_score : int = 5
@export var proximity_furniture_range : int = 64
@export var proximity_furniture_base_score : int = 3
@export var proximity_furniture_groups : Array[String]
@export var room_bonus : String
@export var room_bonus_score : int = 5

@onready var movement = get_node("Movement")
@onready var sprite = get_node("AnimatedSprite2D")
@onready var anim = get_node("AnimationPlayer")
@onready var move_timer = get_node("FurnitureCommon/MoveTimer")
@onready var error_sound = get_node("FurnitureCommon/ErrorSound")

var interact
var end_day

var time_to_push : float = 1
var can_push : bool = false

var collision_checker_counter : int = 0
var last_direction_pushed : Vector2 = Vector2(0,0)
var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("front")
	can_push = true
	time_to_push = weight
	move_timer.wait_time = time_to_push
	move_timer.timeout.connect(_on_move_timer_timeout)
		
	var player = get_tree().get_nodes_in_group("Player")[0]	
	interact = player.get_node("DialogueInteraction").get_node("CanvasLayer").get_node("BoxOfWords")
	end_day = player.get_node("EndDayInteraction").get_node("CanvasLayer").get_node("BoxOfWords")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _entered_area():
	pass
	#anim.play("active")
	
func activateDialogue():
	interact._sayDialogue(fancy_name, description)

func endGameDialogue():
	end_day._endDayInteract()

func _get_total_score():
	var score = base_score
	
	for group in proximity_furniture_groups:
		var furniture_in_group = get_tree().get_nodes_in_group(group)
		for furniture_item in furniture_in_group:
			if furniture_item != self:
				var theirPos = furniture_item.position
				var distance = position.distance_to(theirPos)
				if distance < proximity_furniture_range && proximity_furniture_range > 0:
					score += proximity_furniture_base_score
	
	return score

func _rotate():
	if collision_checker_counter > 0:
		_flash_object()
		error_sound.play()
		return
	
	match anim.get_assigned_animation():
		"front":
			anim.play("left")
		"left":
			anim.play("back")
		"back":
			anim.play("right")
		"right":
			anim.play("front")

func _push(direction : Vector2) -> bool:
	if last_direction_pushed != direction:
		move_timer.stop()
		can_push = true
	
	if can_push == false:
		return false
		
	if direction.x == 0 && direction.y == 0:
		return false

	if direction.x < 0:
		movement._move_left()
	elif direction.x > 0:
		movement._move_right()
	elif direction.y < 0:
		movement._move_down()
	elif direction.y > 0:
		movement._move_up()

	if movement._is_at_target_position() == false && move_timer.is_stopped():
		can_push = false
		move_timer.start(time_to_push)
		
	last_direction_pushed = direction
	return true
	
func _release_furniture():
	can_push = true
	move_timer.stop()

func _on_move_timer_timeout():
	can_push = true 

func _on_collision_checker_body_entered(body):
	if body != self:
		collision_checker_counter += 1

func _on_collision_checker_body_exited(body):
	if body != self:
		collision_checker_counter -= 1

func _flash_object():
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/flash_value", 1.0, flash_time).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(sprite.material, "shader_parameter/flash_value", 0.0, flash_time).set_trans(Tween.TRANS_BOUNCE)
