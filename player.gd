extends CharacterBody2D


var current_animation = "idle"
var speed = 270
var positive_sign = get_local_mouse_position().x >= 0
var facing_right = true
var can_attack = true
var knockback: Vector2 = Vector2.ZERO
var knockback_tween
@export var bullet_scene : PackedScene
const label_dmg : PackedScene = preload("res://damage_label.tscn")

func _ready():
	add_to_group("player")


func get_input():
	if Input.is_action_just_pressed("shoot"):
		$AnimationPlayer.play("walk_attack")
		shoot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	var mouse_position = get_local_mouse_position()
	if (mouse_position.x > 0 and positive_sign == false) or (mouse_position.x < 0 and positive_sign == true):
		$Sprite2D.scale.x *= -1
	positive_sign = mouse_position.x > 0
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if input_dir.length() == 0:
		$AnimationPlayer.play("idle")
	velocity = (input_dir + knockback) * speed
	if input_dir.x != 0:
		facing_right = positive_sign

	if is_walking_backwards(input_dir):
		velocity /= 2
	var collision = move_and_collide(velocity * delta)
	$AnimationPlayer.play("walk")
	
func shoot():
	if can_attack:
		var b = bullet_scene.instantiate()
		get_tree().root.add_child(b)
		b.transform = $Sprite2D/Muzzle.global_transform
		if (randi() % 101) > 50:
			$attack1.play()
		else:
			$attack2.play()
		can_attack = false
		$Timer.start()

func is_walking_backwards(input_vector: Vector2) -> bool:
	return (facing_right && input_vector.x < 0) || (!facing_right && input_vector.x > 0)

func _on_Timer_timeout():
	can_attack = true

func is_player():
	return true
	
func hit(damage: float, knockback_strenghth: Vector2 = Vector2(0,0), stop_time: float = 0.25):
	$HealthBar.health -= damage
	var rand = (randi() % 101) 
	if rand > 30 and rand < 40:
		$hurt1.play()
	if rand > 50 and rand < 70:
		$hurt2.play()
	display_damage(damage, position)
	if($HealthBar.health <= 0):
		queue_free()
	elif(knockback != Vector2.ZERO):
		velocity = position + knockback_strenghth
		move_and_collide(velocity)

func spawn_effect(ef: PackedScene):
	if ef:
		var effect = ef.instantiate()
		effect.global_position = position
		get_tree().current_scene.add_child(effect)
		return effect

func display_damage(damage_amount, position):
	var damage_label = spawn_effect(label_dmg)
	if damage_label:
		damage_label.label.text = str(damage_amount)
	


func _on_hurtbox_body_entered(body):
	if body.is_in_group("enemy"):
		if (randi() % 101) > 80:
			var attack_audio = body.get_node("attack")
			if attack_audio != null:
				attack_audio.play()
		hit(body.dmg)
