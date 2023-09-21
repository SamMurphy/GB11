extends CharacterBody2D

enum CatState 
{ 
	IDLE, # standing and transitions to random state after some time
	SLEEP, # sleeping and transitions to random state after some time
	MOVE # move to a randomly chosen and transition to random state on arrival
}

# Start a transition to IDLE
var current_state = CatState.SLEEP
var next_state = CatState.IDLE

func _ready():
	pass
	
func _physics_process(delta):
	var is_start = next_state != current_state
	
	if is_start:
		print("Cat Entering state: ", CatState.keys()[next_state])
		current_state = next_state
	
	match current_state:
		CatState.IDLE:
			_update_idle(is_start)
		CatState.SLEEP:
			_update_sleep(is_start)
		CatState.MOVE:
			_update_move(is_start)
		
func _restart_timer(min, max):
		$Timer.stop()	
		$Timer.wait_time = randi_range(min, max)
		$Timer.start()	
		
func _random_transition(state_list : Array):
	state_list.shuffle()
	next_state = state_list.front()
	
@export var idle_min = 5
@export var idle_max = 10

func _update_idle(is_start):
	if is_start:
		$AnimationPlayer.play("Idle")
		self._restart_timer(idle_min, idle_max)
		
	if $Timer.is_stopped():
		_random_transition([CatState.SLEEP, CatState.MOVE])
	
@export var sleep_min = 30
@export var sleep_max = 60

func _update_sleep(is_start):
	if is_start:
		$AnimationPlayer.play("Sleep")
		self._restart_timer(sleep_min, sleep_max)
		
	if $Timer.is_stopped():
		_random_transition([CatState.IDLE, CatState.MOVE])
		
func _update_move(is_start):
	if is_start:
		$AnimationPlayer.play("Walk")
		
	# need to do some movement here
	$Movement._move_down()
