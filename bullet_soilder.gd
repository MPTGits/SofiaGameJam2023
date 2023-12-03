extends Area2D

@export var speed = 1250

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_bullet_body_entered(body):
	if body.is_in_group("player"):
		body.hit(10)
		queue_free()
