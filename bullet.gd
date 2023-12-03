extends Area2D

@export var speed = 1000

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_bullet_body_entered(body):
	if body.is_in_group("player"):
		return
	if body.is_in_group("enemy"):
		if body.health == 0:
			body.queue_free()
		else:
			body.health -= 1
			if (randi() % 101) > 85:
				var hurt_audio = body.get_node('hurt')
				if hurt_audio != null:
					hurt_audio.play()
	queue_free()
