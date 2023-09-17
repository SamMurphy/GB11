extends Node2D

@export var body_name = "Player"

signal end_zone_entered

func _on_area_entered(body):
	if body.name == body_name:
		end_zone_entered.emit()
