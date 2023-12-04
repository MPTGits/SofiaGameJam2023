extends Node2D

var session_id = null

func _ready():
	$Battle.play()
	
func _process(delta):
	var http = get_node('HTTP')
	if http and http.session_id and session_id == null:
		var session = get_node("Camera2D/session")
		session.text = "Session ID: " + str(http.session_id)
		
