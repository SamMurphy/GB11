extends StaticBody2D

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

@onready var movement = get_node("Movement")
@onready var sprite = get_node("AnimatedSprite2D")
@onready var anim = get_node("AnimationPlayer")
@onready var move_timer = get_node("MoveTimer")

@onready var interact = get_node("../player/DialogueInteraction").get_node("CanvasLayer").get_node("BoxOfWords")
@onready var end_day = get_node("../player/EndDayInteraction").get_node("CanvasLayer").get_node("BoxOfWords")

var time_to_push : float = 1
var can_push : bool = false

var collision_checker_counter : int = 0

var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("front")
	can_push = true
	time_to_push = weight
	move_timer.wait_time = time_to_push

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_push == false && movement._is_at_target_position() == false && move_timer.is_stopped():
			move_timer.start(time_to_push)

func _entered_area():
	pass
	#anim.play("active")
	
func activateDialogue():
	interact._sayDialogue(fancy_name, description)

func endGameDialogue():
	end_day._endDayInteract()

func _rotate():
	if collision_checker_counter > 0:
		_flash_object()		
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

func _push(direction : Vector2):
	if can_push == false:
		return

	if direction.x < 0:
		movement._move_left()
	elif direction.x > 0:
		movement._move_right()
	elif direction.y < 0:
		movement._move_down()
	elif direction.y > 0:
		movement._move_up()

	if movement._is_at_target_position() == false:
		can_push = false

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
