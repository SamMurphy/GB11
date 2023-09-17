extends Level2D

@export var scores_label : Label
@export var position_label : Label
@export var time_label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	var headers = ["User-Agent: GodotEngine", "Access-Control-Allow-Origin: '*'", "Content-type: text/plain"]
	# Get the high scores
	$ScoresRequest.request_completed.connect(_on_scores_request_completed)
	$ScoresRequest.request("https://bananafacts.co.uk:5232/getscorespls", headers, HTTPClient.METHOD_GET)
	# Get the users position in the leaderboard
	$PositionRequest.request_completed.connect(_on_position_request_completed)
	$PositionRequest.request("https://bananafacts.co.uk:5232/getpostionpls?" + str(GameGlobals.Score), headers, HTTPClient.METHOD_GET)
	# Set time label
	var format_score = "%.3f"
	var score_string = format_score % [GameGlobals.Score]
	time_label.text = score_string + " seconds"

func _on_scores_request_completed(result, response_code, headers, body):
	var data = body.get_string_from_utf8()
	print("SCORES:")
	print(data)
	if scores_label:
		scores_label.text = data

func _on_position_request_completed(result, response_code, headers, body):
	var data = body.get_string_from_utf8()
	print("POSITION:")
	print(data)
	if position_label:
		position_label.text = "You finished " + data + "!"
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		_level_complete()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
