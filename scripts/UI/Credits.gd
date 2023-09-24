extends Level2D


func _input(event):
	if event.is_action_pressed("ui_accept"):
		_level_complete()

func _on_timer_timeout():
	_level_complete()
