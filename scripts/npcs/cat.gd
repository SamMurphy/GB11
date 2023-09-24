extends CharacterBody2D

enum CatState 
{ 
	IDLE, # standing and transitions to random state after some time
	SLEEP, # sleeping and transitions to random state after some time
	RANDOM_MOVE # move to a randomly chosen and transition to random state on arrival
}

# Start a transition to IDLE
var current_state = CatState.SLEEP
var next_state = CatState.RANDOM_MOVE

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
		CatState.RANDOM_MOVE:
			_update_random_move(is_start)
		
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
		_random_transition([CatState.SLEEP, CatState.RANDOM_MOVE])
	
@export var sleep_min = 30
@export var sleep_max = 60

func _update_sleep(is_start):
	if is_start:
		$AnimationPlayer.play("Sleep")
		self._restart_timer(sleep_min, sleep_max)
		
	if $Timer.is_stopped():
		_random_transition([CatState.IDLE, CatState.RANDOM_MOVE])
		
@export var random_move_min = 5
@export var random_move_max = 10		

func _update_random_move(is_start):
	if is_start:
		$AnimationPlayer.play("Walk")
		self._restart_timer(random_move_min, random_move_max)
		
	_move_random()
	
	if $Timer.is_stopped():
		_random_transition([CatState.IDLE, CatState.SLEEP])
	
func _move_random():
	var move_funcs : Array[Callable] = [
		Callable($Movement, "_move_left"),
		Callable($Movement, "_move_right"),
		Callable($Movement, "_move_up"),
		Callable($Movement, "_move_down")
	]
	
	move_funcs.pick_random().call()
