extends Level2D

var current_level_stage: int = 0

@export var scenes: Array[String]
@export var van_scene : String

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the first scene in the level stages
	current_level_stage = 0
	_load_next_stage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	# Scoring
	var score = 0
	var all_furniture = get_tree().get_nodes_in_group("furniture")
	for furniture in all_furniture:
		score += furniture._get_total_score()
	
	GameGlobals.Score = score

func _load_next_stage():
	if current_level_stage < scenes.size():
		# Remove all pieces of furniture in the bin
		var binOverlaps = $game_scorer/Bin.get_overlapping_bodies()
		for bin in binOverlaps:
			if bin.is_in_group("furniture"):
				bin.queue_free()
				
		var scene_to_load = ResourceLoader.load(scenes[current_level_stage])
		var loaded_scene = scene_to_load.instantiate()
		self.add_child(loaded_scene)
		current_level_stage += 1
		
		var van_scene_instance = ResourceLoader.load(van_scene)
		var van_scene_loaded = van_scene_instance.instantiate()
		self.add_child(van_scene_loaded)
	else:
		_level_complete()
