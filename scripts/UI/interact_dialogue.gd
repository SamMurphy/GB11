extends ColorRect

@export var text_speed = 0.05

var dialogue 

func _ready():
	$Timer.set_wait_time = text_speed
	sayDialogue()
	
func _process(_delta):
	if (Input.is_action_just_pressed("ui_accept")):
		pass
		
	
func setDialogue(d: String):
	dialogue = d
	
func sayDialogue():
	$FurnitureName.bbcode_text = "This is a name"
	$FurnitureDescription.bbcode_text = "This is a desc"
	$FurnitureDescription.visible_characters = 0
	while $FurnitureDescription.visible_characters < len($FurnitureDescription.text):
		$FurnitureDescription.visible_characters += 1
		$Timer.start()
		await($Timer.timeout)
	return
	
