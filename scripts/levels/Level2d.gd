extends Node2D

class_name Level2D

signal level_started
signal level_complete
signal level_restart

# Called when the node enters the scene tree for the first time.
func _ready():
	level_started.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _level_complete():
	level_complete.emit()
	
func _restart_level():
	level_restart.emit()
