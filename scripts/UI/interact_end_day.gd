extends ColorRect

@export var text_speed = 0.05

var textBoxLimit = 20

var can_end_day = false

@onready var select = get_node("Selected")
@onready var game_scorer = get_node("../../../../game_scorer")

signal choice
signal dialogue_finished
signal popup
var endDay = false

func _ready():
	$Timer.wait_time = text_speed as float
	game_scorer.can_scene_end.connect(_update_end_day)
	hideAll()

func hideAll():
	$EndDay.hide()
	$Yes.hide()
	$No.hide()
	$CantEnd.hide()
	self.hide()

func _input(ev):
	var xDirection = Input.get_axis("DPad_left", "DPad_right")
	
	if (xDirection < 0):
		endDay = true
		select.set_position(Vector2(21, 26))
	elif(xDirection > 0):
		endDay = false
		select.set_position(Vector2(58, 26))
	if Input.is_action_just_pressed("A") && is_visible():
		if (!can_end_day && endDay):
			$EndDay.hide()
			$Yes.hide()
			$No.hide()
			$Selected.hide()
			var savedSize = self.size
			var savedPos = self.position
			self.size = Vector2(120,60)
			self.position = Vector2(20, 50)
			$CantEnd.show()
			print("Can't end day!")
			$EndTimer.start()
			await($EndTimer.timeout)
			hideAll()
			dialogue_finished.emit()
			popup.emit()
			self.size = savedSize
			self.position = savedPos
		else:
			choice.emit(endDay)
			hideAll()
			dialogue_finished.emit()

			
func _display_cant_end():
	pass

func _update_end_day(end: bool):
	can_end_day = end
	
func _endDayInteract():
	var currentCharCount = 0
	var totalCharCount = 0
	$EndDay.visible_characters = 0
	$Yes.show()
	$No.show()
	$Selected.show()
	$EndDay.show()	
	self.show()
	
	# Loop through remaining text
	while currentCharCount < $EndDay.get_total_character_count():			
		$EndDay.visible_characters += 1
		currentCharCount += 1
		totalCharCount += 1
		$Timer.start()
		await($Timer.timeout)

	return	
