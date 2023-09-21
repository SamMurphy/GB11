extends ColorRect

@export var text_speed = 0.05

var textBoxLimit = 20
var dialogue 


func _ready():
	$FurnitureName.bbcode_text = "This is a name"
	$Timer.wait_time = text_speed as float
	hideAll()
	# for debug purposes, will be called by specific furniture item which will give it name and desc
	sayDialogue("Djunkelskog", "This is a nice bear shaped object, also shaped like friend!")

func hideAll():
	$FurnitureName.hide()
	$FurnitureDescription.hide()
	$Button.hide()
	self.hide()
	
func sayDialogue(name: String, description: String):
	$FurnitureName.bbcode_text = name
	var currentCharCount = 0
	var totalCharCount = 0
	$FurnitureDescription.bbcode_text = description.substr(0, textBoxLimit)
	$FurnitureDescription.visible_characters = 0
	$FurnitureName.show()
	$FurnitureDescription.show()	
	self.show()
	
	# Loop through remaining text
	while totalCharCount < len(description):
		while currentCharCount < $FurnitureDescription.get_total_character_count():			
			$FurnitureDescription.visible_characters += 1
			currentCharCount += 1
			totalCharCount += 1
			$Timer.start()
			await($Timer.timeout)
		# Wait for user input to continue, start visible characters at current character
		$Button.show()
		await($Button.button_up)
		
		#Set up string for next window
		var remainingText = len(description) - totalCharCount
		$FurnitureDescription.visible_characters = 0
		if (remainingText > 0):
			$FurnitureDescription.bbcode_text = description.substr(totalCharCount, min(textBoxLimit, remainingText))
		currentCharCount = 0
		$Button.hide()
	hideAll()
			
	return
	
