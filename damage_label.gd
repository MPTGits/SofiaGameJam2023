extends Node2D

@export var speed: int = 30
@export var friction: int = 15
var shift_direction: Vector2 = Vector2.ZERO

var label

# Called when the node enters the scene tree for the first time.
func _ready():
	shift_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	label = $Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += speed * shift_direction * delta
	speed = max(speed - friction * delta, 0)
