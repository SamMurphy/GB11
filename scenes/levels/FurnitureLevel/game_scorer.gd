extends Node2D

# Called when the node enters the scene tree for the first time.
signal player_position

func _ready():
	pass

func _broadcast_player_group():
	pass
	
func _check_all_groups():
	var all_rooms = get_tree().get_nodes_in_group("score_item")
	for room in all_rooms:
		_check_group(room)

func _check_group(room: Area2D):
	# Get group of room
	var room_type = room.get_groups()[0] #LOL hardcoded array access, love it
	
	# True positive = correct item in correct room
	# True negative = wrong item in wrong room
	
	#Get the items in the room
	var score = 0
	for item in room.get_overlapping_bodies():
		if item.name == "player":
			#print("playerrrrrrrr is in: ", room.name)
			player_position.emit(room.name)
		#Get groups of item
		#print("body thing: ",item)
		var is_correct_group = false
		for group in item.get_groups():
			if group == room_type:
				is_correct_group = true
				score += 1
	
	# Get all the objects of this room type
	var other_items = get_tree().get_nodes_in_group(room_type)
	if ((len(other_items)-1) > 0):
		var scaled_score = score/(len(other_items)-1)
		print("Score: ", scaled_score)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	_check_all_groups()
