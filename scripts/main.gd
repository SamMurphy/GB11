extends Node2D

@export var main_menu : PackedScene
@export var levels:Array[PackedScene]

var current_level_index = -1
var current_level : Node
var menu_scene : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_scene = main_menu.instantiate()
	add_child(menu_scene)
	menu_scene.pressed_start.connect(_on_pressed_start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed_start():
	menu_scene.queue_free()
	load_next_level()
	
func load_level(level_index : int):
	if level_index < 0 || level_index > levels.size():
		return
		
	if current_level:
		current_level.queue_free()
		
	current_level_index = level_index
	if current_level_index < levels.size():
		current_level = levels[current_level_index].instantiate()
		
	add_child(current_level)

func load_next_level():
	load_level(current_level_index + 1)
