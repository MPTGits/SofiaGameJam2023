extends Node

const api_root = 'https://mainframe-attack-f7ede90d23ea.herokuapp.com/'
var session_id = null
var is_timeout = false
var summary_board = {}
var is_terminated = false
var is_sleep = false
func _ready():
	$HTTPRequest.request_completed.connect(_on_request_completed)
	get_session()


func get_session(session_id=null):
	if session_id:
		$HTTPRequest.request(api_root + 'start_session?password=test_password&session_id=' + str(session_id))
	else:
		$HTTPRequest.request(api_root + 'start_session?password=test_password')

func get_data(session_id: int):
	$HTTPRequest.request(api_root + 'pull_to_godot?password=test_password&session_id=' + str(session_id))

func terminate():
	is_terminated = true
	$HTTPRequest.request(api_root + 'admin_terminate?password=test_password&session_id=' + str(session_id))


func _process(delta):
	if is_terminated:
		return
	var servers = get_tree().get_nodes_in_group("server")
	var broken_servers = 0
	for s in servers:
		if s and s.health <=0:
			broken_servers += 1
	if broken_servers == 3:
		terminate()
		return
	var health_bar = get_tree().get_first_node_in_group("health")
	if not health_bar:
		terminate()
		return
	if session_id:
		if is_timeout:
			return 
		get_data(session_id)
		
		
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	if json['req_type'] == 'start_session':
		_on_session_received(json)
	elif json['req_type'] == 'pull_to_godot':
		print(json)
		if 'terminate' in json:
			print(json['summary'])
			remove_enemies()
			var summarry = get_tree().get_first_node_in_group("summary")
			summarry.data = json
			is_terminated = true
			#summarry.visable = true
			return
		_on_data_received(json)
	elif json['req_type'] == 'admin_terminate':
		get_data(session_id)
	
func remove_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.queue_free()
	is_terminated = true

func _on_session_received(json):
	if 'error' in json:
		session_id = null
		get_session()
	else:
		session_id = json["session_id"]
	
func _on_data_received(json):
	if 'error' in json:
		get_session(session_id)
		get_data(session_id)
	else:
		print(json)
		for e in json['enemy_list']:
			var enemy_scene = get_enemy_scene(e['type']).instantiate()
			var random_number1 = randi_range(-1000, 1000)
			var random_number2 = randi_range(-1000, 1000)
			enemy_scene.position = Vector2(random_number1, random_number2)
			get_tree().get_root().add_child(enemy_scene)
			if e['user'] in summary_board:
				summary_board[e['user']][e['type']] += 1
		is_timeout = true
		$Timer.start()
			
func get_enemy_scene(enemy_type):
	if enemy_type == "Samurai":
		return preload("res://samurai.tscn")
	elif enemy_type == "Minotaur":
		return preload("res://bull.tscn")
	elif enemy_type == "Zombie":
		return preload("res://zombie.tscn")
	elif enemy_type == "Modern Warfare Soldier":
		return preload("res://soilder.tscn")
	elif enemy_type == "Donald Trump":
		return preload("res://donald_trump.tscn")
	elif enemy_type == "Star Platinum":
		return preload("res://jojo.tscn")


func _on_timer_timeout():
	is_timeout = false


func _on_timer_2_timeout():
	is_sleep = false
