extends ColorRect

@export var text_speed = 0.05

var dialogue 

func _ready():
	print_tree_pretty()
	$FurnitureName.bbcode_text = "This is a name"
	$Timer.wait_time = text_speed as float
	sayDialogue()		
	
func setDialogue(d: String):
	dialogue = d
	
func sayDialogue():
	$FurnitureName.bbcode_text = "This is a name"
	$FurnitureDescription.bbcode_text = "This is a description"
	$FurnitureDescription.visible_characters = 0
	while $FurnitureDescription.visible_characters < len($FurnitureDescription.text):
		$FurnitureDescription.visible_characters += 1
		$Timer.start()
		await($Timer.timeout)
	return
	
