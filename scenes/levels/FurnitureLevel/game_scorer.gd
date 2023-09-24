extends Node2D

# Called when the node enters the scene tree for the first time.
signal player_position
signal can_scene_end
signal player_score(score, total)

func _ready():
	pass
	
func _check_all_groups():
	var all_rooms = get_tree().get_nodes_in_group("score_item")
	var is_furniture_correct = true
	for room in all_rooms:
		if !_check_group(room):
			is_furniture_correct = false
	can_scene_end.emit(is_furniture_correct)
	
func _check_group(room: Area2D):
	# Get group of room
	
	var room_type = room.get_groups()[0] #LOL hardcoded array access, love it	
	# True positive = correct item in correct room
	# True negative = wrong item in wrong room
	
	#Get the items in the room
	var isPlayerRoom = false
	var score = 0
	for item in room.get_overlapping_bodies():
		if item.name == "player":
			isPlayerRoom = true
			player_position.emit(room.name)
		#Get the groups that the item belongs to
		var is_correct_group = false
		for group in item.get_groups():
			if group == room_type:
				is_correct_group = true
				score += 1
	
	# Get all the objects of this room type
	var other_items = get_tree().get_nodes_in_group(room_type)		 
	
	if isPlayerRoom:		
		if ((len(other_items)-1) > 0):
			var scaled_score = score/(len(other_items)-1)
			player_score.emit(score, len(other_items)-1)
		else:
			player_score.emit(0,0)
	return len(other_items)-1 == score
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	_check_all_groups()
