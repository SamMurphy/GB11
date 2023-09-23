extends ColorRect

@export var text_speed = 0.05

var textBoxLimit = 20



@onready var select = get_node("Selected")

signal choice
var endDay = false

func _ready():
	$Timer.wait_time = text_speed as float

func hideAll():
	$EndDay.hide()
	$Yes.hide()
	$No.hide()
	self.hide()

func _input(ev):
	var xDirection = Input.get_axis("DPad_left", "DPad_right")
	
	if (xDirection < 0):
		endDay = true
		select.set_position(Vector2(21, 26))
	elif(xDirection > 0):
		endDay = false
		select.set_position(Vector2(58, 26))
	if Input.is_action_just_pressed("A"):
		choice.emit(endDay)
		print(endDay)
		hideAll()
	
func _endDayInteract():
	var currentCharCount = 0
	var totalCharCount = 0
	$EndDay.visible_characters = 0
	$Yes.show()
	$No.show()
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
	
