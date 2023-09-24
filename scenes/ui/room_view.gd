extends ColorRect

@onready var game_scorer = get_node("../../../game_scorer")
# Called when the node enters the scene tree for the first time.
func _ready():
	game_scorer.player_position.connect(_update_player_location)


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _update_player_location(pos: String):
	print("Changing player position to: ", pos)
	$Room.bbcode_text = "[center]" + pos
	pass
