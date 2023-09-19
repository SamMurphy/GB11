extends Node2D

@export var main_menu_path : String
@export var level_paths : Array[String]

var current_level_index = -1
var current_level : Node
var menu_scene : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	load_main_menu()
	
func load_main_menu():
	GameGlobals.ResetGame()
	var menu_packed_scene = ResourceLoader.load(main_menu_path)
	menu_scene = menu_packed_scene.instantiate()
	add_child(menu_scene)
	menu_scene.pressed_start.connect(_on_pressed_start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed_start():
	menu_scene.pressed_start.disconnect(_on_pressed_start)
	menu_scene.queue_free()
	load_next_level()
	
func load_level(level_index : int):
	if level_index < 0 || level_index > level_paths.size():
		return
		
	if current_level:
		disconnect_signals(current_level)
		current_level.queue_free()

	current_level_index = level_index
	if current_level_index < level_paths.size():
		var new_packed_scene = ResourceLoader.load(level_paths[current_level_index])
		current_level = new_packed_scene.instantiate()
		connect_signals(current_level)
		add_child(current_level)
	else:
		current_level = null
		current_level_index = -1
		load_main_menu()
		
func connect_signals(level : Node):
	level.level_started.connect(level_started)
	level.level_complete.connect(level_complete)
	level.level_restart.connect(reload_level)
	
func disconnect_signals(level : Node):
	level.level_started.disconnect(level_started)
	level.level_complete.disconnect(level_complete)
	level.level_restart.disconnect(reload_level)

func load_next_level():
	load_level(current_level_index + 1)
	
func level_started():
	pass
	
func level_complete():
	load_next_level()
	
func reload_level():
	load_level(current_level_index)
