extends ColorRect

@onready var game_scorer = get_node("../../../game_scorer")
# Called when the node enters the scene tree for the first time.
func _ready():
	game_scorer.player_position.connect(_update_player_location)
	game_scorer.player_score.connect(_update_player_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _update_player_location(pos: String):
	$Room.bbcode_text = "[center]" + pos

func _update_player_score(score: int, total: int):
	if total == 0:
		$Count.bbcode_text = "No required"
	else:
		$Count.bbcode_text = str(score) + " of " + str(total)
	
