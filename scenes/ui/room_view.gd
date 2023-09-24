extends ColorRect

var count_enabled = false

@onready var game_scorer = get_node("../../../game_scorer")
@onready var end_game = get_node("../../EndDayInteraction/CanvasLayer/BoxOfWords")
# Called when the node enters the scene tree for the first time.
func _ready():
	game_scorer.player_position.connect(_update_player_location)
	end_game.popup.connect(_enable_popup)
	
func _enable_popup():
	count_enabled = true

func _process(delta):
	if Input.is_action_just_pressed("Select"):
		count_enabled = !count_enabled
	if count_enabled:
		$Count.show()
		self.size = Vector2(80,40)
	else:
		self.size = Vector2(80,20)
		$Count.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _update_player_location(pos: String):
	$Room.bbcode_text = "[center]" + pos

func _update_player_score(score: int, total: int):
	if total == 0:
		$Count.bbcode_text = "No required"
	else:
		$Count.bbcode_text = str(score) + " of " + str(total)
	
