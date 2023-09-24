extends Node2D

signal pressed_start

func _input(event):
	if event.is_action_pressed("A") || event.is_action_pressed("A") || event.is_action_pressed("ui_accept"):
		pressed_start.emit()
