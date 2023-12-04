extends CharacterBody2D

var dmg = 6
var original_speed = 2.5
var speed = 2.5
var target
var positive_sign = true
var health = 2
var randomnum

enum {
	SURROUND,
	ATTACK,
	HIT,
}

var state = SURROUND

func _ready():
	add_to_group("enemy")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	

func _physics_process(delta):
	speed = 1.2 * original_speed  if get_tree().get_first_node_in_group("speed") else original_speed
	target = get_tree().get_first_node_in_group("player")
	if target != null:
		if ((position - target.position).x < 0 and positive_sign) or ((position - target.position).x > 0 and !positive_sign):
			$Sprite2D.scale.x *= -1
			positive_sign = (position - target.position).x > 0
		velocity = position.direction_to(target.position) * speed
		match state:
			SURROUND:
				move(get_circle_position(randomnum), delta)
			ATTACK:
				move(target.global_position, delta)
	$AnimationPlayer.play("walk_left")
	
func move(target_pos, delta):
	var direction = (target_pos - position).normalized() 
	var desired_velocity =  direction * speed
	var steering = (desired_velocity - velocity) * delta
	velocity += steering
	move_and_collide(velocity)
	
func get_circle_position(random):
	var kill_circle_centre = target.global_position
	var radius = 40
	 #Distance from center to circumference of circle
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;
	return Vector2(x, y)
	
func is_enemy():
	return true


func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.hit(10)
	elif body.is_in_group("server"):
		body.hit(1)

