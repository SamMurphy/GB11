extends Node2D

signal pressed_start

func _input(event):
	if event is InputEventKey and event.pressed:
		pressed_start.emit()
