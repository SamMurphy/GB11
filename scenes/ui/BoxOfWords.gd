extends ColorRect

@export var text_speed = 0.05

var textBoxLimit = 20
var dialogue 

func _ready():
	$FurnitureName.bbcode_text = "This is a name"
	$Timer.wait_time = text_speed as float
	$Button.hide()
	sayDialogue("Hi", "More than 10 letters I think, here are some more letters we shall see")

	
func sayDialogue(name: String, description: String):
	$FurnitureName.bbcode_text = name
	var currentCharCount = 0
	var totalCharCount = 0
	$FurnitureDescription.bbcode_text = description.substr(0, textBoxLimit)
	$FurnitureDescription.visible_characters = 0
	while totalCharCount < len(description):
		while currentCharCount < $FurnitureDescription.get_total_character_count():			
			$FurnitureDescription.visible_characters += 1
			print("currentCharCount: ",currentCharCount)
			currentCharCount += 1
			totalCharCount += 1
			$Timer.start()
			await($Timer.timeout)
		# Wait for user input to continue, start visible characters at current character
		$Button.show()
		await($Button.button_up)
		var remainingText = len(description) - totalCharCount
		print("remainingText: ",remainingText)
		print(remainingText)
		$FurnitureDescription.bbcode_text = description.substr(totalCharCount, min(textBoxLimit, remainingText))
		currentCharCount = 0
		$Button.hide()

		
	return
	
