extends Node2D

@onready var label = get_node("CanvasLayer/Label")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if label:
		var format_score = "Score: %s"
		var score_string = format_score % [GameGlobals.Score]
		label.text = score_string
