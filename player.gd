extends CharacterBody2D

var current_animation = "idle"
var speed = 400
var angle = 0
var num_rotation_sectors = 8
@export var bullet_scene : PackedScene

func get_input():
	if Input.is_action_just_pressed("shoot"):
		shoot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	current_animation = "idle"
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if input_dir.length() != 0:
		current_animation = "idle"
	velocity = input_dir * speed
	move_and_slide()
	
	$AnimatedSprite2D.play(current_animation + str(get_mouse_position_sector()))
	
func shoot():
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Muzzle.global_transform
	
func get_mouse_position_sector():
	# Get the global mouse position
	var mouse_position = get_global_mouse_position()
	# Calculate the direction vector from character to mouse
	var direction = (mouse_position - global_transform.origin).normalized()
	# Calculate the angle in radians using atan2
	var angle_radians = atan2(direction.x, -direction.y)
	# Convert radians to degrees
	var angle_degrees = rad_to_deg(angle_radians)
	# Calculate which sector the angle falls into (0 to 7)
	var sector_idx = (int((angle_degrees + 11.5) / 45.0)) % num_rotation_sectors
	# If the angle is in between 180 and 360 degrees it get values -3 to -1 so substract from num sectors
	return sector_idx if sector_idx >= 0 else num_rotation_sectors + sector_idx
