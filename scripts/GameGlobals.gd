extends Node

var Score : float

func ResetGame():
	Score = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_fade_time(fade_time : float):
	RenderingServer.global_shader_parameter_set("transition_amount", fade_time)
