extends Level2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scoreModifier = 1
	GameGlobals.Score += scoreModifier * delta

func _on_end_zone_entered():
	_level_complete()

func _on_kill_zone_entered():
	_restart_level()
