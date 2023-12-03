extends Label

func _ready():
	# Set the timer for the label to disappear
	pass

func _on_Timer_timeout():
	queue_free()  # Remove the label after the timer expires
