extends AnimatedSprite2D

var health = 500;
var icon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frame = 6 - health / 100
	if Input.is_action_just_pressed("H"):
		health = 200
