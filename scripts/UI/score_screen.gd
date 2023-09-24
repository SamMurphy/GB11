extends Level2D

@export var characters:Array[Label]
var current_index = 0

@export var score_lbl : Label

var called_complete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	level_started.emit()
	for character in characters:
		character.text = 'A'
	if score_lbl:
		var format_score = "%.3f seconds!"
		var score_string = format_score % [GameGlobals.Score]
		score_lbl.text = score_string
	var tween = create_tween()
	tween.tween_method(GameGlobals.change_fade_time, 1.0, 0.0, 1.0)#.set_trans(Tween.TRANS_BOUNCE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_left"):
		# change selection
		current_index = current_index - 1
		if current_index < 0:
			current_index = len(characters) - 1
	elif event.is_action_pressed("ui_right"):
		current_index = current_index + 1
		if current_index > len(characters) - 1:
			current_index = 0
		# change selection
	elif event.is_action_pressed("ui_up"):
		# change letter
		var current_letter = characters[current_index].text.to_upper()
		var current_unicode = current_letter.unicode_at(0)
		current_unicode = current_unicode - 1
		if (current_unicode < 65): current_unicode = 90
		characters[current_index].text = String.chr(current_unicode)
	elif event.is_action_pressed("ui_down"):
		# change letter
		var current_letter = characters[current_index].text.to_upper()
		var current_unicode = current_letter.unicode_at(0)
		current_unicode = current_unicode + 1
		if (current_unicode > 90): current_unicode = 65
		characters[current_index].text = String.chr(current_unicode)
	elif event.is_action_pressed("ui_accept"):
		if !called_complete:
			called_complete = true
			send_score()
			
func send_score():
	var name = ""
	for character in characters:
		name += character.text
	var format_score = "%.3f"
	var score_string = format_score % [GameGlobals.Score]
	var score_data = name + '&' + score_string
	$SendScoreRequest.request_completed.connect(_on_request_completed)
	var headers = ["User-Agent: GodotEngine", "Access-Control-Allow-Origin: '*'", "Content-type: text/plain"]
	$SendScoreRequest.request("https://bananafacts.co.uk:5232/setscorepls", headers, HTTPClient.METHOD_POST, score_data)
	
func _on_request_completed(result, response_code, headers, body):
	_level_complete()
