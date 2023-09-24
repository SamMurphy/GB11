extends Node2D

@export var tracks : Array[AudioStreamPlayer]

var current_song_index : int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	play_next_song()
	
func play_next_song():	
	if current_song_index >= 0:
		var current_track = tracks[current_song_index]
		current_track.finished.disconnect(track_finished)
		if current_track.is_playing():
			current_track.stop()
	
	current_song_index = current_song_index + 1
	if current_song_index >= tracks.size():
		current_song_index = 0
	
	var next_track = tracks[current_song_index]
	next_track.finished.connect(track_finished)
	next_track.play()


func track_finished():
	play_next_song()
