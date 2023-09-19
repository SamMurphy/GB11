extends Node2D

@export var body_name = "Player"

signal kill_zone_entered

func _on_area_entered(body):
	if body.name == body_name:
		kill_zone_entered.emit()
