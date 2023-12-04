extends CharacterBody2D

const label_dmg : PackedScene = preload("res://damage_label.tscn")

var health = 40
var is_broken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		is_broken = true
		$Sprite2D.texture = preload("res://server-broken.png")
		return

func hit(damage: float, knockback_strenghth: Vector2 = Vector2(0,0), stop_time: float = 0.25):
	if(health <= 0):
		return
	health -= damage
	display_damage(damage, position)

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


func _on_area_2d_body_entered(body):
	if body.is_in_group('enemy'):
		hit(1)
		var knockback_speed = 200
		body.position = (position - body.position).normalized()
		body.move_and_collide(body.position)
